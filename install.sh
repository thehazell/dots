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

info() { printf '==> %s\n' "$*"; }
warn() { printf 'warning: %s\n' "$*" >&2; }
error() { printf 'error: %s\n' "$*" >&2; }

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
    if [[ ! -e "$path" ]]; then
        error "required source path is missing: $path"
        return 1
    fi
}

ensure_directory() {
    local path="$1"
    if [[ -e "$path" && ! -d "$path" ]]; then
        error "cannot create directory; target exists and is not a directory: $path"
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

    if [[ -d "$target" ]]; then
        error "refusing to replace directory: $target"
        return 1
    fi

    if [[ -e "$target" || -L "$target" ]]; then
        if ! "$FORCE"; then
            warn "leaving existing target untouched: $target"
            return 0
        fi
        info "replacing existing file or symlink: $target"
        run rm -f -- "$target"
    fi

    run ln -s -- "$source" "$target"
}

link_user_files() {
    local source relative
    local found_lua=false

    while IFS= read -r -d '' source; do
        found_lua=true
        relative="${source#"$REPO_ROOT/hypr/"}"
        link_path "$source" "$HOME/.config/hypr/$relative" || return 1
    done < <(find "$REPO_ROOT/hypr" -type f -name '*.lua' -print0 | sort -z)

    if ! "$found_lua"; then
        error "no Hyprland Lua files found under $REPO_ROOT/hypr"
        return 1
    fi

    link_path "$REPO_ROOT/caelestia/shell.json" "$HOME/.config/caelestia/shell.json" || return 1

    shopt -s nullglob
    for source in "$REPO_ROOT"/hypr/scripts/*; do
        if [[ -f "$source" && -x "$source" ]]; then
            link_path "$source" "$HOME/.local/bin/$(basename "$source")" || return 1
        fi
    done
    shopt -u nullglob
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
        error "refusing to replace directory: $target"
        return 1
    fi

    if [[ -e "$target" || -L "$target" ]] || sudo test -e "$target" || sudo test -L "$target"; then
        if ! "$FORCE"; then
            warn "leaving existing target untouched: $target"
            return 0
        fi
        info "replacing existing file or symlink: $target"
        sudo rm -f -- "$target"
    fi

    sudo mkdir -p -- "$target_dir"
    sudo ln -s -- "$source" "$target"
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

    python3 -c 'import sysconfig; print(sysconfig.get_paths()["purelib"] + "/caelestia/data/schemes/hazel/default")'
}

install_caelestia_scheme() {
    local destination
    destination="$(caelestia_scheme_directory)" || return 1

    if ! confirm_privileged "This will use sudo to link the Caelestia scheme into $destination."; then
        info "privileged Caelestia scheme phase cancelled"
        return 0
    fi

    sudo_link_path "$REPO_ROOT/caelestia/schemes/hazel/default/dark.txt" "$destination/dark.txt"
}

install_sddm() {
    if ! confirm_privileged "This will use sudo to link the SDDM configuration and theme."; then
        info "privileged SDDM phase cancelled"
        return 0
    fi

    sudo_link_path "$REPO_ROOT/sddm/theme.conf" "/etc/sddm.conf.d/theme.conf" || return 1
    sudo_link_path "$REPO_ROOT/sddm/themes/R1999_1" "/usr/share/sddm/themes/R1999_1"
}

check() {
    local source script
    local status=0

    for source in "$REPO_ROOT/caelestia/shell.json" "$REPO_ROOT/caelestia/schemes/hazel/default/dark.txt" "$REPO_ROOT/sddm/theme.conf"; do
        require_file "$source" || status=1
    done
    for script in "$REPO_ROOT"/hypr/scripts/*; do
        [[ -f "$script" && -x "$script" ]] || continue
        info "executable script source: ${script#"$REPO_ROOT/"}"
    done
    command -v git >/dev/null 2>&1 || { error "git is required for submodules"; status=1; }
    [[ -d "$REPO_ROOT/.git" || -f "$REPO_ROOT/.git" ]] || { error "repository metadata not found at $REPO_ROOT"; status=1; }

    if (( status == 0 )); then
        info "installer checks passed"
    fi
    return "$status"
}

initialize_submodules() {
    command -v git >/dev/null 2>&1 || { error "git is required for submodules"; return 1; }
    run git -C "$REPO_ROOT" submodule update --init --recursive
}

while (( $# > 0 )); do
    case "$1" in
        --dry-run) DRY_RUN=true ;;
        --force) FORCE=true ;;
        --yes) ASSUME_YES=true ;;
        check|submodules|link|caelestia-scheme|sddm|all|help)
            if [[ -n "$COMMAND" ]]; then
                error "only one command may be specified"
                usage
                exit 2
            fi
            COMMAND="$1"
            ;;
        -h|--help) COMMAND="help" ;;
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
    check) check ;;
    submodules) initialize_submodules ;;
    link) link_user_files ;;
    caelestia-scheme) install_caelestia_scheme ;;
    sddm) install_sddm ;;
    all)
        initialize_submodules || exit 1
        link_user_files
        ;;
    help) usage ;;
esac
