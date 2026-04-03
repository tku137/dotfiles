-- WARNING: -----------------------------------------------------------
-- This config uses features only available in WezTerm Nightly builds.
-- --------------------------------------------------------------------

local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- --------------------------------------------------------------------
-- DYNAMIC THEMING
-- --------------------------------------------------------------------
local theme_name = "Tokyo Night Moon"
config.color_scheme = theme_name

local scheme = wezterm.color.get_builtin_schemes()[theme_name]

config.colors = {
	-- Clean up the tab bar by pulling colors directly from the theme
	tab_bar = {
		background = scheme.background,
		active_tab = { bg_color = scheme.ansi[5], fg_color = scheme.background },
		inactive_tab = { bg_color = scheme.background, fg_color = scheme.foreground },
		inactive_tab_hover = { bg_color = scheme.ansi[1], fg_color = scheme.foreground },
		new_tab = { bg_color = scheme.background, fg_color = scheme.foreground },
		new_tab_hover = { bg_color = scheme.ansi[2], fg_color = scheme.foreground },
	},
}

-- --------------------------------------------------------------------
-- MODERN WINDOW VISUALS
-- --------------------------------------------------------------------
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.use_fancy_tab_bar = false -- "retro" bar is actually easier to theme
config.tab_bar_at_bottom = false

-- Windows-specific "Mica" effect
if wezterm.target_triple:find("windows") then
	config.win32_system_backdrop = "Mica"
	config.window_background_opacity = 0.85 -- slight transparency
else
	config.macos_window_background_blur = 30
	config.window_background_opacity = 0.9
end

-- Integrated buttons style
if wezterm.target_triple:find("apple") then
	config.integrated_title_button_style = "MacOsNative"
elseif (os.getenv("XDG_CURRENT_DESKTOP") or ""):find("GNOME") then
	config.integrated_title_button_style = "Gnome"
else
	config.integrated_title_button_style = "Windows"
end

-- --------------------------------------------------------------------
-- FONT & RENDERING
-- --------------------------------------------------------------------
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = wezterm.target_triple:find("apple") and 16.0 or 12.0
config.line_height = 1.1
config.front_end = "WebGpu" -- modern renderer
config.enable_kitty_graphics = true

-- --------------------------------------------------------------------
-- THE REST
-- --------------------------------------------------------------------

-- Mouse and keys
config.keys = {
	{ mods = "CTRL|SHIFT", key = "p", action = wezterm.action.ActivateCommandPalette },
	{ mods = "CTRL|SHIFT", key = "c", action = wezterm.action.CopyTo("Clipboard") },
	{ mods = "CTRL|SHIFT", key = "v", action = wezterm.action.PasteFrom("Clipboard") },
}
config.bypass_mouse_reporting_modifiers = "CTRL"
config.mouse_bindings = {
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "NONE",
		action = wezterm.action.CompleteSelection("Clipboard"),
	},
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CTRL",
		action = wezterm.action.OpenLinkAtMouseCursor,
	},
}

-- General
config.scrollback_lines = 5000

-- Disable bell & default shell
config.audible_bell = "Disabled"
if wezterm.target_triple:find("windows") then
	config.default_prog = { "powershell.exe", "-NoLogo" }
end

return config
