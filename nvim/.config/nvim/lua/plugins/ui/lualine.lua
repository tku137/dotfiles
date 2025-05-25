local colors = require("tokyonight.colors").setup()

local Snacks = require("snacks")

local project_root = {
  require("utils.helpers").project_root,
  icon = "󱉭",
  separator = "",
  color = { fg = colors.blue },
}

local cond = require("utils.ft_helpers")

-- Returns formatted list of spell languages if spell checking is enabled.
local function spell_status()
  if vim.wo.spell then
    local langs = vim.bo.spelllang or ""
    langs = vim.trim(langs)
    if langs ~= "" then
      return langs
    end
  end
  return nil
end

---@class NoiceStatus
---@field has fun(): boolean
---@field get fun(): string|nil

return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "bwpge/lualine-pretty-path",
    "folke/snacks.nvim", -- ensure snacks loads first
  },
  opts = {
    options = {
      theme = "auto",
      globalstatus = true,
      disabled_filetypes = { statusline = { "snacks_dashboard" } },
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = {
        "branch",
        {
          "diff",
          symbols = {
            added = require("config.icons").git.added,
            modified = require("config.icons").git.modified,
            removed = require("config.icons").git.removed,
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
      lualine_c = {
        {
          "diagnostics",
          symbols = {
            error = require("config.icons").diagnostics.Error,
            warn = require("config.icons").diagnostics.Warn,
            info = require("config.icons").diagnostics.Info,
            hint = require("config.icons").diagnostics.Hint,
          },
        },
        {
          "filetype",
          cond = cond.is_picker_filetype(),
          icon_only = true,
          colored = true,
        },
        {
          project_root[1],
          icon = project_root.icon,
          separator = project_root.separator,
          color = project_root.color,
          cond = cond.is_not_picker_filetype(),
        },
        {
          "pretty_path",
          cond = cond.is_not_picker_filetype(),
        },
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
      lualine_x = {
        Snacks.profiler.status(),
        -- Displays showcmd
        -- stylua: ignore
        {
          function() return require("noice").api.status.command.get() end,
          cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
          color = function() return { fg = Snacks.util.color("Statement") } end,
        },
        -- Displays showmode, for example macro recording
        -- stylua: ignore
        {
          function() return require("noice").api.status.mode.get() end,
          cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
          color = function() return { fg = Snacks.util.color("Constant") } end,
        },
        -- Spell status indicator
        -- stylua: ignore
        {
          function()
            local langs = spell_status()
            return " " .. langs
          end,
          cond = function() return spell_status() ~= nil end,
          color = function() return { fg = Snacks.util.color("Statement") } end,
        },
        -- stylua: ignore
        {
          function() return "  " .. require("dap").status() end,
          cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
          color = function() return { fg = Snacks.util.color("Debug") } end,
        },
      },
      lualine_y = {
        { "progress", separator = " ", padding = { left = 1, right = 0 } },
        { "location", padding = { left = 0, right = 1 } },
      },
      lualine_z = {
        function()
          return " " .. os.date("%R")
        end,
      },
    },
  },
}
