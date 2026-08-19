#!/usr/bin/env bash
#
# Clipboard history manager with search, delete, and wipe functions
#
# Requirements:
# - cliphist
# - wl-clipboard
# - fzf
# - notify-send (libnotify)
#
# License: MIT

usage() {
    local script=${0##*/}

    cat <<- EOF
        USAGE: $script {pick|delete|clear}

        Manage clipboard history using cliphist and fzf

        OPTIONS:
          pick     Search clipboard history and copy selected item
          delete   Search clipboard history and remove selected entry
          clear    Wipe all clipboard history
    EOF
}

pick_entry() {
    local options=(
        "--border=sharp"
        "--border-label= Clipboard History "
        "--ghost=Search"
        "--height=~100%"
        "--highlight-line"
        "--info=inline-right"
        "--pointer="
        "--reverse"
    )

    local selected
    selected=$(cliphist list | fzf "${options[@]}")
    [[ -z $selected ]] && exit 0

    cliphist decode <<< "$selected" | wl-copy
    notify-send "Clipboard" "Copied to clipboard" -i "edit-paste" \
        -h string:x-canonical-private-synchronous:clipboard
}

delete_entry() {
    local options=(
        "--border=sharp"
        "--border-label= Delete Clipboard Entry "
        "--ghost=Search"
        "--height=~100%"
        "--highlight-line"
        "--info=inline-right"
        "--pointer="
        "--reverse"
    )

    local selected
    selected=$(cliphist list | fzf "${options[@]}")
    [[ -z $selected ]] && exit 0

    cliphist delete <<< "$selected"
    notify-send "Clipboard" "Entry removed" -i "edit-delete" \
        -h string:x-canonical-private-synchronous:clipboard
}

clear_all() {
    cliphist wipe
    notify-send "Clipboard" "History cleared" -i "package-purge" \
        -h string:x-canonical-private-synchronous:clipboard
}

main() {
    case $1 in
        pick)   pick_entry ;;
        delete) delete_entry ;;
        clear)  clear_all ;;
        *)
            usage >&2
            return 1
            ;;
    esac
}

main "$@"