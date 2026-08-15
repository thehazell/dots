#!/usr/bin/env bash

info() {
    printf '==> %s\n' "$*"
}

action() {
    printf '    -> %s\n' "$*"
}

success() {
    printf '    ✓ %s\n' "$*"
}

command_info() {
    printf '$'

    printf ' %q' "$@"

    printf '\n'
}

warn() {
    printf 'warning: %s\n' "$*" >&2
}

error() {
    printf 'error: %s\n' "$*" >&2
}

run() {
    command_info "$@"

    if "$DRY_RUN"; then
        return 0
    fi

    "$@"
}

require_file() {
    local path="$1"

    if [[ ! -f "$path" ]]; then
        error "required source file is missing: $path"
        return 1
    fi
}

require_path() {
    local path="$1"

    if [[ ! -e "$path" && ! -L "$path" ]]; then
        error "required source path is missing: $path"
        return 1
    fi
}

ensure_directory() {
    local path="$1"

    if [[ -e "$path" && ! -d "$path" ]]; then
        error "cannot create directory: path already exists as a file"
        action "path: $path"
        action "remove or rename the file before running the installer again"
        return 1
    fi

    if [[ ! -d "$path" ]]; then
        action "creating directory: $path"
        run mkdir -p -- "$path"
    fi
}

confirm_privileged() {
    local description="$1"
    local reply

    if "$DRY_RUN" || "$ASSUME_YES"; then
        return 0
    fi

    printf '\n'
    printf '%s\n' "$description"

    read -r -p "Continue? [y/N] " reply

    [[ "$reply" == "y" || "$reply" == "Y" ]]
}