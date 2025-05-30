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

  -- LSP
  -- brew install lua-language-server
  {
    "neovim/nvim-lspconfig",
    opts = { servers = { "lua_ls" } },
  },

  -- Formatter
  -- brew install stylua
  {
    "stevearc/conform.nvim",
    opts_extend = { "formatters_by_ft.lua" }, -- important to convince lazy.nvim to merge this!
    opts = { formatters_by_ft = { lua = { "stylua" } } },
  },
}
