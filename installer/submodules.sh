#!/usr/bin/env bash

initialize_submodules() {
    info "Initializing git submodules"

    if ! command -v git >/dev/null 2>&1; then
        error "git is required for submodules"
        return 1
    fi

    run git -C "$REPO_ROOT" submodule update --init --recursive || return 1

    success "Git submodules initialized"
}