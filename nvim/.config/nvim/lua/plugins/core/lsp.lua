local icons = require("config.icons").diagnostics

-- Default config to show diagnostics as virtual text
local diagnostic_virtual_text_config = {
  virtual_text = { spacing = 4, prefix = "●" },
  virtual_lines = false,
}

-- Default config to show diagnostics as virtual lines
local diagnostic_virtual_lines_config = {
  virtual_text = false,
  virtual_lines = { only_current_line = false },
}

-- Set virtual text for diagnostics as default
vim.diagnostic.config(diagnostic_virtual_text_config)

-- Configure all other global diagnostics settings
vim.diagnostic.config({
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = icons.Error,
      [vim.diagnostic.severity.WARN] = icons.Warn,
      [vim.diagnostic.severity.INFO] = icons.Info,
      [vim.diagnostic.severity.HINT] = icons.Hint,
    },
  },
  -- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
  -- Be aware that you also will need to properly configure your LSP server to
  -- provide the inlay hints.
  inlay_hints = {
    enabled = true,
    exclude = { "vue" }, -- filetypes for which you don't want to enable inlay hints
  },
  -- Enable this to enable the builtin LSP code lenses on Neovim >= 0.10.0
  -- Be aware that you also will need to properly configure your LSP server to
  -- provide the code lenses.
  codelens = {
    enabled = false,
  },
  -- add any global capabilities here
  capabilities = {
    workspace = {
      fileOperations = {
        didRename = true,
        willRename = true,
      },
    },
  },
  -- options for vim.lsp.buf.format
  -- `bufnr` and `filter` is handled by the LazyVim formatter,
  -- but can be also overridden when specified
  format = {
    formatting_options = nil,
    timeout_ms = nil,
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

      -- Which-Key toggle to swithc between displaying of diagnostics
      -- as either virtual text or virtual lines
      Snacks.toggle
        .new({
          name = "Virtual Line Diagnostics",
          get = function()
            local vlines_current_config = vim.diagnostic.config().virtual_lines
            -- Virtual lines are considered active if their configuration value
            -- is not nil AND not false.
            return vlines_current_config ~= nil and vlines_current_config ~= false
          end,
          set = function(inline)
            if inline then
              -- Set virtual text settings defined above
              vim.diagnostic.config(diagnostic_virtual_lines_config)
            else
              -- Set virtual lines settings defined above
              vim.diagnostic.config(diagnostic_virtual_text_config)
            end
          end,
        })
        :map("<leader>uv")
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
