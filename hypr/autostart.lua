-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

local config = require("config")

hl.on("hyprland.start", function()
    -- starts vesktop on hyprland start
    -- take this as an example on how to autostart apps
    hl.exec_cmd(config.vesktop)

    -- kind of a dirty fix(?) for caelestia
    -- not loading some icons from theme
    hl.exec_cmd("QT_QPA_PLATFORMTHEME=gtk3 " .. config.shell)
 end)
