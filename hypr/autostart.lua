-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

local config = require("config")

hl.on("hyprland.start", function()
    hl.exec_cmd(config.shell)

    -- start vesktop on default workspace
    hl.exec_cmd(config.vesktop)

    -- start spotify on workspace 2 without focusing it
    hl.exec_cmd(config.music, { workspace = "2 silent" })

    -- NOTE
    -- for this to work correctly, you must have already setup the source properly
    -- the easiest one by far is screen capture (pipewire)
    -- if you experience issues such as incorrect window recorded, or nothing at all, check your source settings
    -- this starts obs in a special workspace defined by config.obs_special_workspace_name without focusing it
    hl.exec_cmd(config.obs, { workspace = "special:" .. config.obs_special_workspace_name .. " silent" })

 end)
