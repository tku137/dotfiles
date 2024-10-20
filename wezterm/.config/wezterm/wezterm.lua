-- Pull in the wezterm API
local wezterm = require("wezterm")

-- Pull in the smart_splits.nvim plugin
local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")

-- Create base config object
local config = wezterm.config_builder and wezterm.config_builder() or {}

-- FONT SETTINGS
-- local font_family = "FiraCode Nerd Font"
local font_family = "JetBrainsMono Nerd Font"
config.font = wezterm.font(font_family)
local platform = wezterm.target_triple
if platform:find("windows") then
	config.font_size = 12.0
else
	config.font_size = 15.0
end
config.line_height = 1.1

-- COLOR SCHEME SETTINGS
-- Define the color schemes
local dark_mode = "Catppuccin Macchiato"
-- local light_mode = "Catppuccin Latte"

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
config.use_fancy_tab_bar = true

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
config.hide_tab_bar_if_only_one_tab = true
config.use_dead_keys = false
config.pane_focus_follows_mouse = false

config.macos_window_background_blur = 20
config.window_background_opacity = 1.0
config.text_background_opacity = 1.0

-- KEYBINDINGS
-- Ensure keys table is initialized before inserting keybindings
config.keys = config.keys or {}

-- Leader is the same as the (modified) tmux prefix
config.leader = { key = "p", mods = "CTRL|SHIFT", timeout_milliseconds = 1000 }

config.keys = {
	-- splitting
	{
		mods = "LEADER",
		key = "-",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		mods = "LEADER",
		key = "=",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		mods = "LEADER",
		key = "m",
		action = wezterm.action.TogglePaneZoomState,
	},
	-- rotate panes
	{
		mods = "LEADER",
		key = "Space",
		action = wezterm.action.RotatePanes("Clockwise"),
	},
	-- show the pane selection mode, but have it swap the active and selected panes
	{
		mods = "LEADER",
		key = "0",
		action = wezterm.action.PaneSelect({
			mode = "SwapWithActive",
		}),
	},
	-- activate copy mode or vim mode
	{
		key = "Enter",
		mods = "LEADER",
		action = wezterm.action.ActivateCopyMode,
	},
	-- open launcher
	{
		mods = "LEADER",
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
	-- cycle through tabs
	{
		mods = "LEADER",
		key = "Tab",
		action = wezterm.action.PaneSelect,
	},
}

-- Platform-specific settings
local platform = wezterm.target_triple
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

-- Apply smart_splits.nvim configuration
smart_splits.apply_to_config(config, {
	-- the default config is here, if you'd like to use the default keys,
	-- you can omit this configuration table parameter and just use
	-- smart_splits.apply_to_config(config)

	-- directional keys to use in order of: left, down, up, right
	-- direction_keys = { "h", "j", "k", "l" },
	-- if you want to use separate direction keys for move vs. resize, you
	-- can also do this:
	direction_keys = {
		move = { "h", "j", "k", "l" },
		resize = { "LeftArrow", "DownArrow", "UpArrow", "RightArrow" },
	},
	-- modifier keys to combine with direction_keys
	modifiers = {
		move = "META", -- modifier to use for pane movement, e.g. CTRL+h to move left
		resize = "META", -- modifier to use for pane resize, e.g. META+h to resize to the left
	},
})

-- Disable the terminal bell
config.audible_bell = "Disabled"

-- Return the configuration
return config
