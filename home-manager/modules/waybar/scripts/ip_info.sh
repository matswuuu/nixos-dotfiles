#!/usr/bin/env bash

info=$(curl -s ipinfo.io)
ip=$(echo "$info" | jq -r '.ip')
isp=$(echo "$info" | jq -r '.org')
city=$(echo "$info" | jq -r '.city')
region=$(echo "$info" | jq -r '.region')
country=$(echo "$info" | jq -r '.country')

short="$country"
full="IP: $ip | ISP: $isp | $city, $region, $country"

jq -n --unbuffered --compact-output --arg text "$short" --arg tooltip "$full" '{text: $text, tooltip: $tooltip}'