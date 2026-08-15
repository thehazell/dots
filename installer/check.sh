#!/usr/bin/env bash

check() {
    local source
    local script
    local status=0

    info "Checking repository sources"

    # Required files/directories used directly by the installer.
    for source in \
        "$REPO_ROOT/caelestia/shell.json" \
        "$REPO_ROOT/caelestia/schemes/hazel/default/dark.txt" \
        "$REPO_ROOT/hypr" \
        "$REPO_ROOT/hypr/config.lua" \
        "$REPO_ROOT/hypr/hyprland.lua" \
        "$REPO_ROOT/hypr/animations.lua" \
        "$REPO_ROOT/hypr/appearance.lua" \
        "$REPO_ROOT/hypr/autostart.lua" \
        "$REPO_ROOT/hypr/input.lua" \
        "$REPO_ROOT/hypr/keybinds.lua" \
        "$REPO_ROOT/hypr/monitors.lua" \
        "$REPO_ROOT/hypr/permissions.lua" \
        "$REPO_ROOT/hypr/trackpad.lua" \
        "$REPO_ROOT/hypr/window_rules" \
        "$REPO_ROOT/hypr/scripts" \
        "$REPO_ROOT/sddm/theme.conf" \
        "$REPO_ROOT/sddm/themes/R1999_1" \
        "$REPO_ROOT/tools/hyprquickshot" \
        "$REPO_ROOT/zsh" \
        "$REPO_ROOT/zsh/zshrc" \
        "$REPO_ROOT/zsh/zprofile" \
        "$REPO_ROOT/zsh/starship.toml"
    do
        if require_path "$source"; then
            action "found: ${source#"$REPO_ROOT/"}"
        else
            status=1
        fi
    done

    info "Checking Hyprland scripts"

    local found_scripts=false

    for script in "$REPO_ROOT"/hypr/scripts/*; do
        [[ -f "$script" ]] || continue

        found_scripts=true

        if [[ -x "$script" ]]; then
            action "executable: ${script#"$REPO_ROOT/"}"
        else
            error "Hyprland script is not executable: ${script#"$REPO_ROOT/"}"
            status=1
        fi
    done

    if ! "$found_scripts"; then
        error "no Hyprland scripts found under $REPO_ROOT/hypr/scripts"
        status=1
    fi

    info "Checking Hyprland window rules"

    local found_rules=false

    for source in "$REPO_ROOT"/hypr/window_rules/*; do
        [[ -f "$source" ]] || continue

        found_rules=true
        action "found: ${source#"$REPO_ROOT/"}"
    done

    if ! "$found_rules"; then
        error "no Hyprland window rules found under $REPO_ROOT/hypr/window_rules"
        status=1
    fi

    info "Checking required commands"

    if command -v git >/dev/null 2>&1; then
        action "git found"
    else
        error "git is required for submodules"
        status=1
    fi

    if command -v setfacl >/dev/null 2>&1; then
        action "setfacl found"
    else
        error "setfacl is required for SDDM permissions"
        error "install it with: sudo pacman -S acl"
        status=1
    fi

    info "Checking repository metadata"

    if [[ -d "$REPO_ROOT/.git" || -f "$REPO_ROOT/.git" ]]; then
        action "git repository found"
    else
        error "repository metadata not found at $REPO_ROOT"
        status=1
    fi

    if (( status == 0 )); then
        success "All installer checks passed"
    else
        error "Installer checks failed"
    fi

    return "$status"
}