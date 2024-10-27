#!/bin/bash

# at command
output=$(echo AT+CCLK? | atinout - /dev/ttyUSB1 -) #change to modem port

# Check CCLK output
datetime_string=$(echo "$output" | awk -F'"' '/\+CCLK/ {print $2}')

# Parsing
date_part=$(echo "$datetime_string" | cut -d',' -f1)
time_part=$(echo "$datetime_string" | cut -d',' -f2 | cut -d'+' -f1)
timezone_part=$(echo "$datetime_string" | cut -d'+' -f2) 
year="20$(echo "$date_part" | cut -d'/' -f1)"
month=$(echo "$date_part" | cut -d'/' -f2)
day=$(echo "$date_part" | cut -d'/' -f3)
get_date="$year-$month-$day"

# Print Data
echo "Date: $get_date"
echo "Time: $time_part"
echo "Timezone Offset: +$timezone_part"

# Extract hours, minutes, and seconds
get_clock_h=$(echo "$time_part" | cut -d':' -f1)
get_clock_m=$(echo "$time_part" | cut -d':' -f2)
get_clock_s=$(echo "$time_part" | cut -d':' -f3)

# Convert timezone offset
timezone_hours=$((10#$timezone_part * 15 / 60))
adjusted_hour=$(( (10#$get_clock_h + timezone_hours) % 24 ))
if (( adjusted_hour < 10#$get_clock_h )); then
    new_date=$(date -d "$get_date + 1 day" +"%Y-%m-%d")
else
    new_date="$get_date"
fi

date_now="${new_date} $(printf '%02d' $adjusted_hour):$get_clock_m:$get_clock_s"

# Set system date and time
date -s "$date_now" > /dev/null 2>&1

# Print date and time
echo -e "Set date and time to [ $(date) ]"
