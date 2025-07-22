local colors = require("tokyonight.colors").setup()
local icons = require("config.icons")

local Snacks = require("snacks")

local project_root = {
  require("utils.helpers").project_root,
  icon = icons.statusline.root,
  separator = icons.statusline.separator,
  color = { fg = colors.blue },
}

-- Filetype-based condition functions for lualine components
-- Provides helpers to show/hide components based on current buffer's filetype
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
      lualine_a = { "mode" },
      lualine_b = {
        "branch",
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
      lualine_c = {
        {
          "diagnostics",
          symbols = {
            error = icons.diagnostics.Error,
            warn = icons.diagnostics.Warn,
            info = icons.diagnostics.Info,
            hint = icons.diagnostics.Hint,
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
          padding = { left = 1, right = 0 },
        },
        {
          function()
            -- Check if MCPHub is loaded
            if not vim.g.loaded_mcphub then
              return icons.statusline.mcphub .. "-"
            end

            local count = vim.g.mcphub_servers_count or 0
            local status = vim.g.mcphub_status or "stopped"
            local executing = vim.g.mcphub_executing

            -- Show "-" when stopped
            if status == "stopped" then
              return icons.statusline.mcphub .. "-"
            end

            -- Show spinner when executing, starting, or restarting
            if executing or status == "starting" or status == "restarting" then
              local frames = icons.tests.running_animated
              local frame = math.floor(vim.loop.now() / 100) % #frames + 1
              return icons.statusline.mcphub .. frames[frame]
            end

            return icons.statusline.mcphub .. count
          end,
          color = function()
            if not vim.g.loaded_mcphub then
              return { fg = colors.comment } -- Gray for not loaded
            end

            local status = vim.g.mcphub_status or "stopped"
            if status == "ready" or status == "restarted" then
              return { fg = colors.green } -- Green for connected
            elseif status == "starting" or status == "restarting" then
              return { fg = colors.orange } -- Orange for connecting
            else
              return { fg = colors.red } -- Red for error/stopped
            end
          end,
          padding = { left = 1, right = 1 },
        },
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
            return icons.statusline.spell .. langs
          end,
          cond = function() return spell_status() ~= nil end,
          color = function() return { fg = Snacks.util.color("Statement") } end,
        },
        -- stylua: ignore
        {
          function() return icons.statusline.debug .. require("dap").status() end,
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
          return icons.statusline.clock .. os.date("%R")
        end,
      },
    },
  },
}
