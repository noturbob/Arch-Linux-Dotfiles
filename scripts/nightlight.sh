#!/usr/bin/env bash
#
# Toggle nightlight / blue light filter and supply Waybar module JSON
#
# Requirements:
# - wlsunset (or gammastep)
# - notify-send (libnotify)
#
# License: MIT

TEMP_LOW=4000
TEMP_HIGH=6500

is_running() {
    pgrep -x wlsunset > /dev/null
}

display_module() {
    if is_running; then
        echo "{ \"text\": \"󰖔\", \"tooltip\": \"Night Light: Active (${TEMP_LOW}K)\", \"class\": \"active\" }"
    else
        echo "{ \"text\": \"󰖙\", \"tooltip\": \"Night Light: Inactive (${TEMP_HIGH}K)\", \"class\": \"inactive\" }"
    fi
}

toggle() {
    if is_running; then
        pkill -x wlsunset
        notify-send "Night Light Off" "Screen temperature reset to ${TEMP_HIGH}K" \
            -i "display-brightness" -h string:x-canonical-private-synchronous:nightlight
    else
        wlsunset -t $TEMP_LOW -T $TEMP_HIGH &> /dev/null &
        notify-send "Night Light On" "Screen temperature set to ${TEMP_LOW}K" \
            -i "weather-clear-night" -h string:x-canonical-private-synchronous:nightlight
    fi
}

main() {
    case $1 in
        module)
            display_module
            ;;
        toggle)
            toggle
            ;;
        *)
            echo "Usage: ${0##*/} {module|toggle}" >&2
            return 1
            ;;
    esac
}

main "$@"