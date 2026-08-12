local kittyRule = hl.window_rule({
    name = "kitty-border",

    match = {
        class = "^kitty$",
    },

    border_color = {
        colors = {
            "rgb(9D00FF)",
            "rgb(FF00A8)",
        },
        angle = 90,
    },
})