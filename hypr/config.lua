local config = {
    -- apps used by keybinds, autostart, etc
    terminal = "kitty",
    fileManager = "kitty spf",
    gui_fileManager = "nemo",
    vesktop = "vesktop",
    obs = "obs",
    music = "spotify",
    code = "zeditor",
--------------------------------------------------
    -- list of "games" that will be sent to the game special workspace
    -- entries are matched against the initial class value listed by
    -- `hyprctl clients`
    -- regex patterns are supported (e.g. "steam_app_.*" matches any
    -- class beginning with "steam_app_")
    --
    games = {
        "steam_app_.*",
        "Project Zomboid",
        "XIVLauncher.Core",
        "ffxiv_dx11.exe",
    },
--------------------------------------------------
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
    obs_special_workspace_name = "obs",
    music_special_workspace_name = "music",
    code_special_workspace = "code",
    game_special_worksapce = "game",
--------------------------------------------------
    --  misc config options
    xcursor_size = "24",
    hyprcursor_size = "24",
    keyboard_layout = "us",
    main_user = "hazel",
    laptop_hostname = "hackerlaptop"
}

return config
