-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = 'Catppuccin Macchiato'



-- FONT
-- config.font = wezterm.font 'FiraCode Nerd Font'
config.font = wezterm.font_with_fallback({
    {
      family = "FiraCode Nerd Font Mono",
      weight = "Regular",
    },
    {
      -- Fallback font with all the Netd Font Symbols
      family = "Symbols Nerd Font Mono",
      scale = 0.9,
    },
  })
config.font_size = 14.0



-- WINDOW MANAGEMENT
config.initial_rows = 45
config.initial_cols = 140
config.scrollback_lines = 5000



-- TWEAKS
config.hide_mouse_cursor_when_typing = true
config.hide_tab_bar_if_only_one_tab = true

-- overwrites ToggleFullScreen key assignment to ujse native macOS fullscreen
config.native_macos_fullscreen_mode = false
config.keys = {
  {
    key = 'n',
    mods = 'SHIFT|CTRL',
    action = wezterm.action.ToggleFullScreen,
  },
}

config.pane_focus_follows_mouse = false


-- TAB BAR
config.use_fancy_tab_bar = true

config.window_frame = {
  -- The font used in the tab bar.
  -- Roboto Bold is the default; this font is bundled
  -- with wezterm.
  -- Whatever font is selected here, it will have the
  -- main font setting appended to it to pick up any
  -- fallback fonts you may have used there.
  font = wezterm.font { family = 'FiraCode Nerd Font Mono', weight = 'Bold' },

  -- The size of the font in the tab bar.
  -- Default to 10.0 on Windows but 12.0 on other systems
  font_size = 12.0,

  -- The overall background color of the tab bar when
  -- the window is focused
  active_titlebar_bg = '#1e2030',

  -- The overall background color of the tab bar when
  -- the window is not focused
  inactive_titlebar_bg = '#1e2030',
}

config.colors = {
  tab_bar = {
    active_tab = {
      -- The color of the background area for the tab
      bg_color = '#494d64',
      -- The color of the text for the tab
      fg_color = '#cad3f5',

      -- Specify whether you want "Half", "Normal" or "Bold" intensity for the
      -- label shown for this tab.
      -- The default is "Normal"
      intensity = 'Normal',

      -- Specify whether you want "None", "Single" or "Double" underline for
      -- label shown for this tab.
      -- The default is "None"
      underline = 'None',

      -- Specify whether you want the text to be italic (true) or not (false)
      -- for this tab.  The default is false.
      italic = false,

      -- Specify whether you want the text to be rendered with strikethrough (true)
      -- or not for this tab.  The default is false.
      strikethrough = false,
    },
    -- Inactive tabs are the tabs that do not have focus
    inactive_tab = {
      bg_color = '#24273a',
      fg_color = '#a5adcb',

      -- The same options that were listed under the `active_tab` section above
      -- can also be used for `inactive_tab`.
      italic = true,
    },
    -- You can configure some alternate styling when the mouse pointer
    -- moves over inactive tabs
    inactive_tab_hover = {
      bg_color = '#363a4f',
      fg_color = '#b8c0e0',
      italic = true,

      -- The same options that were listed under the `active_tab` section above
      -- can also be used for `inactive_tab_hover`.
    },
  },
}


-- and finally, return the configuration to wezterm
return config

