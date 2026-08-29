#!/usr/bin/env bash

install_dependencies() {
    local aur_helper=""

    info "Installing dependencies"

    if command -v paru >/dev/null 2>&1; then
        aur_helper="paru"
    elif command -v yay >/dev/null 2>&1; then
        aur_helper="yay"
    else
        error "no AUR helper found; install paru or yay first"
        return 1
    fi

    action "using AUR helper: $aur_helper"

    run "$aur_helper" -S --needed \
        aur/quickshell-git \
        caelestia-shell \
        caelestia-cli \
        sddm \
        hyprland \
        kitty \
        superfile \
        fish \
        playerctl \
        lxqt-policykit \
        grim \
        wl-clipboard \
        libnotify \
        hyprshutdown \
        nemo \
        zsh \
        starship \
        zoxide \
        nvm \
        zsh-autocomplete \
        zsh-autosuggestions \
        zsh-syntax-highlighting \
        qt6-declarative \
        qt6-5compat \
        qt6-svg \
        qt6-multimedia \
        qt6-multimedia-ffmpeg \
        gst-plugins-base \
        gst-plugins-good \
        gst-plugins-bad \
        gst-plugins-ugly \
        fzf \
        acl

    if [[ $? -eq 0 ]]; then
        success "Dependencies installed"
    fi
}