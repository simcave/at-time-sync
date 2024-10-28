#!/bin/bash

# Run AT command
output=$(echo AT+CCLK? | atinout - /dev/ttyUSB1 -) #change to modem port

# Check if output "+CCLK"
datetime_string=$(echo "$output" | awk -F'"' '/\+CCLK/ {print $2}')

# Parsing Values
date_part=$(echo "$datetime_string" | cut -d',' -f1) 
time_part=$(echo "$datetime_string" | cut -d',' -f2 | cut -d'+' -f1)
timezone_part=$(echo "$datetime_string" | cut -d'+' -f2) 

year="20$(echo "$date_part" | cut -d'/' -f1)"
month=$(echo "$date_part" | cut -d'/' -f2)
day=$(echo "$date_part" | cut -d'/' -f3)
get_date="$year-$month-$day"

# Extract values
get_clock_h=$(echo "$time_part" | cut -d':' -f1)
get_clock_m=$(echo "$time_part" | cut -d':' -f2)
get_clock_s=$(echo "$time_part" | cut -d':' -f3)

# Set this variable to 1 to enable timezone adjustment, or 0 to disable it
apply_timezone_adjustment=1

if (( apply_timezone_adjustment )); then
    # Calculate timezone offset in hours
    timezone_hours=$((10#$timezone_part * 15 / 60))

    # Adjust hour based on timezone offset
    adjusted_hour=$(( (10#$get_clock_h + timezone_hours) % 24 ))

    # Check if date should be incremented
    if (( adjusted_hour < 10#$get_clock_h )); then
        new_date=$(date -d "$get_date + 1 day" +"%Y-%m-%d")
    else
        new_date="$get_date"
    fi

    # Final adjusted date and time with timezone adjustment
    date_now="${new_date} $(printf '%02d' $adjusted_hour):$get_clock_m:$get_clock_s"
else
    # Without timezone adjustment, use original date and time
    date_now="${get_date} $get_clock_h:$get_clock_m:$get_clock_s"
fi

# Set the system date and time
date -s "$date_now" > /dev/null 2>&1

# Output the new date and time setting
echo -e "Set date time to [ $(date) ]"
