function bwunlock -d "Re-run the Bitwarden unlock service to refresh BW_SESSION"
    # The service is a oneshot with RemainAfterExit, so it needs an explicit
    # restart before it will prompt again.
    systemctl --user restart bitwarden-unlock.service

    if set -q BITWARDEN_SESSION_FILE; and test -r $BITWARDEN_SESSION_FILE
        set -gx BW_SESSION (cat $BITWARDEN_SESSION_FILE)
        echo "Bitwarden vault unlocked"
    else
        echo "Unlock failed; see 'systemctl --user status bitwarden-unlock'" >&2
        return 1
    end
end
