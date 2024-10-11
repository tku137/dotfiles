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
config.font_size = 15.0
config.line_height = 1.1

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
	font_size = 12.0,

	-- The overall background color of the tab bar when
	-- the window is focused
	active_titlebar_bg = "#1e2030",

	-- The overall background color of the tab bar when
	-- the window is not focused
	inactive_titlebar_bg = "#1e2030",
}

-- COLOR SCHEME SETTINGS
-- Define the color schemes
local dark_mode = "Catppuccin Macchiato"
local light_mode = "Catppuccin Latte"
-- Set the color scheme to dark mode
config.color_scheme = dark_mode

config.colors = {
	tab_bar = {
		active_tab = {
			-- The color of the background area for the tab
			bg_color = "#494d64",
			-- The color of the text for the tab
			fg_color = "#cad3f5",

			-- Specify whether you want "Half", "Normal" or "Bold" intensity for the
			-- label shown for this tab.
			-- The default is "Normal"
			intensity = "Normal",

			-- Specify whether you want "None", "Single" or "Double" underline for
			-- label shown for this tab.
			-- The default is "None"
			underline = "None",

			-- Specify whether you want the text to be italic (true) or not (false)
			-- for this tab.  The default is false.
			italic = true,

			-- Specify whether you want the text to be rendered with strikethrough (true)
			-- or not for this tab.  The default is false.
			strikethrough = false,
		},
		-- Inactive tabs are the tabs that do not have focus
		inactive_tab = {
			bg_color = "#24273a",
			fg_color = "#a5adcb",

			-- The same options that were listed under the `active_tab` section above
			-- can also be used for `inactive_tab`.
			italic = false,
		},
		-- You can configure some alternate styling when the mouse pointer
		-- moves over inactive tabs
		inactive_tab_hover = {
			bg_color = "#363a4f",
			fg_color = "#b8c0e0",
			italic = true,
		},

		new_tab = {
			bg_color = "#24273a", -- Background color of the new tab button
			fg_color = "#a5adcb", -- Foreground color of the new tab button
		},

		new_tab_hover = {
			bg_color = "#494d64", -- Background color when hovering over the new tab button
			fg_color = "#cad3f5", -- Foreground color when hovering over the new tab button
			italic = true,
		},
	},
}

config.command_palette_bg_color = "#24273a"
config.command_palette_fg_color = "#a5adcb"

-- WINDOW SETTINGS
config.initial_rows = 45
config.initial_cols = 140
config.scrollback_lines = 5000

-- GENERAL SETTINGS
config.hide_mouse_cursor_when_typing = true
config.hide_tab_bar_if_only_one_tab = true
config.use_dead_keys = false
config.pane_focus_follows_mouse = false

-- KEYBINDINGS
-- Ensure keys table is initialized before inserting keybindings
config.keys = config.keys or {}

-- Leader is the same as the (modified) tmux prefix
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }

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
		move = "CTRL", -- modifier to use for pane movement, e.g. CTRL+h to move left
		resize = "META", -- modifier to use for pane resize, e.g. META+h to resize to the left
	},
})

-- Disable the terminal bell
config.audible_bell = "Disabled"

-- Return the configuration
return config
