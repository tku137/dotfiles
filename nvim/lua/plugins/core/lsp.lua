-- Use custom diagnostic icons
local icons = require("config.icons").diagnostics

-- The following are predefined configs to be able to easily switch
-- between virtual text and virtual lines for diagnostics display.

-- Default config to show diagnostics as virtual TEXT
local diagnostic_virtual_text_config = {
  virtual_text = { spacing = 4, prefix = require("config.icons").diagnostics.prefix },
  virtual_lines = false,
}

-- Default config to show diagnostics as virtual LINES
local diagnostic_virtual_lines_config = {
  virtual_text = false,
  virtual_lines = { only_current_line = false },
}

-- Set virtual TEXT for diagnostics as default
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
})

return {
  -- Main LSP Configuration
  -- INFO: Custom LSP settings go into after/lsp/<servername>.lua
  {
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

      -- Enable inlay hints by default for any server that supports them.
      -- Use <leader>uh to toggle them off/on per buffer.
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-inlay-hints", { clear = true }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client:supports_method("textDocument/inlayHint", args.buf) then
            vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
          end
        end,
      })

      -- Which-Key toggle to switch between displaying of diagnostics
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
