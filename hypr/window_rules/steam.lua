local config = require("config")

-- all apps opened by steam open in the special games workspace
local steamGamesRule = hl.window_rule({
    name = "steam-games-workspace",
    match = {
        class = "^steam_app_.*",
    },

    workspace = "special:" .. config.game_special_worksapce,
})
