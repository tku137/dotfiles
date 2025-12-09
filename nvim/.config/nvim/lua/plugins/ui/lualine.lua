local colors = require("tokyonight.colors").setup()
local icons = require("config.icons")
local Snacks = require("snacks")

-- Provides helpers to show/hide components based on current buffer's filetype
local cond = require("utils.ft_helpers")

-- Provides helper functions for custom statusline components
local sl = require("utils.statusline_helpers")

-- Type annotation to silence luals
---@class NoiceStatus
---@field has fun(): boolean
---@field get fun(): string|nil

return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy", -- Make sure all components are available
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "bwpge/lualine-pretty-path", -- LazyVim style path display
    {
      "AndreM222/copilot-lualine", -- copilot status
      event = "VeryLazy",
    },
    "folke/snacks.nvim", -- ensure snacks loads first
  },
  opts = {
    options = {
      theme = "auto",
      globalstatus = true,
      disabled_filetypes = { statusline = { "snacks_dashboard" } },
    },
    sections = {

      -- MODE
      lualine_a = { "mode" },

      -- Name of project root directory
      lualine_b = {
        {
          require("utils.helpers").project_root_name,
          icon = icons.statusline.root,
          separator = icons.statusline.separator,
          color = { fg = colors.blue },
          cond = cond.is_not_picker_filetype(),
        },

        -- Git branch the project is on
        "branch",

        -- Git status of the project
        {
          "diff",
          symbols = {
            added = icons.git.added,
            modified = icons.git.modified,
            removed = icons.git.removed,
          },
          source = function()
            local gitsigns = vim.b.gitsigns_status_dict
            if gitsigns then
              return {
                added = gitsigns.added,
                modified = gitsigns.changed,
                removed = gitsigns.removed,
              }
            end
          end,
        },
      },

      -- PATH INDICATORS
      -- guiding inside the project root up until the currently
      -- open file and the current breadcrumb symbols
      lualine_c = {
        -- mimicks LazyVims pretty path, deafult directory depths is 2
        {
          "pretty_path",
          cond = cond.is_not_picker_filetype(),
        },
        -- shows file type
        {
          "filetype",
          cond = cond.is_picker_filetype(),
          icon_only = true,
          colored = true,
        },
        -- Diagnostics indicators for current file
        {
          "diagnostics",
          symbols = {
            error = icons.diagnostics.Error,
            warn = icons.diagnostics.Warn,
            info = icons.diagnostics.Info,
            hint = icons.diagnostics.Hint,
          },
          cond = cond.is_not_picker_filetype(),
        },
        -- Symbols displayed as breadcrumbs
        {
          "aerial",
          sep = " ", -- separator between symbols
          sep_icon = "", -- separator between icon and symbol

          -- The number of symbols to render top-down. In order to render only 'N' last
          -- symbols, negative numbers may be supplied. For instance, 'depth = -1' can
          -- be used in order to render only current symbol.
          depth = 5,

          -- When 'dense' mode is on, icons are not rendered near their symbols. Only
          -- a single icon that represents the kind of current symbol is rendered at
          -- the beginning of status line.
          dense = false,

          -- The separator to be used to separate symbols in dense mode.
          dense_sep = ".",

          -- Color the symbol icons.
          colored = true,
        },
      },

      -- SPACE

      lualine_x = {

        -- Show captured events when the profiler is running
        Snacks.profiler.status(),

        -- TOOLING INDICATORS
        -- These are tightly packed to save space
        -- Show if ng serve is running for the current angular project:
        {
          sl.ng_status,
          -- stylua: ignore
          color = function() return { fg = colors.orange } end,
          separator = "",
          padding = { left = 1, right = 1 },
        },
        -- Show LSP status, spinner while loading, gear icon when connected:
        {
          sl.simple_lsp_status,
          -- stylua: ignore
          color = function() return { fg = colors.fg } end,
          separator = "",
          padding = { left = 1, right = 0 },
        },
        -- Show Copilot status:
        {
          "copilot",
          symbols = {
            status = {
              icons = icons.copilot,
              hl = {
                enabled = colors.fg,
                sleep = colors.teal,
                disabled = colors.fg_dark,
                warning = colors.orange,
                unknown = colors.red,
              },
            },
            spinners = "dots", -- has some premade spinners
            spinner_color = colors.blue,
          },
          show_colors = true,
          show_loading = true,
          separator = "",
          padding = { left = 0, right = 0 },
        },
        -- Show MCPHub status:
        {
          sl.mcphub_status,
          color = sl.mcphub_color,
          padding = { left = 0, right = 1 },
        },

        -- Displays showmode, for example macro recording
        -- stylua: ignore
        {
          function() return require("noice").api.status.mode.get() end,
          cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
          color = function() return { fg = Snacks.util.color("Constant") } end,
        },

        -- Spell status indicator
        -- shows what languages are set for spellcheck
        -- stylua: ignore
        {
          function() return icons.statusline.spell .. (sl.spell_status() or "") end,
          cond = function() return sl.spell_status() ~= nil end,
          color = function() return { fg = Snacks.util.color("Statement") } end,
        },

        -- Show DAP status
        -- stylua: ignore
        {
          function() return icons.statusline.debug .. require("dap").status() end,
          cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
          color = function() return { fg = Snacks.util.color("Debug") } end,
        },
      },

      -- Positional indicators
      lualine_y = {
        { "progress", separator = " ", padding = { left = 1, right = 0 } },
        { "location", padding = { left = 0, right = 1 } },
      },

      -- Clock
      lualine_z = {
        function()
          return icons.statusline.clock .. os.date("%R")
        end,
      },
    },
  },
}
