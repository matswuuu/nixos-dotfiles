#!/usr/bin/env bash
# Unlock the Bitwarden vault once per graphical login and stash the session key
# for the fish conf.d snippet to pick up.
#
# Arguments:
#   $1 = bw binary          $4 = sops email path
#   $2 = askpass script     $5 = session file to write
#   $3 = sops baseUrl path  $6 = jq binary
set -uo pipefail

bw=$1
askpass=$2
base_url_file=$3
email_file=$4
session_file=$5
jq_bin=$6

# sops secret files are 0400 and may carry a trailing newline.
read_secret() {
  tr -d '\n' <"$1"
}

if [ ! -r "$base_url_file" ] || [ ! -r "$email_file" ]; then
  echo "bitwarden: sops secrets not readable yet; is sops-nix activated?" >&2
  exit 1
fi

base_url=$(read_secret "$base_url_file")
email=$(read_secret "$email_file")

# `bw config server` rewrites only urls.base, so the tokens bw writes into
# ~/.config/Bitwarden CLI/data.json at login survive. Do not manage that file
# with a sops template -- it would be clobbered on every activation.
if ! "$bw" config server "$base_url" >/dev/null; then
  echo "bitwarden: failed to set server to $base_url" >&2
  exit 1
fi

status=$("$bw" status 2>/dev/null | "$jq_bin" -r '.status // "unauthenticated"')

# The master password comes from a pinentry dialog and is never written to
# disk. askpass echoes it, we hand it to bw through the environment, then drop
# it again.
BW_PASSWORD=$("$askpass")
if [ -z "$BW_PASSWORD" ]; then
  echo "bitwarden: unlock aborted" >&2
  exit 1
fi
export BW_PASSWORD

case "$status" in
  unauthenticated)
    # The CLI keeps its own login state, separate from the desktop app, so the
    # very first run lands here. An account with 2FA enabled cannot complete an
    # unattended login -- that needs a one-off interactive `bw login`.
    if ! session=$("$bw" login "$email" --passwordenv BW_PASSWORD --raw 2>&1); then
      echo "bitwarden: unattended login failed: $session" >&2
      echo "bitwarden: if 2FA is enabled, run 'bw login' once in a terminal." >&2
      exit 1
    fi
    ;;
  *)
    if ! session=$("$bw" unlock --passwordenv BW_PASSWORD --raw 2>&1); then
      echo "bitwarden: unlock failed: $session" >&2
      exit 1
    fi
    ;;
esac

unset BW_PASSWORD

if [ -z "$session" ]; then
  echo "bitwarden: bw returned an empty session key" >&2
  exit 1
fi

# The session key decrypts the whole vault, so keep it owner-only.
umask 077
mkdir -p "$(dirname "$session_file")"
printf '%s' "$session" >"$session_file"

# `--session` rather than the environment: BW_SESSION is already unset above.
"$bw" sync --session "$session" --quiet >/dev/null 2>&1 ||
  echo "bitwarden: initial sync failed" >&2
