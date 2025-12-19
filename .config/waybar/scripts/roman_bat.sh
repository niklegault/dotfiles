#!/bin/bash

# Get battery capacity (Change BAT0 to BAT1 if needed)
PATH_BAT="/sys/class/power_supply/BAT0/capacity"
if [ ! -f "$PATH_BAT" ]; then
    PATH_BAT="/sys/class/power_supply/BAT1/capacity"
fi

CAPACITY=$(cat "$PATH_BAT")

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

# Output for Waybar (JSON format)
echo "{\"text\": \"[$BAR]\", \"tooltip\": \"Battery: $CAPACITY%\", \"class\": \"battery\"}"
