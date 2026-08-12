local floorpRule = hl.window_rule({
    name = "floorp-border",

    match = {
        class = "^floorp$",
    },

    border_color = {
        colors = {
            "rgb(FFFFFF)",
            "rgb(000000)",
        },
        angle = 90,
    },
})