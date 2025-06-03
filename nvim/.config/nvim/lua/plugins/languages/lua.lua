return {

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "lua",
        "luadoc",
        "luap",
        "luau",
      },
    },
  },

  -- Install tools configured below
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = { ensure_installed = { "lua_ls", "stylua" } },
  },

  -- LSP
  {
    "mason-org/mason-lspconfig.nvim",
    opts = { ensure_installed = { "lua_ls" } },
  },

  -- Formatter
  {
    "stevearc/conform.nvim",
    opts_extend = { "formatters_by_ft.lua" }, -- important to convince lazy.nvim to merge this!
    opts = { formatters_by_ft = { lua = { "stylua" } } },
  },
}
