#!/usr/bin/env bash
#
# Take screenshots of full screen, selected area, or active window
#
# Requirements:
# - grim
# - slurp
# - wl-clipboard
# - notify-send (libnotify)
# - jq (for active window detection)
#
# License: MIT

SAVE_DIR="${XDG_PICTURES_DIR:-$HOME/Pictures}/Screenshots"
FILENAME="Screenshot_$(date +'%Y-%m-%d_%H-%M-%S').png"
FILEPATH="$SAVE_DIR/$FILENAME"

usage() {
    local script=${0##*/}

    cat <<- EOF
        USAGE: $script {full|area|window}

        Capture screen, copy to clipboard, and save to directory

        OPTIONS:
          full     Capture the entire screen
          area     Select an area with slurp to capture
          window   Capture currently focused window (Hyprland / Sway)

        EXAMPLES:
          Capture selected area:
            $ $script area
    EOF
}

get_active_window_geometry() {
    if [[ -n $HYPRLAND_INSTANCE_SIGNATURE ]]; then
        hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"'
    elif [[ -n $SWAYSOCK ]]; then
        swaymsg -t get_tree | jq -r '.. | select(.focused? == true).rect | "\(.x),\(.y) \(.width)x\(.height)"'
    fi
}

notify_result() {
    local filepath=$1

    if [[ -f $filepath ]]; then
        notify-send "Screenshot Captured" "Saved to $FILENAME and copied to clipboard" \
            -i "$filepath" -h string:x-canonical-private-synchronous:screenshot
    else
        notify-send "Screenshot Aborted" "No area or window selected" \
            -i "camera-photo" -h string:x-canonical-private-synchronous:screenshot
    fi
}

main() {
    mkdir -p "$SAVE_DIR"

    case $1 in
        full)
            grim "$FILEPATH"
            wl-copy < "$FILEPATH"
            notify_result "$FILEPATH"
            ;;
        area)
            local geometry
            geometry=$(slurp)
            [[ -z $geometry ]] && exit 1

            grim -g "$geometry" "$FILEPATH"
            wl-copy < "$FILEPATH"
            notify_result "$FILEPATH"
            ;;
        window)
            local geometry
            geometry=$(get_active_window_geometry)
            if [[ -z $geometry ]]; then
                notify-send "Screenshot Error" "Could not detect active window" -i "dialog-error"
                exit 1
            fi

            grim -g "$geometry" "$FILEPATH"
            wl-copy < "$FILEPATH"
            notify_result "$FILEPATH"
            ;;
        *)
            usage >&2
            return 1
            ;;
    esac
}

main "$@"