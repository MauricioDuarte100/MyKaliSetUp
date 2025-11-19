#!/bin/sh

target_file="$HOME/.config/i3/target"

if [ -f "$target_file" ]; then
    target=$(cat "$target_file")
    if [ -n "$target" ]; then
        echo "$target"
        echo "#E53935"
    else
        echo "No Target"
        echo "#676E7D"
    fi
else
    echo "No Target"
    echo "#676E7D"
fi
