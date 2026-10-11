# Session key produced by bitwarden-unlock.service at graphical login.
# Exporting BW_SESSION leaves `bw` working verbatim -- no wrapper function to
# shadow it, and the key reaches scripts and pipelines too.
set -g BITWARDEN_SESSION_FILE "$XDG_RUNTIME_DIR/bitwarden/session"

if test -r $BITWARDEN_SESSION_FILE
    set -gx BW_SESSION (cat $BITWARDEN_SESSION_FILE)
end
