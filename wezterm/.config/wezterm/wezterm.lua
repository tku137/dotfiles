-- Pull in the wezterm API
local wezterm = require("wezterm")

-- Create base config object
local config = wezterm.config_builder and wezterm.config_builder() or {}

-- FONT SETTINGS
-- local font_family = "FiraCode Nerd Font"
local font_family = "JetBrainsMono Nerd Font"
local caligraphic_font_family = "Maple Mono NF"
-- local caligraphic_font_family = font_family
config.font = wezterm.font({ family = font_family })
config.bold_brightens_ansi_colors = true
config.font_rules = {
	{
		intensity = "Bold",
		italic = true,
		font = wezterm.font({ family = caligraphic_font_family, weight = "Bold", style = "Italic" }),
	},
	{
		italic = true,
		intensity = "Half",
		font = wezterm.font({ family = caligraphic_font_family, weight = "DemiBold", style = "Italic" }),
	},
	{
		italic = true,
		intensity = "Normal",
		font = wezterm.font({ family = caligraphic_font_family, style = "Italic" }),
	},
}
local platform = wezterm.target_triple
if platform:find("apple") then
	config.font_size = 15.0
else
	config.font_size = 12.0
end
config.line_height = 1.1

-- COLOR SCHEME SETTINGS
-- Define the color schemes
-- local dark_mode = "Catppuccin Macchiato"
-- local light_mode = "Catppuccin Latte"
local dark_mode = "Tokyo Night Moon" -- Moon, Storm, Night, Day

-- Load the Catppuccin Macchiato colors
local color_scheme = wezterm.color.get_builtin_schemes()[dark_mode]

-- Set the color scheme to dark mode
config.color_scheme = dark_mode

config.colors = {
	tab_bar = {
		active_tab = {
			bg_color = color_scheme.tab_bar.active_tab.bg_color,
			fg_color = color_scheme.tab_bar.active_tab.fg_color,
			intensity = color_scheme.tab_bar.active_tab.intensity,
			underline = color_scheme.tab_bar.active_tab.underline,
			italic = color_scheme.tab_bar.active_tab.italic,
			strikethrough = color_scheme.tab_bar.active_tab.strikethrough,
		},
		inactive_tab = {
			bg_color = color_scheme.tab_bar.inactive_tab.bg_color,
			fg_color = color_scheme.tab_bar.inactive_tab.fg_color,
			italic = color_scheme.tab_bar.inactive_tab.italic,
		},
		inactive_tab_hover = {
			bg_color = color_scheme.tab_bar.inactive_tab_hover.bg_color,
			fg_color = color_scheme.tab_bar.inactive_tab_hover.fg_color,
			italic = color_scheme.tab_bar.inactive_tab_hover.italic,
		},
		new_tab = {
			bg_color = color_scheme.tab_bar.new_tab.bg_color,
			fg_color = color_scheme.tab_bar.new_tab.fg_color,
		},
		new_tab_hover = {
			bg_color = color_scheme.tab_bar.new_tab_hover.bg_color,
			fg_color = color_scheme.tab_bar.new_tab_hover.fg_color,
			italic = color_scheme.tab_bar.new_tab_hover.italic,
		},
	},
}

config.command_palette_bg_color = color_scheme.background
config.command_palette_fg_color = color_scheme.foreground

-- TAB BAR
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false

-- Set button style based on platform and desktop environment
-- This makes Gnome buttons an option, which defaults would
-- otherwise miss because only MacOS and Windows are defaults
local xdg_desktop = os.getenv("XDG_CURRENT_DESKTOP") or ""
if platform:find("apple") then
	config.integrated_title_button_style = "MacOsNative"
-- Check explicitly for Gnome Desktop
elseif xdg_desktop:find("GNOME") then
	config.integrated_title_button_style = "Gnome"
-- If neither MacOS nor Gnome, use Windows buttons
else
	config.integrated_title_button_style = "Windows"
end

config.window_frame = {
	-- The font used in the tab bar.
	-- Roboto Bold is the default; this font is bundled
	-- with wezterm.
	-- Whatever font is selected here, it will have the
	-- main font setting appended to it to pick up any
	-- fallback fonts you may have used there.
	font = wezterm.font({ family = font_family, weight = "Bold" }),

	-- The size of the font in the tab bar.
	-- Default to 10.0 on Windows but 12.0 on other systems
	-- font_size = 12.0,

	-- The overall background color of the tab bar when
	-- the window is focused
	active_titlebar_bg = color_scheme.background,

	-- The overall background color of the tab bar when
	-- the window is not focused
	inactive_titlebar_bg = color_scheme.background,
}

-- WINDOW SETTINGS
config.initial_rows = 30
config.initial_cols = 120
config.scrollback_lines = 5000

-- GENERAL SETTINGS
config.hide_mouse_cursor_when_typing = true
config.use_dead_keys = false
config.pane_focus_follows_mouse = false

config.macos_window_background_blur = 20
config.window_background_opacity = 1.0
config.text_background_opacity = 1.0

-- KEYBINDINGS
-- Ensure keys table is initialized before inserting keybindings
config.keys = config.keys or {}

config.keys = {
	-- open launcher
	{
		mods = "CTRL|SHIFT",
		key = "p",
		action = wezterm.action.ActivateCommandPalette,
	},
	-- integrate clipboard with system clipboard
	{
		mods = "CTRL|SHIFT",
		key = "c",
		action = wezterm.action.CopyTo("Clipboard"),
	},
	{
		mods = "CTRL|SHIFT",
		key = "v",
		action = wezterm.action.PasteFrom("Clipboard"),
	},
}

-- MOUSE
-- Sets how to bypass app mouse reporting (default is SHIFT).
-- Use CTRL to handle Ctrl+Click by WezTerm even inside tmux/vim.
config.bypass_mouse_reporting_modifiers = "CTRL"

config.mouse_bindings = {
	-- Plain click selects; release copies to clipboard (copy-on-select).
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "NONE",
		action = wezterm.action.CompleteSelection("Clipboard"),
	},
	-- Ctrl+click: open link under cursor (works even with tmux mouse due to bypass modifier)
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CTRL",
		action = wezterm.action.OpenLinkAtMouseCursor,
	},
}

-- Platform-specific settings
if platform:find("apple") then
	config.native_macos_fullscreen_mode = false
	-- Insert keybinding for macOS fullscreen toggle
	table.insert(config.keys, { key = "n", mods = "SHIFT|CTRL", action = wezterm.action.ToggleFullScreen })
elseif platform:find("windows") then
	config.default_prog = { "powershell.exe", "-NoLogo" }
	config.enable_csi_u_key_encoding = true
end

-- Neovim Zen Mode Integration
wezterm.on("user-var-changed", function(window, pane, name, value)
	local overrides = window:get_config_overrides() or {}
	if name == "ZEN_MODE" then
		local incremental = value:find("+")
		local number_value = tonumber(value)
		if incremental ~= nil then
			while number_value > 0 do
				window:perform_action(wezterm.action.IncreaseFontSize, pane)
				number_value = number_value - 1
			end
			overrides.enable_tab_bar = false
		elseif number_value < 0 then
			window:perform_action(wezterm.action.ResetFontSize, pane)
			overrides.font_size = nil
			overrides.enable_tab_bar = true
		else
			overrides.font_size = number_value
			overrides.enable_tab_bar = false
		end
	end
	window:set_config_overrides(overrides)
end)

-- Disable the terminal bell
config.audible_bell = "Disabled"

-- Smart terminfo detection with fallback
local function get_best_term()
	-- Wrap in pcall to handle errors gracefully
	local ok, success = pcall(function()
		-- Check if wezterm terminfo is available
		return wezterm.run_child_process({ "infocmp", "wezterm" })
	end)
	-- If wezterm is available, use that, else fallback to widely compatible option
	return (ok and success) and "wezterm" or "xterm-256color"
end

-- Terminal tweaks
config.term = get_best_term()
config.enable_kitty_graphics = true

-- Return the configuration
return config
