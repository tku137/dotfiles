local icons = require("config.icons").diagnostics

vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = icons.Error,
      [vim.diagnostic.severity.WARN] = icons.Warn,
      [vim.diagnostic.severity.INFO] = icons.Info,
      [vim.diagnostic.severity.HINT] = icons.Hint,
    },
  },
})

return {
  {
    -- Main LSP Configuration
    -- INFO: Custom LSP settings go into after/lsp/<servername>.lua
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      {
        -- Useful status updates for LSP.
        "j-hui/fidget.nvim",
        opts = {},
      },
      -- Allows extra capabilities provided by blink.cmp
      "saghen/blink.cmp",
    },
    opts_extend = { "servers" },
    opts = { servers = { "lua_ls", "yamlls" } },
    config = function(_, opts)
      -- WARN: make sure to have LSPs installed either
      -- system wide or project specific

      -- TODO: add this to readme
      -- INFO: To add language specific LSP in their own config file, use this snippet:
      -- {
      --   "neovim/nvim-lspconfig",
      --    opts = { servers = { "ruff", "basedpyright" } },
      -- },

      -- opts.servers is a list of servers to enable, merged from all
      -- language specific config files
      vim.lsp.enable(opts.servers)
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
