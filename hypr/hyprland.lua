require("keybinds")
require("animations")
require("monitors")
require("autostart")
require("input")
require("appearance")

-- config file
local config = require("config")

-- i dont use a trackpad because im not a nerd
-- require("trackpad")

-- no permissions needed... yet
-- require("permissions")

-- window rules
require("window_rules.hyprland_run")
require("window_rules.xwayland_drags")
require("window_rules.no_maximize")

-- i just do vars here because im lazy
hl.env("XCURSOR_SIZE", config.xcursor_size)
hl.env("HYPRCURSOR_SIZE", config.hyprcursor_size)
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_STYLE_OVERRIDE", "kvantum")
