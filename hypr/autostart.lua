-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

local config = require("config")

hl.on("hyprland.start", function()
    hl.exec_cmd(config.shell)

    -- starts vesktop on hyprland start
    -- take this as an example on how to autostart apps
    hl.exec_cmd(config.vesktop)

    -- NOTE
    -- for this to work correctly, you must have already setup the source properly
    -- the easiest one by far is screen capture (pipewire)
    -- if you experience issues such as incorrect window recorded, or nothing at all, check your source settings
    hl.exec_cmd(config.obs , {workspace = "special:" .. config.obs_special_workspace_name .. " silent"})
 end)
