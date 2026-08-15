#!/usr/bin/env bash

set_sddm_acl() {
    local path="$1"
    local permissions="$2"

    run sudo setfacl \
        -m "u:sddm:$permissions" \
        -- "$path"
}

set_sddm_tree_acl() {
    local path="$1"

    run sudo setfacl \
        -R \
        -m u:sddm:rX \
        -- "$path"
}

prepare_sddm_permissions() {
    local path

    if ! command -v setfacl >/dev/null 2>&1; then
        error "setfacl is required for SDDM permissions"
        error "install it with: sudo pacman -S acl"
        return 1
    fi

    if ! id sddm >/dev/null 2>&1; then
        error "sddm user does not exist"
        error "install SDDM before running the SDDM installer phase"
        return 1
    fi

    require_file "$REPO_ROOT/sddm/theme.conf" || return 1
    require_path "$REPO_ROOT/sddm/themes/R1999_1" || return 1

    info "Configuring SDDM permissions"

    action "granting SDDM traversal access to repository path"

    for path in \
        "$HOME" \
        "$HOME/Projects" \
        "$HOME/Projects/dots" \
        "$HOME/Projects/dots/sddm" \
        "$HOME/Projects/dots/sddm/themes"
    do
        set_sddm_acl "$path" "--x" || return 1
    done

    action "granting SDDM read access to configuration"

    set_sddm_acl \
        "$REPO_ROOT/sddm/theme.conf" \
        "r--" || return 1

    action "granting SDDM read access to theme"

    set_sddm_tree_acl \
        "$REPO_ROOT/sddm/themes/R1999_1" || return 1

    success "SDDM permissions configured"
}

sudo_link_path() {
    local source="$1"
    local target="$2"
    local target_dir

    require_path "$source" || return 1

    target_dir="$(dirname "$target")"

    if [[ -d "$target" ]] || sudo test -d "$target"; then
        error "cannot create privileged symlink: destination is already a directory"
        action "source: $source"
        action "destination: $target"
        action "remove or rename the directory before running the installer again"
        return 1
    fi

    if [[ -e "$target" || -L "$target" ]] ||
        sudo test -e "$target" ||
        sudo test -L "$target"; then

        if ! "$FORCE"; then
            error "privileged destination already exists: $target"
            action "use --force to replace the existing file or symlink"
            return 1
        fi

        action "replacing privileged file or symlink: $target"

        run sudo rm -f -- "$target" || return 1
    fi

    action "creating privileged link: $target -> $source"

    run sudo mkdir -p -- "$target_dir" || return 1
    run sudo ln -s -- "$source" "$target"
}

install_sddm() {
    info "Installing SDDM configuration"

    if ! confirm_privileged \
        "This will use sudo to link the SDDM configuration/theme and grant the sddm user read/traversal access to the repository SDDM files."; then
        info "privileged SDDM phase cancelled"
        return 0
    fi

    prepare_sddm_permissions || return 1

    sudo_link_path \
        "$REPO_ROOT/sddm/theme.conf" \
        "/etc/sddm.conf.d/theme.conf" || return 1

    sudo_link_path \
        "$REPO_ROOT/sddm/themes/R1999_1" \
        "/usr/share/sddm/themes/R1999_1" || return 1

    success "SDDM configuration installed"
}