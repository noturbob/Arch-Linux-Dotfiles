#!/usr/bin/env bash
#
# Interactive sink/source selector for PipeWire / PulseAudio
#
# Requirements:
# - pactl (libpulse)
# - fzf
# - notify-send (libnotify)
#
# License: MIT

usage() {
    local script=${0##*/}

    cat <<- EOF
        USAGE: $script {sink|source}

        Select default audio output or input device using fzf

        OPTIONS:
          sink     Select audio output device (Speakers / Headphones)
          source   Select audio input device (Microphone)
    EOF
}

get_device_list() {
    local type=$1
    pactl list "$type"s | awk '
        /Name:/ {name=$2}
        /Description:/ {
            sub(/Description: /, "");
            desc=$0;
            printf "%-50s\t%s\n", name, desc
        }
    '
}

select_and_set() {
    local dev_type=$1
    local set_cmd="set-default-$dev_type"
    local list
    list=$(get_device_list "$dev_type")

    local header
    printf -v header "%-50s %s" "Device Name" "Description"

    local options=(
        "--border=sharp"
        "--border-label= Select Audio Device "
        "--ghost=Search"
        "--header=$header"
        "--height=~100%"
        "--highlight-line"
        "--info=inline-right"
        "--pointer="
        "--reverse"
    )

    local selected
    selected=$(fzf "${options[@]}" <<< "$list")
    [[ -z $selected ]] && exit 0

    local target_device
    target_device=$(awk -F '\t' '{print $1}' <<< "$selected" | tr -d ' ')
    local target_desc
    target_desc=$(awk -F '\t' '{print $2}' <<< "$selected")

    pactl "$set_cmd" "$target_device"

    notify-send "Audio Device Switched" "$target_desc" \
        -i "audio-card" -h string:x-canonical-private-synchronous:audio_sink
}

main() {
    case $1 in
        sink | source)
            # Hide cursor during TUI rendering
            printf "\e[?25l"
            select_and_set "$1"
            printf "\e[?25h"
            ;;
        *)
            usage >&2
            return 1
            ;;
    esac
}

main "$@"