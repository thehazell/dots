#!/usr/bin/env bash

check() {
    local source
    local script
    local status=0

    info "Checking installer sources"

    for source in \
        "$REPO_ROOT/caelestia/shell.json" \
        "$REPO_ROOT/caelestia/schemes/hazel/default/dark.txt" \
        "$REPO_ROOT/sddm/theme.conf" \
        "$REPO_ROOT/sddm/themes/R1999_1" \
        "$REPO_ROOT/tools/hyprquickshot" \
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

    for script in "$REPO_ROOT"/hypr/scripts/*; do
        [[ -f "$script" && -x "$script" ]] || continue

        action "executable script: ${script#"$REPO_ROOT/"}"
    done

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

    if [[ -d "$REPO_ROOT/.git" || -f "$REPO_ROOT/.git" ]]; then
        action "repository metadata found"
    else
        error "repository metadata not found at $REPO_ROOT"
        status=1
    fi

    if (( status == 0 )); then
        success "Installer checks passed"
    else
        error "Installer checks failed"
    fi

    return "$status"
}