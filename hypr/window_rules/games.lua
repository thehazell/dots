local config = require("config")

-- all apps opened by steam open in the special games workspace
local steamGamesRule = hl.window_rule({
    name = "games-workspace",
    match = {
        class = "^(steam_app_.*|Project Zomboid|XIVLauncher.Core|ffxiv_dx11.exe)$",
    },

    workspace = "special:" .. config.game_special_worksapce,
})
