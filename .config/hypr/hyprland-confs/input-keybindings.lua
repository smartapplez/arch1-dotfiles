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
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(TERMINAL))
hl.bind(mainMod .. " + C", hl.dsp.window.kill({ window = "activewindow" }))
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exit())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(FILE_MANAGER))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.float({ action = "toggle", window = "activewindow" }))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(MENU))
-- hl.bind(mainMod, "P", "pseudo")
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd(screenshotTool))
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd("sh ~/.config/waybar/scripts/power-menu.sh"))
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("qjackctl"))
hl.bind(mainMod .. " + PERIOD", hl.dsp.exec_cmd(emojiPicker))

-- Focus Navigation (Arrow keys)
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "d" }))

-- Focus Navigation (Vim keys)
hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "d" }))

-- Move Window (Arrow keys)
hl.bind(
	mainMod .. " + SHIFT + left",
	hl.dsp.window.move({ direction = "l", group_aware = false, window = "activewindow" })
)
hl.bind(
	mainMod .. " + SHIFT + right",
	hl.dsp.window.move({ direction = "r", group_aware = false, window = "activewindow" })
)
hl.bind(
	mainMod .. " + SHIFT + up",
	hl.dsp.window.move({ direction = "u", group_aware = false, window = "activewindow" })
)
hl.bind(
	mainMod .. " + SHIFT + down",
	hl.dsp.window.move({ direction = "d", group_aware = false, window = "activewindow" })
)

-- Move Window (Vim keys)
hl.bind(
	mainMod .. " + SHIFT + H",
	hl.dsp.window.move({ direction = "l", group_aware = false, window = "activewindow" })
)
hl.bind(
	mainMod .. " + SHIFT + L",
	hl.dsp.window.move({ direction = "r", group_aware = false, window = "activewindow" })
)
hl.bind(
	mainMod .. " + SHIFT + K",
	hl.dsp.window.move({ direction = "u", group_aware = false, window = "activewindow" })
)
hl.bind(
	mainMod .. " + SHIFT + J",
	hl.dsp.window.move({ direction = "d", group_aware = false, window = "activewindow" })
)

-- Resize Window (Arrow keys)
hl.bind(
	mainMod .. " + CTRL + left",
	hl.dsp.window.resize({ x = -20, y = 0, relative = true, window = "activewindow" }),
	{ repeating = true }
)
hl.bind(
	mainMod .. " + CTRL + right",
	hl.dsp.window.resize({ x = 20, y = 0, relative = true, window = "activewindow" }),
	{ repeating = true }
)
hl.bind(
	mainMod .. " + CTRL + up",
	hl.dsp.window.resize({ x = 0, y = -20, relative = true, window = "activewindow" }),
	{ repeating = true }
)
hl.bind(
	mainMod .. " + CTRL + down",
	hl.dsp.window.resize({ x = 0, y = 20, relative = true, window = "activewindow" }),
	{ repeating = true }
)

-- Resize Window (Vim keys)
hl.bind(mainMod .. " + CTRL + H", hl.dsp.window.resize({ x = -20, y = 0, relative = true, window = "activewindow" }))
hl.bind(mainMod .. " + CTRL + L", hl.dsp.window.resize({ x = 20, y = 0, relative = true, window = "activewindow" }))
hl.bind(mainMod .. " + CTRL + K", hl.dsp.window.resize({ x = 0, y = -20, relative = true, window = "activewindow" }))
hl.bind(mainMod .. " + CTRL + J", hl.dsp.window.resize({ x = 0, y = 20, relative = true, window = "activewindow" }))

-- Submap: Resize Mode
hl.define_submap("resize", function()
	-- Set repeating binds for resizing the active window.
	hl.dispatch(hl.dsp.exec_cmd('hyprctl notify 0 2000 "rgb(ffea00)" "fontsize:20 Resize Mode"'))
	hl.bind("right", hl.dsp.window.resize({ x = 10, y = 0, relative = true }), { repeating = true })
	hl.bind("left", hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true })
	hl.bind("up", hl.dsp.window.resize({ x = 0, y = 10, relative = true }), { repeating = true })
	hl.bind("down", hl.dsp.window.resize({ x = 0, y = -10, relative = true }), { repeating = true })

	hl.bind("L", hl.dsp.window.resize({ x = 20, y = 0, relative = true }), { repeating = true })
	hl.bind("H", hl.dsp.window.resize({ x = -20, y = 0, relative = true }), { repeating = true })
	hl.bind("K", hl.dsp.window.resize({ x = 0, y = 20, relative = true }), { repeating = true })
	hl.bind("J", hl.dsp.window.resize({ x = 0, y = -20, relative = true }), { repeating = true })

	hl.bind("SHIFT + L", hl.dsp.window.resize({ x = 100, y = 0, relative = true }), { repeating = true })
	hl.bind("SHIFT + H", hl.dsp.window.resize({ x = -100, y = 0, relative = true }), { repeating = true })
	hl.bind("SHIFT + K", hl.dsp.window.resize({ x = 0, y = 100, relative = true }), { repeating = true })
	hl.bind("SHIFT + J", hl.dsp.window.resize({ x = 0, y = -100, relative = true }), { repeating = true })

	-- Use `reset` to go back to the global submap
	hl.bind("escape", hl.dsp.submap("reset"))
	hl.bind("escape", hl.dsp.exec_cmd('hyprctl notify 0 2000 "rgb(ffea00)" "fontsize:20 Normal Mode"'))
end)

-- Workspaces & Navigation

for i = 1, 9 do
	hl.bind(mainMod .. " + " .. tostring(i), hl.dsp.focus({ workspace = i }))
	hl.bind(
		mainMod .. " + SHIFT + " .. tostring(i),
		hl.dsp.window.move({ workspace = i, follow = true, window = "activewindow" })
	)
end

hl.bind(
	mainMod .. " + F",
	hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle", layout_aware = true, window = "activewindow" })
)
hl.bind(mainMod .. " + W", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.window.move({ workspace = "special:magic" }))

-- Mouse Binds
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
-- hl.bindm(mainMod .. " + mouse:272", "movewindow")
-- hl.bindm(mainMod .. " + mouse:273", "resizewindow")

-- Brightness Controls
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s 10%+"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 10%-"))

-- Media Controls
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"), { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })

-- Requires playerctl
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
