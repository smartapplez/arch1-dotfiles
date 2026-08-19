-- INPUT
local hl = hl or {}

hl.config({
	input = {
		kb_layout = "us",
		kb_variant = "",
		kb_model = "",
		kb_options = "",
		kb_rules = "",

		follow_mouse = 1,
		numlock_by_default = true,

		sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

		touchpad = {
			natural_scroll = true,
			scroll_factor = 0.75,
		},
	},
})

-- GESTURES
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 3, direction = "down", mods = "ALT", action = "close" })
hl.gesture({ fingers = 3, direction = "up", mods = "SUPER", scale = 1.5, action = "fullscreen" })

-------------------
--  KEYBINDINGS  --
-------------------
local mainMod = "SUPER"
local screenshotTool = "sh ~/.config/hypr/screenshot-dmenu.sh"
local emojiPicker = "sh ~/.config/rofi/scripts/rofi-emoji-picker-launcher.sh"

-- Application & Window Binds
hl.bind(mainMod, "RETURN", "exec", TERMINAL)
hl.bind(mainMod, "C", "killactive")
hl.bind(mainMod .. " SHIFT", "Q", "exit")
hl.bind(mainMod, "E", "exec", FILE_MANAGER)
hl.bind(mainMod .. " SHIFT", "F", "togglefloating")
hl.bind(mainMod, "R", "exec", MENU)
hl.bind(mainMod, "P", "pseudo")
hl.bind(mainMod .. " SHIFT", "S", "exec", screenshotTool)
hl.bind(mainMod .. " SHIFT", "P", "exec", "sh ~/.config/waybar/scripts/power-menu.sh")
hl.bind(mainMod, "A", "exec", "qjackctl")
hl.bind(mainMod, "PERIOD", "exec", emojiPicker)

-- Focus Navigation (Arrow keys)
hl.bind(mainMod, "left", "movefocus", "l")
hl.bind(mainMod, "right", "movefocus", "r")
hl.bind(mainMod, "up", "movefocus", "u")
hl.bind(mainMod, "down", "movefocus", "d")

-- Focus Navigation (Vim keys)
hl.bind(mainMod, "h", "movefocus", "l")
hl.bind(mainMod, "l", "movefocus", "r")
hl.bind(mainMod, "k", "movefocus", "u")
hl.bind(mainMod, "j", "movefocus", "d")

-- Move Window (Arrow keys)
hl.bind(mainMod .. " SHIFT", "left", "movewindow", "l")
hl.bind(mainMod .. " SHIFT", "right", "movewindow", "r")
hl.bind(mainMod .. " SHIFT", "up", "movewindow", "u")
hl.bind(mainMod .. " SHIFT", "down", "movewindow", "d")

-- Move Window (Vim keys)
hl.bind(mainMod .. " SHIFT", "H", "movewindow", "l")
hl.bind(mainMod .. " SHIFT", "L", "movewindow", "r")
hl.bind(mainMod .. " SHIFT", "K", "movewindow", "u")
hl.bind(mainMod .. " SHIFT", "J", "movewindow", "d")

-- Resize Window (Arrow keys)
hl.bind(mainMod .. " CTRL", "left", "resizeactive", "-20 0")
hl.bind(mainMod .. " CTRL", "right", "resizeactive", "20 0")
hl.bind(mainMod .. " CTRL", "up", "resizeactive", "0 -20")
hl.bind(mainMod .. " CTRL", "down", "resizeactive", "0 20")

-- Resize Window (Vim keys)
hl.bind(mainMod .. " CTRL", "H", "resizeactive", "-20 0")
hl.bind(mainMod .. " CTRL", "L", "resizeactive", "20 0")
hl.bind(mainMod .. " CTRL", "K", "resizeactive", "0 -20")
hl.bind(mainMod .. " CTRL", "J", "resizeactive", "0 20")

-- Submap: Resize Mode
hl.bind(mainMod .. " SHIFT", "R", "exec", 'hyprctl notify 0 2000 "rgb(ffea00)" "fontsize:20 Resize Mode"')
hl.bind(mainMod .. " SHIFT", "R", "submap", "resize")

hl.submap("resize")
hl.binde("", "right", "resizeactive", "10 0")
hl.binde("", "left", "resizeactive", "-10 0")
hl.binde("", "up", "resizeactive", "0 -10")
hl.binde("", "down", "resizeactive", "0 10")

hl.binde("", "H", "resizeactive", "-20 0")
hl.binde("", "L", "resizeactive", "20 0")
hl.binde("", "K", "resizeactive", "0 -20")
hl.binde("", "J", "resizeactive", "0 20")

hl.binde("SHIFT", "H", "resizeactive", "-100 0")
hl.binde("SHIFT", "L", "resizeactive", "100 0")
hl.binde("SHIFT", "K", "resizeactive", "0 -100")
hl.binde("SHIFT", "J", "resizeactive", "0 100")

hl.binde("", "escape", "exec", 'hyprctl notify 0 2000 "rgb(ffea00)" "fontsize:20 Normal Mode"')
hl.binde("", "escape", "submap", "reset")
hl.submap("reset")

-- Workspaces & Navigation
for i = 1, 9 do
	hl.bind(mainMod, tostring(i), "workspace", tostring(i))
	hl.bind(mainMod .. " SHIFT", tostring(i), "movetoworkspace", tostring(i))
end
hl.bind(mainMod, "0", "workspace", "10")
hl.bind(mainMod .. " SHIFT", "0", "movetoworkspace", "10")

hl.bind(mainMod, "F", "fullscreen")
hl.bind(mainMod, "W", "togglespecialworkspace", "magic")
hl.bind(mainMod .. " SHIFT", "W", "movetoworkspace", "special:magic")

-- Mouse Binds
hl.bind(mainMod, "mouse_down", "workspace", "e+1")
hl.bind(mainMod, "mouse_up", "workspace", "e-1")
hl.bindm(mainMod, "mouse:272", "movewindow")
hl.bindm(mainMod, "mouse:273", "resizewindow")

-- Media & Brightness Controls
hl.bindel("", "XF86AudioRaiseVolume", "exec", "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+")
hl.bindel("", "XF86AudioLowerVolume", "exec", "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")
hl.bindel("", "XF86AudioMute", "exec", "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")
hl.bindel("", "XF86AudioMicMute", "exec", "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle")
hl.bindel("", "XF86MonBrightnessUp", "exec", "brightnessctl s 10%+")
hl.bindel("", "XF86MonBrightnessDown", "exec", "brightnessctl s 10%-")

hl.bindl("", "XF86AudioNext", "exec", "playerctl next")
hl.bindl("", "XF86AudioPause", "exec", "playerctl play-pause")
hl.bindl("", "XF86AudioPlay", "exec", "playerctl play-pause")
hl.bindl("", "XF86AudioPrev", "exec", "playerctl previous")
