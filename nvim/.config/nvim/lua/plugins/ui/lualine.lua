local colors = require("tokyonight.colors").setup()

local project_root = {
  require("utils.helpers").project_root,
  icon = "󱉭",
  separator = "",
  color = { fg = colors.blue },
}

return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "bwpge/lualine-pretty-path",
    },
    opts = {
      options = {
        theme = "auto",
        globalstatus = vim.o.laststatus == 3,
        disabled_filetypes = { statusline = { "snacks_dashboard" } },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { project_root, "pretty_path" },
        lualine_x = { "filetype", "lsp_status" },
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
  },
}
