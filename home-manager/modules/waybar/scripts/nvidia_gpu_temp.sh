#!/usr/bin/env bash

# Check if nvidia-smi command is presented
if ! command -v nvidia-smi >/dev/null 2>&1; then
    exit 0
fi

max_temp=100

current_temp=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits)
percent=$(awk "BEGIN {print $current_temp/$max_temp}")

if [ $percent != 0 ]; then
    red=$(awk "BEGIN {printf \"%02x\", 128 + (127 * $percent)}")
    green=$(awk "BEGIN {printf \"%02x\", 128 + (127 * (1 - $percent))}")
    blue=0

    # Hex color
    color="#$red$green$(printf "%02x" $blue)"

    jq -n --unbuffered --compact-output --arg text "<span color='$color'>$current_temp°C</span>" '{text: $text}'
fi