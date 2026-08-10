local config = require("config")

local gamesRule = hl.window_rule({
    name = "games-workspace",

    match = {
        class = "^(" .. table.concat(config.games, "|") .. ")$",
    },

    workspace = "special:" .. config.game_special_worksapce,
})