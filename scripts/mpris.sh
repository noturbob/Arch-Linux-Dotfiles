#!/usr/bin/env bash
#
# Media player controller and Waybar module formatter
#
# Requirements:
# - playerctl
# - notify-send (libnotify)
#
# License: MIT

send_media_notification() {
    local status
    status=$(playerctl status 2> /dev/null)
    [[ -z $status ]] && return

    local title artist album
    title=$(playerctl metadata --format "{{title}}" 2> /dev/null)
    artist=$(playerctl metadata --format "{{artist}}" 2> /dev/null)
    album=$(playerctl metadata --format "{{album}}" 2> /dev/null)

    local icon="media-playback-start"
    [[ $status == "Paused" ]] && icon="media-playback-pause"

    notify-send "$title" "<b>$artist</b>\n<i>$album</i>" -i "$icon" \
        -h string:x-canonical-private-synchronous:mpris
}

display_module() {
    local status
    status=$(playerctl status 2> /dev/null)

    if [[ -z $status || $status == "Stopped" ]]; then
        echo "{ \"text\": \"\", \"alt\": \"stopped\", \"class\": \"stopped\" }"
        exit 0
    fi

    local title artist full_text icon
    title=$(playerctl metadata --format "{{title}}" 2> /dev/null)
    artist=$(playerctl metadata --format "{{artist}}" 2> /dev/null)

    # Truncate strings longer than 30 characters for the bar
    if ((${#title} > 25)); then
        title="${title:0:22}..."
    fi

    if [[ $status == "Playing" ]]; then
        icon="󰐊"
        full_text="$icon $artist - $title"
    else
        icon="󰏤"
        full_text="$icon $artist - $title"
    fi

    local tooltip="<b>Artist:</b> $artist\n<b>Title:</b> $(playerctl metadata --format '{{title}}')\n<b>Album:</b> $(playerctl metadata --format '{{album}}')"

    # Escape double quotes for valid JSON output
    full_text=${full_text//\"/\\\"}
    tooltip=${tooltip//\"/\\\"}

    echo "{ \"text\": \"$full_text\", \"tooltip\": \"$tooltip\", \"class\": \"${status,,}\" }"
}

main() {
    case $1 in
        module)
            display_module
            ;;
        play-pause)
            playerctl play-pause 2> /dev/null
            send_media_notification
            ;;
        next)
            playerctl next 2> /dev/null
            sleep 0.2
            send_media_notification
            ;;
        previous)
            playerctl previous 2> /dev/null
            sleep 0.2
            send_media_notification
            ;;
        *)
            echo "Usage: ${0##*/} {module|play-pause|next|previous}" >&2
            return 1
            ;;
    esac
}

main "$@"