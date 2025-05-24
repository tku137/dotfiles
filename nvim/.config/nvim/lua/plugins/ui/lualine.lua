local colors = require("tokyonight.colors").setup()

local Snacks = require("snacks")

local project_root = {
  require("utils.helpers").project_root,
  icon = "󱉭",
  separator = "",
  color = { fg = colors.blue },
}

-- Returns a closure that lualine calls later
local function ft_cond(ft, negate)
  return function()
    --  xor-style logic: when negate is true, invert the test
    return (vim.bo.filetype == ft) ~= (negate or false)
  end
end

-- Condition function resembling == ft
local only_cond = function(ft)
  return ft_cond(ft, false)
end

-- Condition function resembling ~= ft
local except_cond = function(ft)
  return ft_cond(ft, true)
end

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
      lualine_b = { "branch", "diff", "diagnostics" },
      -- TODO: add aerial status component with leftsep var?
      lualine_c = {
        {
          "filetype",
          cond = only_cond("snacks_picker_list"),
          icon_only = true,
          colored = true,
        },
        {
          project_root[1],
          icon = project_root.icon,
          separator = project_root.separator,
          color = project_root.color,
          cond = except_cond("snacks_picker_list"),
        },
        {
          "pretty_path",
          cond = except_cond("snacks_picker_list"),
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
