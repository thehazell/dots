local config = {
    -- apps used by keybinds, autostart, etc
    terminal = "kitty",
    fileManager = "kitty spf",
    vesktop = "vesktop",
    obs = "obs",
    ----------- end of apps section -----------

    -- if using the caelestia shell this is available
    -- otherwise, use something like vicinae
    menu = "caelestia shell drawers toggle launcher",

    screenshot = "quickshell -c hyprquickshot -n",

    shell = "qs -c caelestia",

    active_window1 = "rgba(ff8cc8ee)",
    active_window2 = "rgba(ffc2e6ee)",
    inactive_window = "rgba(5a4b55aa)",

    -- name of obs special workspace, in case you'd like to name it something else for easier integration with your modifications
    obs_special_workspace_name = "obs",

    -- size of cursor in xcursor system
    -- most  GTK apps, XWayland, and Wayland apps respect this
    xcursor_size = "24",

    -- size of cursor in hyprcursor system
    -- used by hyprcursor themes
    -- probably should just make it the same as xcursor size
    hyprcursor_size = "24",
}

return config
