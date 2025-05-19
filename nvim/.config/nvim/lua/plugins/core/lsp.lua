return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    priority = 1000,
    config = function()
      vim.lsp.enable({
        "lua_ls",
        "basedpyright",
      })
    end,
  },
}
