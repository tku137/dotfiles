return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    priority = 1000,
    config = function()
      vim.lsp.enable({
        "lua_ls",
        "basedpyright",
        "yamlls",
      })
    end,
  },
  {
    "b0o/SchemaStore.nvim",
    lazy = true,
    version = false, -- last release is way too old
  },
}
