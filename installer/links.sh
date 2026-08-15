#!/usr/bin/env bash

link_path() {
    local source="$1"
    local target="$2"
    local target_dir

    require_file "$source" || return 1

    target_dir="$(dirname "$target")"
    ensure_directory "$target_dir" || return 1

    if [[ -d "$target" && ! -L "$target" ]]; then
        error "cannot create symlink: destination is already a directory"
        action "source: $source"
        action "destination: $target"
        action "remove or rename the directory before running the installer again"
        return 1
    fi

    if [[ -e "$target" || -L "$target" ]]; then
        if ! "$FORCE"; then
            error "destination already exists: $target"
            action "use --force to replace the existing file or symlink"
            return 1
        fi

        action "replacing existing file or symlink: $target"

        run rm -f -- "$target" || return 1
    fi

    action "linking: $target -> $source"

    run ln -s -- "$source" "$target"
}

link_directory() {
    local source="$1"
    local target="$2"
    local target_dir

    if [[ ! -d "$source" ]]; then
        error "required source directory is missing: $source"
        return 1
    fi

    target_dir="$(dirname "$target")"
    ensure_directory "$target_dir" || return 1

    if [[ -d "$target" && ! -L "$target" ]]; then
        error "cannot create directory symlink: destination is already a directory"
        action "source: $source"
        action "destination: $target"
        action "remove or rename the directory before running the installer again"
        return 1
    fi

    if [[ -e "$target" || -L "$target" ]]; then
        if ! "$FORCE"; then
            error "destination already exists: $target"
            action "use --force to replace the existing symlink"
            return 1
        fi

        action "replacing existing symlink: $target"

        run rm -f -- "$target" || return 1
    fi

    action "linking directory: $target -> $source"

    run ln -s -- "$source" "$target"
}

link_files() {
    local failures=0
    local source
    local target

    while (( $# >= 2 )); do
        source="$1"
        target="$2"

        shift 2

        if ! link_path "$source" "$target"; then
            ((failures++))
        fi
    done

    if (( $# != 0 )); then
        error "internal error: link_files requires source/target pairs"
        return 1
    fi

    if (( failures > 0 )); then
        error "linking failed with $failures error(s)"
        return 1
    fi
}

link_user_files() {
    local source
    local relative
    local failures=0
    local found_lua=false

    info "Linking user configuration"

    while IFS= read -r -d '' source; do
        found_lua=true
        relative="${source#"$REPO_ROOT/hypr/"}"

        if ! link_path \
            "$source" \
            "$HOME/.config/hypr/$relative"; then
            ((failures++))
        fi
    done < <(
        find "$REPO_ROOT/hypr" \
            -type f \
            -name '*.lua' \
            -print0 |
            sort -z
    )

    if ! "$found_lua"; then
        error "no Hyprland Lua files found under $REPO_ROOT/hypr"
        ((failures++))
    fi

    if ! link_files \
        "$REPO_ROOT/caelestia/shell.json" \
        "$HOME/.config/caelestia/shell.json"; then
        ((failures++))
    fi

    if ! link_directory \
        "$REPO_ROOT/tools/hyprquickshot" \
        "$HOME/.config/quickshell/hyprquickshot"; then
        ((failures++))
    fi

    shopt -s nullglob

    for source in "$REPO_ROOT"/hypr/scripts/*; do
        if [[ -f "$source" && -x "$source" ]]; then
            if ! link_path \
                "$source" \
                "$HOME/.local/bin/$(basename "$source")"; then
                ((failures++))
            fi
        fi
    done

    shopt -u nullglob

    if (( failures > 0 )); then
        error "user-level linking failed with $failures error(s)"
        return 1
    fi

    success "User configuration linked"
}

link_zsh_files() {
    info "Linking Zsh configuration"

    if ! link_files \
        "$REPO_ROOT/zsh/zshrc" \
        "$HOME/.zshrc" \
        "$REPO_ROOT/zsh/zprofile" \
        "$HOME/.zprofile" \
        "$REPO_ROOT/zsh/starship.toml" \
        "$HOME/.config/starship.toml"; then
        return 1
    fi

    success "Zsh configuration linked"
}