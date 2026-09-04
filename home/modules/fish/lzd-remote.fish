function lzd-remote
    set -l host $argv[1]
    set -l remote_sock $argv[2]
    if test -z "$host" || test -z "$remote_sock"
        echo "Usage: lzd-remote <ssh-host> <remote-socket-path>"
        return 1
    end
    set -l sock /tmp/remote-docker-(string replace -a '@' '_' -- $host).sock
    rm -f $sock
    ssh -o ExitOnForwardFailure=yes -nNT -L $sock:$remote_sock $host &
    set -l ssh_pid $last_pid
    for i in (seq 1 50)
        test -S $sock && break
        sleep 0.1
    end
    if not test -S $sock
        echo "Failed to establish SSH tunnel"
        kill $ssh_pid 2>/dev/null
        return 1
    end
    trap "kill $ssh_pid 2>/dev/null; rm -f $sock" EXIT
    DOCKER_HOST="unix://$sock" lazydocker
    kill $ssh_pid 2>/dev/null
    rm -f $sock
end
