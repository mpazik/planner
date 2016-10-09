#!/usr/bin/env bash
# A script that manages plan files

SCRIPT_PATH=$(dirname "$0")
PLANNER_SH=$(basename "$0")

one_line_usage="${PLANNER_SH} [-h] action"

usage()
{
    cat <<-EndUsage
		Usage: ${one_line_usage}
		Try '${PLANNER_SH} -h' for more information.
	EndUsage
    exit 1
}

show_help() {
    cat <<EndHelp
Program open plan files in the favorite editor.
To see or change configuration, see file: ${SCRIPT_PATH}/planner.cfg

Usage: ${one_line_usage}

Options:
  -h             display this help message

Actions:
  week           open week planning file
  month          open month planning file
  year           open year planning file
EndHelp
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
    local modifier=$1
    date -v ${modifier}w "+%Y-%m-W%W"
}

month_date() {
    local modifier=$1
    date -v ${modifier}m "+%Y-%m"
}

year_date() {
    local modifier=$1
    date -v ${modifier}y "+%Y"
}

main() {
    import_config

    local action=${1:-${PLANNER_DEFAULT_ACTION:-"week"}}
    local modifier=${2:-"+0"}
    echo ${modifier}

    case ${action} in
        "week")
            open_file $(week_date ${modifier})
        ;;
        "month")
            open_file $(month_date ${modifier})
        ;;
        "year")
            open_file $(year_date ${modifier})
        ;;
        "-h")
            show_help
        ;;
        * )
        usage
        ;;
    esac
}
main $*