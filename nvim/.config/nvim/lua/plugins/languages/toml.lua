return {

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "toml" } },
  },

  -- LSP
  -- brew install taplo
  -- OR
  -- mise use -g taplo@latest
  {
    "neovim/nvim-lspconfig",
    opts = { servers = { "taplo" } },
  },
}
