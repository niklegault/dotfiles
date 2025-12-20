#!/bin/bash

# Get volume percentage using pamixer (standard on Arch)
# If you use wpctl, use: VOLUME=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2*100}' | cut -d. -f1)
VOLUME=$(pamixer --get-volume)
MUTED=$(pamixer --get-mute)

# Function to convert number to Roman Numerals
to_roman() {
    local num=$1
    if [ "$num" -le 0 ]; then echo ""; return; fi
    local roman=""
    declare -A map=( [10]=X [9]=IX [5]=V [4]=IV [1]=I )
    for val in 10 9 5 4 1; do
        while [ "$num" -ge "$val" ]; do
            roman+=${map[$val]}
            num=$((num - val))
        done
    done
    echo "$roman"
}

# Generate the Roman string and pad to 10 chars
ROMAN_VAL=$(to_roman "$VOLUME")
BAR=$(printf "%-10s" "$ROMAN_VAL")

# Determine icon and class
ICON_STATE="unmuted"
CLASS="vol-normal"

if [ "$MUTED" = "true" ] || [ "$VOLUME" -eq 0 ]; then
    ICON_STATE="muted"
    CLASS="vol-muted"
    BAR="----------"
fi

# Output JSON for Waybar
echo "{\"text\": \"[$BAR]\", \"percentage\": $VOLUME, \"alt\": \"$ICON_STATE\", \"class\": \"$CLASS\", \"tooltip\": \"Volume: $VOLUME%\"}"
