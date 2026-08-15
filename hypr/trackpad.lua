-- ... I've been sleeping on gestures...
local config = require("config")

hl.gesture({
     fingers = 3,
     direction = "horizontal",
     action = "workspace"
})

hl.gesture({
    fingers = 3,
    direction = "up",
    action = function()
        hl.exec_cmd(config.menu)
    end
})

hl.gesture({
    fingers = 3,
    direction = "down",
    action = function()
        hl.exec_cmd(config.screenshot)
    end
})
