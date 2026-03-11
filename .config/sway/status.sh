#!/bin/bash

# Network/Wi-Fi
get_network() {
    # Prefer Wi-Fi if connected
    wifi_name=$(nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2)
    if [ -n "$wifi_name" ]; then
        # Truncate SSID to 10 chars to keep things stable
        printf " %-10.10s" "$wifi_name"
    else
        # Fallback to ethernet if active
        eth_status=$(nmcli -t -f type,state dev | grep '^ethernet:connected')
        if [ -n "$eth_status" ]; then
            echo "󰈀 Wired     "
        else
            echo "󰖪 Disconn.  "
        fi
    fi
}

# CPU & RAM Usage
get_cpu_ram() {
    # CPU: Extract usage from 'top'
    # Use -n1 and sum us+sy. AWK handles potential empty/null values.
    cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
    # RAM: Extract usage from 'free'
    # %3.0f ensures 3 digits for percentage
    ram_usage=$(free -m | awk '/Mem:/ { printf("%3.0f%", $3/$2 * 100.0) }')
    # Fixed precision CPU: 5 characters (e.g., "  1.2") + %
    printf " %5.1f% |  %s" "$cpu_usage" "$ram_usage"
}

# CPU Temp
get_cpu_temp() {
    temp=$(cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null)
    if [ -n "$temp" ]; then
        # Fixed 3 digits for temperature
        printf " %3d°C" $((temp / 1000))
    else
        echo " ---°C"
    fi
}

# Battery
get_battery() {
    bat_path=""
    [ -d "/sys/class/power_supply/macsmc-battery" ] && bat_path="/sys/class/power_supply/macsmc-battery"
    [ -z "$bat_path" ] && [ -d "/sys/class/power_supply/BAT0" ] && bat_path="/sys/class/power_supply/BAT0"

    if [ -n "$bat_path" ]; then
        capacity=$(cat "$bat_path/capacity")
        status=$(cat "$bat_path/status")
        icon=""
        [ "$status" == "Charging" ] && icon="󱐋"
        printf "%s %3d%" "$icon" "$capacity"
    else
        echo "󱉝 N/A"
    fi
}

# Volume (PipeWire)
get_volume() {
    vol_info=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
    is_muted=$(echo "$vol_info" | grep -q "MUTED" && echo "yes" || echo "no")
    volume=$(echo "$vol_info" | awk '{print int($2 * 100)}')
    if [ "$is_muted" == "yes" ]; then
        echo "󰝟 MUTED"
    else
        printf "󰕾 %3d%" "$volume"
    fi
}

# Brightness
get_brightness() {
    backlight_dir=$(ls -d /sys/class/backlight/* 2>/dev/null | head -n 1)
    if [ -n "$backlight_dir" ]; then
        max=$(cat "$backlight_dir/max_brightness")
        curr=$(cat "$backlight_dir/brightness")
        printf "󰃠 %3d%" $((curr * 100 / max))
    else
        echo "󰃠 ---%"
    fi
}

# Clock and Date
get_datetime() {
    date +"%a %b %d | %H:%M"
}

# Final loop for continuous update
while true; do
    # Using printf for the whole line to ensure no extra whitespace/newlines creep in
    printf "%s | %s | %s | %s | %s | %s | %s\n" \
        "$(get_network)" \
        "$(get_cpu_ram)" \
        "$(get_cpu_temp)" \
        "$(get_brightness)" \
        "$(get_volume)" \
        "$(get_battery)" \
        "$(get_datetime)"
    sleep 3
done
