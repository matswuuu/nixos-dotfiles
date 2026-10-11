function bwlock -d "Lock the Bitwarden vault and drop the cached session key"
    if not set -q BITWARDEN_SESSION_FILE
        set -g BITWARDEN_SESSION_FILE "$XDG_RUNTIME_DIR/bitwarden/session"
    end

    if command bw lock
        rm -f $BITWARDEN_SESSION_FILE
        set -e BW_SESSION
    else
        return 1
    end
end
