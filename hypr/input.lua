local config = require("config")

-- keyboard config
hl.config({
    input = {
        kb_layout  = config.keyboard_layout,
        kb_variant = "",
        kb_model   = "",
        kb_options = "ctrl:nocaps",
        kb_rules   = "",

        follow_mouse = 1,

        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

        touchpad = {
            natural_scroll = false,
        },
    },
})

-- its mouse config
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ for more
hl.device({
    name        = "pixart-gaming-mouse",
    sensitivity = -0.5,
})
