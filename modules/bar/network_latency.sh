#!/bin/bash

host="$1"
port="$2"
timeout=5

start=$(date +%s%3N)
nc -z -w $timeout $host $port
nc_exit=$?
end=$(date +%s%3N)

latency_ms=$((end - start))

if [ $nc_exit -eq 0 ]; then
    echo "{\"latency\": $latency_ms, \"success\": true}"
else
    echo "{\"latency\": $latency_ms, \"success\": false, \"error\": \"timeout or connection failed\"}"
fi
