#!/usr/bin/env bash
# Ask for the Bitwarden master password in a GUI dialog and echo it on stdout.
#
# bw has no pinentry support of its own, so the service drives
# pinentry-gnome3 over the Assuan protocol itself. The password is only ever
# held in a pipe and an environment variable; nothing touches disk.
set -uo pipefail

response=$(
  printf 'SETTITLE Bitwarden\nSETDESC Unlock the vault\nSETPROMPT Master Password:\nGETPIN\n' |
    "${PINENTRY}" 2>/dev/null
)

password=$(printf '%s\n' "$response" | sed -n 's/^D //p')

if [ -z "$password" ]; then
  # Empty means the dialog was cancelled or pinentry failed. Either way there
  # is nothing to hand to bw, so fail rather than let it try to read a TTY.
  echo "bitwarden: no password entered" >&2
  exit 1
fi

printf '%s' "$password"
