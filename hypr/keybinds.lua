local config = require("config")

local mainMod = "SUPER" -- Sets "Windows" key as main modifier

-- open terminal
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(config.terminal))

-- open file manager
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(config.fileManager))

-- open nemo
-- some apps need a GUI file manager to drag and drop files
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd(config.gui_fileManager))

-- open app launcher
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(config.menu))

-- show OBS special workspace
hl.bind(mainMod .. " + O", hl.dsp.workspace.toggle_special(config.obs_special_workspace_name))

-- show music special workspace
hl.bind(mainMod .. " + M", hl.dsp.workspace.toggle_special(config.music_special_workspace_name))

-- move window to OBS special workspace
hl.bind(mainMod .. " + SHIFT +  O", hl.dsp.window.move({ workspace = "special:" .. config.obs_special_workspace_name }))

hl.bind(mainMod .. " + SHIFT +  M", hl.dsp.window.move({ workspace = "special:" .. config.music_special_workspace_name }))
-- close window
-- closeWindowBind:set_enabled(false)
local closeWindowBind = hl.bind(mainMod .. " + Q", hl.dsp.window.close())

-- toggle floating for the targeted window
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))

-- toggle fullscreen foor the targeted window
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))

-- toggle pseduotiling for the targeted window
-- pseudotiling allows a window to main its preffered floting size whie
-- still being tiled
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())

-- toggles the next split in the tiler between horizontal and vertical
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit")) -- dwindle only

-- toggles screen recording, focuses whatever your OBS settings are
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("record"))

-- screenshot
hl.bind("PRINT", hl.dsp.exec_cmd(config.screenshot))

-- fullscreen screenshot to clipboard
hl.bind(mainMod .. " + PRINT", hl.dsp.exec_cmd("fullscreen_screenshot"))

-- fullscreen screenshot to clipboard and disk
hl.bind(mainMod .. " + SHIFT + PRINT", hl.dsp.exec_cmd("fullscreen_screenshot -s"))

-- clean shutdown, please use this bind to ensure OBS and other programs do not try to enter a safe mode
hl.bind(mainMod .. " + ESCAPE", hl.dsp.exec_cmd("hyprshutdown -p 'systemctl poweroff'"))

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0

    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
-- hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
-- hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
-- hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
-- l.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
-- hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
-- hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

-- Requires playerctl
-- hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
-- hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
-- hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
-- hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })
