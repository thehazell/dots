#!/usr/bin/env bash

set -o pipefail

SCRIPT_SOURCE="${BASH_SOURCE[0]}"

while [[ -h "$SCRIPT_SOURCE" ]]; do
    SCRIPT_DIR="$(cd -P "$(dirname "$SCRIPT_SOURCE")" && pwd)"
    SCRIPT_SOURCE="$(readlink "$SCRIPT_SOURCE")"
    [[ "$SCRIPT_SOURCE" != /* ]] && SCRIPT_SOURCE="$SCRIPT_DIR/$SCRIPT_SOURCE"
done

REPO_ROOT="$(cd -P "$(dirname "$SCRIPT_SOURCE")" && pwd)"
INSTALLER_DIR="$REPO_ROOT/installer"

source "$INSTALLER_DIR/common.sh"
source "$INSTALLER_DIR/check.sh"
source "$INSTALLER_DIR/links.sh"
source "$INSTALLER_DIR/dependencies.sh"
source "$INSTALLER_DIR/submodules.sh"
source "$INSTALLER_DIR/fluent-icons.sh"
source "$INSTALLER_DIR/caelestia.sh"
source "$INSTALLER_DIR/sddm.sh"

DRY_RUN=false
FORCE=false
ASSUME_YES=false
COMMAND=""

usage() {
    cat <<EOF
Usage: $(basename "$0") [--dry-run] [--force] [--yes] <command>

Commands:
  check             Verify installer sources and required commands.
  deps              Install required packages using paru or yay.
  submodules        Initialize git submodules, including hyprquickshot.
  link              Create user-level configuration and script symlinks.
  zsh               Create Zsh and Starship configuration symlinks.
  fluent-icons      Clone and install the Fluent icon theme.
  caelestia-scheme  Link the Caelestia scheme with sudo (opt-in).
  sddm              Link the SDDM configuration and theme with sudo (opt-in).
  all               Run submodules and all user-level links.
  help              Show this help text.

Options:
  --dry-run  Print actions without changing files or running git/sudo.
  --force    Replace existing files or symlinks; never replace directories.
  --yes      Skip confirmation before privileged phases.
EOF
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
        deps|check|submodules|link|zsh|fluent-icons|caelestia-scheme|sddm|all|help)
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
    deps)
        install_dependencies
        ;;
    submodules)
        initialize_submodules
        ;;
    link)
        link_user_files
        ;;
    zsh)
        link_zsh_files
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
        initialize_submodules &&
        link_user_files &&
        link_zsh_files
        ;;
    help)
        usage
        ;;
esac