return {
  {
    -- Main LSP Configuration
    -- Custom LSP settings go into after/lsp/<servername>.lua
    "neovim/nvim-lspconfig",
    lazy = false,
    priority = 1000,
    dependencies = {
      {
        -- Useful status updates for LSP.
        "j-hui/fidget.nvim",
        opts = {},
      },
      -- Allows extra capabilities provided by blink.cmp
      "saghen/blink.cmp",
    },
    config = function()
      -- WARN: make sure to have LSPs installed either
      -- system wide or project specific
      vim.lsp.enable({
        "lua_ls",
        "basedpyright",
        "yamlls",
      })
    end,
  },

  {
    -- SchemaStore catalog for jsonls and yamlls
    "b0o/SchemaStore.nvim",
    lazy = true,
    version = false, -- last release is way too old
  },

  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "snacks.nvim", words = { "Snacks" } },
      },
    },
  },
}
