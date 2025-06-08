#!/bin/sh
echo -ne '\033c\033]0;Super Bird Jumper 2\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/superbirdjumper2.bin.x86_64" "$@"
