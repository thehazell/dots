#!/usr/bin/env bash

sudo_link_path() {
    local source="$1"
    local target="$2"
    local target_dir

    require_path "$source" || return 1

    target_dir="$(dirname "$target")"

    if "$DRY_RUN"; then
        action "would link: $target -> $source"
        run sudo mkdir -p -- "$target_dir"
        run sudo ln -s -- "$source" "$target"
        return 0
    fi

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

caelestia_scheme_directory() {
    local package_dir

    if ! command -v python3 >/dev/null 2>&1; then
        error "python3 is required to locate the Caelestia scheme directory"
        return 1
    fi

    package_dir="$(
        python3 -c '
import importlib.util

spec = importlib.util.find_spec("caelestia")

if spec is None or spec.submodule_search_locations is None:
    raise SystemExit(1)

print(next(iter(spec.submodule_search_locations)))
'
    )" || {
        error "could not locate the installed Caelestia package"
        return 1
    }

    printf '%s/data/schemes/hazel/default\n' "$package_dir"
}

install_caelestia_scheme() {
    local destination

    info "Installing Caelestia scheme"

    destination="$(caelestia_scheme_directory)" || return 1

    if [[ ! -d "$destination" ]]; then
        error "Caelestia scheme directory does not exist: $destination"
        return 1
    fi

    action "scheme directory: $destination"

    if ! confirm_privileged \
        "This will use sudo to link the Caelestia scheme into $destination."; then
        info "privileged Caelestia scheme phase cancelled"
        return 0
    fi

    sudo_link_path \
        "$REPO_ROOT/caelestia/schemes/hazel/default/dark.txt" \
        "$destination/dark.txt" || return 1

    success "Caelestia scheme installed"
}