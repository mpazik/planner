#!/usr/bin/env bash
# A script that manages plan files

SCRIPT_PATH=$(dirname "$0")
PLANNER_DEFAULT_ACTION="week"

show_help() {
    echo "To be done"
}

die() {
    echo "$*"
    exit 1
}

import_config() {
    source ${SCRIPT_PATH}/planner.cfg
    [ -z "$PLANNER_PATH" ] && die "PLANNER_PATH has to be defined"
    [ -z "$PLANNER_EDITOR" ] && die "PLANNER_EDITOR has to be defined"

}

file_path() {
    local name=$1
    local file_extension=$([ -z "$PLANNER_FILE_EXTENSION" ] && echo "" || echo ".${PLANNER_FILE_EXTENSION}")
    echo "${PLANNER_PATH}/${name}${file_extension}"
}

open_file() {
    local path=$(file_path $1)
    ${PLANNER_EDITOR} ${path}
}

week_date() {
    date "+%Y-%m-W%W"
}

month_date() {
    date "+%Y-%m-W%W"
}

year_date() {
    date "+%Y-%m-W%W"
}

main() {
    import_config

    local action=${1:-$PLANNER_DEFAULT_ACTION}

    case ${action} in
        "week")
            open_file $(week_date)
        ;;
        "month")
            open_file $(month_date)
        ;;
        "year")
            open_file $(year_date)
        ;;
        * )
        show_help
        ;;
    esac
}
main $*