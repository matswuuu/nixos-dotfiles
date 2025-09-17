#!/usr/bin/env bash

info=$(curl -s ip-api.com/json)
ip=$(echo "$info" | jq -r '.query')
country=$(echo "$info" | jq -r '.country')
countryCode=$(echo "$info" | jq -r '.countryCode')
regionName=$(echo "$info" | jq -r '.regionName')
city=$(echo "$info" | jq -r '.city')
timezone=$(echo "$info" | jq -r '.timezone')
isp=$(echo "$info" | jq -r '.isp')
org=$(echo "$info" | jq -r '.org')
as=$(echo "$info" | jq -r '.as')

short="$countryCode"
full="$ip\n$isp $org $as\n$country, $regionName, $city ($timezone)"

jq -n --unbuffered --compact-output --arg text "$short" --arg tooltip "$full" '{text: $text, tooltip: $tooltip}'