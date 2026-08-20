local hl = hl or {}

-- ################
-- ## MONITORS ###
-- ################
require("monitors")

-- ###################
-- ### MY PROGRAMS ###
-- ###################
TERMINAL = "ghostty"
FILE_MANAGER = TERMINAL .. " -e yazi"
MENU = "sh ~/.config/rofi/launchers/type-2/launcher.sh"

-- #################
-- ### AUTOSTART ###
-- #################
hl.on("hyprland.start", function()
	hl.exec_cmd("waybar & hyprpaper & hypridle")
	hl.exec_cmd("hyprsunset")
	hl.exec_cmd("$HOME/.dotfiles/.config/scripts/startup-scripts/startup.sh")
end)

-- #############################
-- ### ENVIRONMENT VARIABLES ###
-- #############################
--
-- XDG Specifications
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- unscale XWayland
hl.config({
	xwayland = {
		force_zero_scaling = true,
	},
})

hl.env("GDK_SCALE", "2")
hl.env("GTK_THEME", "Nord")

-- #####################
-- ### LOOK AND FEEL ###
-- #####################
require("hyprland-confs.appearance")

-- #############
-- ### INPUT ###
-- #############
-- ###################
-- ### KEYBINDINGS ###
-- ###################
require("hyprland-confs.input-keybindings")

-- ##############################
-- ### WINDOWS AND WORKSPACES ###
-- ##############################
require("workspaces")
require("hyprland-confs.input-keybindings")
