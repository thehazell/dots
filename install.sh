#!/usr/bin/env bash

set -o pipefail

DRY_RUN=false
FORCE=false
ASSUME_YES=false
COMMAND=""

SCRIPT_SOURCE="${BASH_SOURCE[0]}"
while [[ -h "$SCRIPT_SOURCE" ]]; do
    SCRIPT_DIR="$(cd -P "$(dirname "$SCRIPT_SOURCE")" && pwd)"
    SCRIPT_SOURCE="$(readlink "$SCRIPT_SOURCE")"
    [[ "$SCRIPT_SOURCE" != /* ]] && SCRIPT_SOURCE="$SCRIPT_DIR/$SCRIPT_SOURCE"
done
REPO_ROOT="$(cd -P "$(dirname "$SCRIPT_SOURCE")" && pwd)"

usage() {
    cat <<EOF
Usage: $(basename "$0") [--dry-run] [--force] [--yes] <command>

Commands:
  check             Verify installer sources and required commands.
  submodules        Initialize git submodules, including hyprquickshot.
  link              Create user-level configuration and script symlinks.
  fluent-icons      Clone and install the Fluent icon theme.
  caelestia-scheme  Link the Caelestia scheme with sudo (opt-in).
  sddm              Link the SDDM configuration and theme with sudo (opt-in).
  all               Run submodules and user-level links only.
  help              Show this help text.

Options:
  --dry-run  Print actions without changing files or running git/sudo.
  --force    Replace existing files or symlinks; never replace directories.
  --yes      Skip confirmation before privileged phases.
EOF
}

info() {
    printf '==> %s\n' "$*"
}

warn() {
    printf 'warning: %s\n' "$*" >&2
}

error() {
    printf 'error: %s\n' "$*" >&2
}

run() {
    if "$DRY_RUN"; then
        printf 'dry-run:'
        printf ' %q' "$@"
        printf '\n'
    else
        "$@"
    fi
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
        printf '\n' >&2
        error "cannot create directory: path already exists as a file"
        printf '       path: %s\n' "$path" >&2
        printf '       remove or rename the file before running the installer again\n' >&2
        printf '\n' >&2
        return 1
    fi

    run mkdir -p -- "$path"
}

link_path() {
    local source="$1"
    local target="$2"
    local target_dir

    require_file "$source" || return 1

    target_dir="$(dirname "$target")"
    ensure_directory "$target_dir" || return 1

    if [[ -d "$target" && ! -L "$target" ]]; then
        printf '\n' >&2
        error "cannot create symlink: destination is already a directory"
        printf '       source:       %s\n' "$source" >&2
        printf '       destination:  %s\n' "$target" >&2
        printf '       remove or rename the directory before running the installer again\n' >&2
        printf '\n' >&2
        return 1
    fi

    if [[ -e "$target" || -L "$target" ]]; then
        if ! "$FORCE"; then
            printf '\n' >&2
            error "cannot create symlink: destination already exists"
            printf '       source:       %s\n' "$source" >&2
            printf '       destination:  %s\n' "$target" >&2
            printf '       use --force to replace the existing file or symlink\n' >&2
            printf '\n' >&2
            return 1
        fi

        info "replacing existing file or symlink: $target"
        run rm -f -- "$target" || return 1
    fi

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
        printf '\n' >&2
        error "cannot create directory symlink: destination is already a directory"
        printf '       source:       %s\n' "$source" >&2
        printf '       destination:  %s\n' "$target" >&2
        printf '       remove or rename the directory before running the installer again\n' >&2
        printf '\n' >&2
        return 1
    fi

    if [[ -e "$target" || -L "$target" ]]; then
        if ! "$FORCE"; then
            printf '\n' >&2
            error "cannot create directory symlink: destination already exists"
            printf '       source:       %s\n' "$source" >&2
            printf '       destination:  %s\n' "$target" >&2
            printf '       use --force to replace the existing symlink\n' >&2
            printf '\n' >&2
            return 1
        fi

        info "replacing existing symlink: $target"
        run rm -f -- "$target" || return 1
    fi

    run ln -s -- "$source" "$target"
}

link_user_files() {
    local source relative
    local found_lua=false
    local failures=0

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

    if ! link_path \
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
        printf '\n' >&2
        error "user-level linking failed with $failures error(s)"
        printf '\n' >&2
        return 1
    fi

    info "user-level links completed successfully"
}

install_fluent_icons() {
    local tmpdir
    local repo_dir

    command -v git >/dev/null 2>&1 || {
        error "git is required to install the Fluent icon theme"
        return 1
    }

    tmpdir="$(mktemp -d "${TMPDIR:-/tmp}/fluent-icon-theme.XXXXXX")" || {
        error "failed to create temporary directory"
        return 1
    }

    repo_dir="$tmpdir/Fluent-icon-theme"

    info "cloning Fluent icon theme"

    if ! git clone \
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

    info "installing Fluent icon theme"

    if ! (
        cd "$repo_dir" &&
        ./install.sh
    ); then
        error "Fluent icon theme installation failed"
        rm -rf -- "$tmpdir"
        return 1
    fi

    rm -rf -- "$tmpdir"

    info "Fluent icon theme installed successfully"
}

confirm_privileged() {
    local description="$1"
    local reply

    if "$DRY_RUN" || "$ASSUME_YES"; then
        return 0
    fi

    read -r -p "$description Continue? [y/N] " reply
    [[ "$reply" == "y" || "$reply" == "Y" ]]
}

sudo_link_path() {
    local source="$1"
    local target="$2"
    local target_dir

    require_path "$source" || return 1

    target_dir="$(dirname "$target")"

    if "$DRY_RUN"; then
        printf 'dry-run: sudo mkdir -p -- %q\n' "$target_dir"
        printf 'dry-run: sudo ln -s -- %q %q\n' "$source" "$target"
        return 0
    fi

    if [[ -d "$target" ]] || sudo test -d "$target"; then
        printf '\n' >&2
        error "cannot create privileged symlink: destination is already a directory"
        printf '       source:       %s\n' "$source" >&2
        printf '       destination:  %s\n' "$target" >&2
        printf '       remove or rename the directory before running the installer again\n' >&2
        printf '\n' >&2
        return 1
    fi

    if [[ -e "$target" || -L "$target" ]] ||
        sudo test -e "$target" ||
        sudo test -L "$target"; then

        if ! "$FORCE"; then
            printf '\n' >&2
            error "cannot create privileged symlink: destination already exists"
            printf '       source:       %s\n' "$source" >&2
            printf '       destination:  %s\n' "$target" >&2
            printf '       use --force to replace the existing file or symlink\n' >&2
            printf '\n' >&2
            return 1
        fi

        info "replacing existing file or symlink: $target"
        sudo rm -f -- "$target" || return 1
    fi

    sudo mkdir -p -- "$target_dir" || return 1
    sudo ln -s -- "$source" "$target"
}

set_sddm_file_permissions() {
    local source="$1"

    if "$DRY_RUN"; then
        printf 'dry-run: chmod 644 -- %q\n' "$source"
        return 0
    fi

    chmod 644 -- "$source"
}

set_sddm_directory_permissions() {
    local source="$1"

    if "$DRY_RUN"; then
        printf 'dry-run: chmod 755 -- %q\n' "$source"
        return 0
    fi

    chmod 755 -- "$source"
}

prepare_sddm_permissions() {
    local source

    source="$REPO_ROOT/sddm/theme.conf"
    require_file "$source" || return 1

    info "setting SDDM configuration permissions: 644"
    set_sddm_file_permissions "$source" || return 1

    source="$REPO_ROOT/sddm/themes/R1999_1"
    require_path "$source" || return 1

    info "setting SDDM theme permissions: 755/644"

    while IFS= read -r -d '' source; do
        if [[ -d "$source" ]]; then
            set_sddm_directory_permissions "$source" || return 1
        elif [[ -f "$source" ]]; then
            set_sddm_file_permissions "$source" || return 1
        fi
    done < <(
        find "$REPO_ROOT/sddm/themes/R1999_1" -print0
    )

    return 0
}

caelestia_scheme_directory() {
    if [[ -n "${CAELESTIA_SCHEME_DIR:-}" ]]; then
        printf '%s\n' "$CAELESTIA_SCHEME_DIR"
        return 0
    fi

    if ! command -v python3 >/dev/null 2>&1; then
        error "python3 is required to locate the Caelestia scheme directory; set CAELESTIA_SCHEME_DIR instead"
        return 1
    fi

    python3 -c \
        'import sysconfig; print(sysconfig.get_paths()["purelib"] + "/caelestia/data/schemes/hazel/default")'
}

install_caelestia_scheme() {
    local destination

    destination="$(caelestia_scheme_directory)" || return 1

    if ! confirm_privileged \
        "This will use sudo to link the Caelestia scheme into $destination."; then
        info "privileged Caelestia scheme phase cancelled"
        return 0
    fi

    sudo_link_path \
        "$REPO_ROOT/caelestia/schemes/hazel/default/dark.txt" \
        "$destination/dark.txt"
}

install_sddm() {
    if ! confirm_privileged \
        "This will use sudo to link the SDDM configuration and theme."; then
        info "privileged SDDM phase cancelled"
        return 0
    fi

    prepare_sddm_permissions || return 1

    sudo_link_path \
        "$REPO_ROOT/sddm/theme.conf" \
        "/etc/sddm.conf.d/theme.conf" || return 1

    sudo_link_path \
        "$REPO_ROOT/sddm/themes/R1999_1" \
        "/usr/share/sddm/themes/R1999_1"
}

check() {
    local source script
    local status=0

    for source in \
        "$REPO_ROOT/caelestia/shell.json" \
        "$REPO_ROOT/caelestia/schemes/hazel/default/dark.txt" \
        "$REPO_ROOT/sddm/theme.conf" \
        "$REPO_ROOT/sddm/themes/R1999_1" \
        "$REPO_ROOT/tools/hyprquickshot"
    do
        require_path "$source" || status=1
    done

    for script in "$REPO_ROOT"/hypr/scripts/*; do
        [[ -f "$script" && -x "$script" ]] || continue
        info "executable script source: ${script#"$REPO_ROOT/"}"
    done

    command -v git >/dev/null 2>&1 || {
        error "git is required for submodules"
        status=1
    }

    [[ -d "$REPO_ROOT/.git" || -f "$REPO_ROOT/.git" ]] || {
        error "repository metadata not found at $REPO_ROOT"
        status=1
    }

    if (( status == 0 )); then
        info "installer checks passed"
    fi

    return "$status"
}

initialize_submodules() {
    command -v git >/dev/null 2>&1 || {
        error "git is required for submodules"
        return 1
    }

    run git -C "$REPO_ROOT" submodule update --init --recursive
}

while (( $# > 0 )); do
    case "$1" in
        --dry-run)
            DRY_RUN=true
            ;;
        --force)
            FORCE=true
            ;;
        --yes)
            ASSUME_YES=true
            ;;
        check|submodules|link|fluent-icons|caelestia-scheme|sddm|all|help)
            if [[ -n "$COMMAND" ]]; then
                error "only one command may be specified"
                usage
                exit 2
            fi
            COMMAND="$1"
            ;;
        -h|--help)
            COMMAND="help"
            ;;
        *)
            error "unknown option or command: $1"
            usage
            exit 2
            ;;
    esac

    shift
done

COMMAND="${COMMAND:-help}"

case "$COMMAND" in
    check)
        check
        ;;
    submodules)
        initialize_submodules
        ;;
    link)
        link_user_files
        ;;
    fluent-icons)
        install_fluent_icons
        ;;
    caelestia-scheme)
        install_caelestia_scheme
        ;;
    sddm)
        install_sddm
        ;;
    all)
        initialize_submodules || exit 1
        link_user_files
        ;;
    help)
        usage
        ;;
esac