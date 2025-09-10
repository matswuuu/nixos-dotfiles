#!/usr/bin/env bash

max_temp=100

current_temp=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits)
# current_temp=$((current_temp))

percent=$(awk "BEGIN {print $current_temp/$max_temp}")

red=$(awk "BEGIN {printf \"%02x\", 128 + (127 * $percent)}")
green=$(awk "BEGIN {printf \"%02x\", 128 + (127 * (1 - $percent))}")
blue=0

# Hex color
color="#$red$green$(printf "%02x" $blue)"

jq -n --unbuffered --compact-output --arg text "<span color='$color'>$current_temp°C</span>" '{text: $text}'
