local config = {
    -- apps used by keybinds, autostart, etc
    terminal = "kitty",
    fileManager = "kitty spf",
    gui_fileManager = "nemo",
    vesktop = "vesktop",
    obs = "obs",
    music = "spotify",
    code = "zeditor",

    -- if using the caelestia shell this is available
    -- otherwise, use something like vicinae
    menu = "caelestia shell drawers toggle launcher",

    screenshot = "quickshell -c hyprquickshot",
--------------------------------------------------
    -- used by autostart to start caelestia
    shell = "qs -c caelestia",
--------------------------------------------------
    active_window1 = "rgba(ff8cc8ee)",
    active_window2 = "rgba(ffc2e6ee)",
    inactive_window = "rgba(5a4b55aa)",
--------------------------------------------------
    -- speical workspace names

    -- obs special workspace
    obs_special_workspace_name = "obs",

    -- music special workspace
    music_special_workspace_name = "music",

    -- code speical workspace
    code_special_workspace = "code",
--------------------------------------------------
    -- size of cursor in xcursor system
    -- most  GTK apps, XWayland, and Wayland apps respect this
    xcursor_size = "24",

    -- size of cursor in hyprcursor system
    -- used by hyprcursor themes
    -- probably should just make it the same as xcursor size
    hyprcursor_size = "24",

    -- keyboard layout
    keyboard_layout = "us",
}

return config
