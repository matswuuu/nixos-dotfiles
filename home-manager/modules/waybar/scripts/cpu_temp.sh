#!/usr/bin/env bash

max_temp=100
zone=thermal_zone5

current_temp=$(cat /sys/class/thermal/$zone/temp)
current_temp=$((current_temp / 1000))

percent=$(awk "BEGIN {print $current_temp/$max_temp}")

red=$(awk "BEGIN {printf \"%02x\", 255 * $percent}")
green=$(awk "BEGIN {printf \"%02x\", 255 * (1 - $percent)}")
blue=0

# Hex color
color="#$red$green$(printf "%02x" $blue)"

jq -n --unbuffered --compact-output --arg text "<span color='$color'>$current_temp°C</span>" '{text: $text}'