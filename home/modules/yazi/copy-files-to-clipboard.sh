#!/usr/bin/env sh
set -eu

if [ "$#" -gt 1 ]; then
	shift
fi

if [ "$#" -eq 0 ]; then
	exit 0
fi

if [ "$#" -eq 1 ] && [ -f "$1" ]; then
	mime="$(xdg-mime query filetype "$1")"
	case "$mime" in
		image/*)
			wl-copy --type "$mime" < "$1"
			exit 0
			;;
	esac
fi

for path do
	realpath "$path"
done \
	| jq -Rr 'split("/") | map(@uri) | join("/") | "file://" + .' \
	| wl-copy --type text/uri-list
