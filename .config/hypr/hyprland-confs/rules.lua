local hl = hl or {}

-- Inline Window Rules
hl.windowrule("float on", "match:class zenity, match:title Screenshot")
hl.windowrule("float on", 'match:class google-chrome, match:title "Save File"')
hl.windowrule("float on", "match:class xdg-desktop-portal-gtk")
hl.windowrule("float on, center on", "match:title termfilechooser")
hl.windowrule("suppress_event maximize", "match:class .*")
hl.windowrule(
	"no_focus on",
	"match:class ^$, match:title ^$, match:xwayland 1, match:float 1, match:fullscreen 0, match:pin 0"
)

-- Discord Window Rule
hl.windowrule({
	name = "Discord-Windowrule",
	["match:initial_class"] = "discord",
	["match:initial_title"] = "Discord",
	workspace = 1,
})

-- Spotify Window Rule
hl.windowrule({
	name = "Spotify-Windowrule",
	["match:initial_class"] = "spotify",
	size = "785 1032",
	workspace = 1,
})

-- Ghostty Window Rule
hl.windowrule({
	name = "Ghostty-Windowrule",
	["match:initial_class"] = "com.mitchellh.ghostty",
	["match:initial_title"] = "Terminal",
	workspace = 3,
	fullscreen_state = 1,
})

-- Chrome Default Workspace Rule
hl.windowrule({
	name = "Chrome-Default-Windowrule",
	["match:initial_title"] = "Default Placeholder Tab - Google Chrome",
	workspace = "2 silent",
})

-- Chrome Work Workspace Rule
hl.windowrule({
	name = "Chrome-Work-Windowrule",
	["match:initial_title"] = "Work Placeholder Tab - Google Chrome",
	workspace = "special:magic silent",
})
