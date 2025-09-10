#!/usr/bin/env bash

usage=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits)

jq -n --unbuffered --compact-output --arg text "<i>GPU</i> $usage%" '{text: $text}'
