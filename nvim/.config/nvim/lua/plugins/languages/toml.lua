return {

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "toml" } },
  },

  -- LSP
  -- brew install taplo
  {
    "neovim/nvim-lspconfig",
    opts = { servers = { "taplo" } },
  },
}
