#!/usr/bin/env bash

install_fluent_icons() {
    local tmpdir
    local repo_dir

    info "Installing Fluent icon theme"

    if ! command -v git >/dev/null 2>&1; then
        error "git is required to install the Fluent icon theme"
        return 1
    fi

    action "creating temporary directory"

    tmpdir="$(mktemp -d "${TMPDIR:-/tmp}/fluent-icon-theme.XXXXXX")" || {
        error "failed to create temporary directory"
        return 1
    }

    repo_dir="$tmpdir/Fluent-icon-theme"

    action "cloning Fluent icon theme"

    if ! run git clone \
        --depth 1 \
        --quiet \
        "https://github.com/vinceliuice/Fluent-icon-theme.git" \
        "$repo_dir"; then

        error "failed to clone Fluent icon theme"
        rm -rf -- "$tmpdir"
        return 1
    fi

    if [[ ! -x "$repo_dir/install.sh" ]]; then
        error "Fluent icon theme installer not found or is not executable"
        rm -rf -- "$tmpdir"
        return 1
    fi

    action "running Fluent icon theme installer"

    if ! (
        cd "$repo_dir" || exit 1
        run ./install.sh
    ); then
        error "Fluent icon theme installation failed"
        rm -rf -- "$tmpdir"
        return 1
    fi

    action "removing temporary directory"

    run rm -rf -- "$tmpdir"

    success "Fluent icon theme installed"
}