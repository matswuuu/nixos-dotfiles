#!/usr/bin/env bash

# Check if nvidia-smi command is presented
if ! command -v nvidia-smi >/dev/null 2>&1; then
    exit 0
fi

usage=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits)

if [ $usage != 0 ]; then 
    jq -n --unbuffered --compact-output --arg text "<i>GPU</i> $usage%" '{text: $text}'
fi
