function dp -d "Profile a Java app in a local Docker container with async-profiler"
    set -l container $argv[1]
    set -l event $argv[2]
    set -l duration $argv[3]
    set -l output_dir $argv[4]

    if test -z "$container"
        echo "Usage: dp <container> [event] [duration] [output_dir]"
        echo ""
        echo "Events: cpu (default), wall, alloc, lock, itimer"
        echo "Duration: seconds (default: 30)"
        echo "Output: directory for flame graphs (default: /tmp/profiling)"
        return 1
    end

    test -z "$event" && set event cpu
    test -z "$duration" && set duration 30
    test -z "$output_dir" && set output_dir /tmp/profiling

    set -l prof_base (ls -d /usr/java/async-profiler-*linux-x64 2>/dev/null | head -1)
    if test -z "$prof_base"
        echo "Error: async-profiler not found (looked in /usr/java/async-profiler-*linux-x64)"
        return 1
    end

    mkdir -p $output_dir

    set -l pid (docker exec $container pgrep -o java 2>/dev/null)
    if test -z "$pid"
        echo "Error: No Java process found in container '$container'"
        return 1
    end

    set -l capline (docker exec $container grep CapEff /proc/1/status 2>/dev/null)
    set -l has_ptrace (printf '%s' "$capline" | awk '{match($0, /0x?([0-9a-fA-F]+)/, m); print (and(strtonum("0x" m[1]),524288)?"True":"False")}' 2>/dev/null)
    set -l seccomp (docker exec $container awk '/^Seccomp:/{print $2}' /proc/self/status 2>/dev/null)
    if test -z "$has_ptrace" || test "$has_ptrace" = "False" || test "$seccomp" = "2"
        echo ""
        echo "Profiling requirements for container '$container':"
        if test "$has_ptrace" = "False"
            echo "  [MISSING] SYS_PTRACE capability (cap_add)"
        else
            echo "  [OK]      SYS_PTRACE capability"
        end
        if test "$seccomp" = "2"
            echo "  [WARNING] Default seccomp profile active - perf_event_open may be blocked (use -e ctimer if cpu fails)."
        else
            echo "  [OK]       no seccomp filter"
        end
        echo "Capabilities/privileges matter for perf events, not for basic attach."
    end

    echo "Profiling PID $pid in container '$container' (event=$event, duration="$duration"s)..."

    docker exec $container mkdir -p "$prof_base/lib" "$prof_base/bin"
    docker cp "$prof_base/lib/libasyncProfiler.so" "$container:$prof_base/lib/libasyncProfiler.so"
    docker cp "$prof_base/bin/asprof" "$container:$prof_base/bin/asprof"
    docker exec $container chmod +x "$prof_base/bin/asprof"

    set -l ts (date +%Y%m%d_%H%M%S)
    set -l result_file "$output_dir/$container"_"$event"_"$ts".html

    docker exec $container "$prof_base/bin/asprof" -e $event -d $duration -f /tmp/async-profiler-output.html $pid

    docker cp "$container:/tmp/async-profiler-output.html" "$result_file"
    docker exec $container rm -rf /tmp/async-profiler-output.html

    echo "Flame graph saved to: $result_file"
    xdg-open "$result_file" 2>/dev/null &
end
