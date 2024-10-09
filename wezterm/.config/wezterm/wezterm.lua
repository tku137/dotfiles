local wezterm = require("wezterm")
local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")

-- Use a single dark mode theme
local dark_mode = "Catppuccin Macchiato"
local light_mode = "Catppuccin Latte"

-- Create base config object
local config = wezterm.config_builder and wezterm.config_builder() or {}

-- Initialize keys table to avoid nil errors
config.keys = config.keys or {}

-- FONT SETTINGS
-- local font_family = "FiraCode Nerd Font"
local font_family = "JetBrainsMono Nerd Font"
config.font = wezterm.font(font_family)
config.font_size = 15.0
config.line_height = 1.1

-- Set the color scheme to dark mode
config.color_scheme = dark_mode

-- Define the tab bar colors manually with slight adjustments
config.use_fancy_tab_bar = true

config.window_frame = {
	font = wezterm.font({ family = font_family, weight = "Bold" }), -- Use font_family variable
	font_size = 13.0,
	active_titlebar_bg = "#1e2030",
	inactive_titlebar_bg = "#1e2030",
}

config.colors = {
	tab_bar = {
		background = "#1e2030", -- Background color of the tab bar

		active_tab = {
			bg_color = "#2d3248", -- Background color of the active tab
			fg_color = "#cad3f5", -- Foreground color of the active tab
			intensity = "Normal",
			underline = "None",
			italic = true,
			strikethrough = false,
		},

		inactive_tab = {
			bg_color = "#2b2e40", -- Background color of inactive tabs
			fg_color = "#a5adcb", -- Foreground color of inactive tabs
			italic = false,
		},

		inactive_tab_hover = {
			bg_color = "#3b3f52", -- Background color when hovering over inactive tabs
			fg_color = "#b8c0e0", -- Foreground color when hovering over inactive tabs
			italic = false,
		},

		new_tab = {
			bg_color = "#1e2030", -- Background color of the new tab button
			fg_color = "#b8c0e0", -- Foreground color of the new tab button
		},

		new_tab_hover = {
			bg_color = "#3b3f52", -- Background color when hovering over the new tab button
			fg_color = "#cad3f5", -- Foreground color when hovering over the new tab button
			italic = true,
		},
	},
}

-- WINDOW SETTINGS
config.initial_rows = 45
config.initial_cols = 140
config.scrollback_lines = 5000

-- GENERAL SETTINGS
config.hide_mouse_cursor_when_typing = true
config.hide_tab_bar_if_only_one_tab = true
config.use_dead_keys = false

-- Ensure keys table is initialized before inserting keybindings
config.keys = config.keys or {}

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

-- COMMAND PALETTE CUSTOMIZATIONS
config.command_palette_bg_color = "#24273a"
config.command_palette_fg_color = "#a5adcb"

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

-- apply smart_splits.nvim configuration
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
		move = "CTRL", -- modifier to use for pane movement, e.g. CTRL+h to move left
		resize = "META", -- modifier to use for pane resize, e.g. META+h to resize to the left
	},
})

-- Return the configuration
return config
