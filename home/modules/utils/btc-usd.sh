#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 3 ]]; then
  echo "Usage: $0 <current_btc_price> <future_btc_price> <usd_amount>"
  echo "Example: $0 63000 68000 1000"
  exit 1
fi

current_price="$1"
future_price="$2"
usd_amount="$3"

# Use awk for floating-point math
btc_bought=$(awk -v a="$usd_amount" -v p="$current_price" 'BEGIN { printf "%.8f", a / p }')
final_value=$(awk -v b="$btc_bought" -v p="$future_price" 'BEGIN { printf "%.2f", b * p }')
profit=$(awk -v f="$final_value" -v a="$usd_amount" 'BEGIN { printf "%.2f", f - a }')
percent_gain=$(awk -v c="$current_price" -v n="$future_price" 'BEGIN { printf "%.2f", ((n - c) / c) * 100 }')

echo "BTC bought:   $btc_bought BTC"
echo "Final value:  \$$final_value"
echo "Profit:       \$$profit"
echo "Gain:         $percent_gain%"
