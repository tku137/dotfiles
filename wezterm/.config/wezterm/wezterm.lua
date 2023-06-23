local wezterm = require 'wezterm'
local config = {}

config.color_scheme = 'Catppuccin Macchiato'

-- config.font = wezterm.font 'FiraCode Nerd Font'
config.font = wezterm.font_with_fallback({
    {
      family = "FiraCode Nerd Font",
      weight = "Regular",
    },
    {
      -- Fallback font with all the Netd Font Symbols
      family = "Symbols Nerd Font Mono",
      scale = 0.9,
    },
  })
config.font_size = 14.0

config.initial_rows = 45
config.initial_cols = 140
config.scrollback_lines = 5000

return config
