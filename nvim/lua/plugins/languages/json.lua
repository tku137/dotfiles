return {

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "json",
        "hjson", -- json with comments and trailing commas
        "json5", -- json with comments and trailing commas
      },
    },
  },

  -- LSP
  -- brew install vscode-langservers-extracted jsonlint
  -- OR
  -- mise use -g npm:vscode-json-languageserver@latest npm:jsonlint@latest
  -- NOTE: for some reason, jsonlint is needed
  {
    "neovim/nvim-lspconfig",
    opts = { servers = { "jsonls" } },
  },
}
