#!/bin/bash

BAT_PATH=$(ls -d /sys/class/power_supply/BAT* | head -n 1)

# Get capacity and status, default to 0 and Unknown if file read fails
CAPACITY=$(cat "$BAT_PATH/capacity" 2>/dev/null || echo 0)
STATUS=$(cat "$BAT_PATH/status" 2>/dev/null || echo "Unknown")

# Function to convert number to Roman Numerals (Simple 1-100 logic)
to_roman() {
    local num=$1
    local roman=""
    declare -A map=( [10]=X [9]=IX [5]=V [4]=IV [1]=I )
    for val in 10 9 5 4 1; do
        while [ $num -ge $val ]; do
            roman+=${map[$val]}
            num=$((num - val))
        done
    done
    echo "$roman"
}

ROMAN_VAL=$(to_roman $CAPACITY)

# Format the bar to be exactly 10 characters wide for the [XXXXXXXXXX] look
# We will pad with spaces or dots if the roman numeral is short
BAR=$(printf "%-10s" "$ROMAN_VAL")

ICON_STATE="default"
[ "$STATUS" = "Charging" ] && ICON_STATE="charging"


# Output for Waybar (JSON format)
echo "{\"text\": \"[$BAR]\", \"percentage\": $CAPACITY, \"alt\": \"$ICON_STATE\", \"class\": \"$CLASS\", \"tooltip\": \"$STATUS: $CAPACITY%\"}"
