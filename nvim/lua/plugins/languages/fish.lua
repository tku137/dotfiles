return {

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "fish" } },
  },

  -- LSP
  -- brew install fish-lsp
  -- OR
  -- mise use -g npm:fish-lsp@latest
  {
    "neovim/nvim-lspconfig",
    opts = { servers = { "fish_lsp" } },
  },

  -- Formatter
  -- fish_indent comes with the fish shell :)
  {
    "stevearc/conform.nvim",
    opts_extend = { "formatters_by_ft.fish" }, -- important to convince lazy.nvim to merge this!
    opts = { formatters_by_ft = { fish = { "fish_indent" } } },
  },

  -- Linter
  -- Also comes with the fish shell
  {
    "mfussenegger/nvim-lint",
    opts_extend = { "linters_by_ft.fish" }, -- important to convince lazy.nvim to merge this!
    opts = { linters_by_ft = { fish = { "fish" } } },
  },
}
