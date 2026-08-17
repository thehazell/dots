-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

local config = require("config")

hl.on("hyprland.start", function()
    hl.exec_cmd(config.shell)

    local username = os.getenv("USER")
    local hostname = os.getenv("HOSTNAME")

    -- start vesktop on default workspace
    -- starts vesktop only on the account named hazel
    if username == config.main_user then
        hl.exec_cmd(config.vesktop)
    end

    -- start spotify on special workspace without focusing it
    hl.exec_cmd(config.music, { workspace = "special:" .. config.music_special_workspace_name .. " silent" })

    hl.exec_cmd("lxqt-policykit-agent")

    hl.exec_cmd("nm-applet")
 end)
