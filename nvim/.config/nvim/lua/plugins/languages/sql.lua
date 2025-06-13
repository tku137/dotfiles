-- Add a keymap for toggling postgres_lsp
-- This toggles postgres_lsp on/off to reduce clutter
-- in projects where we do not use postgres sql files.
Snacks.toggle
  .new({
    name = "Postgres LSP",
    get = function()
      return vim.lsp.is_enabled("postgres_lsp")
    end,
    set = function()
      require("utils.lsp_utils").toggle_postgres({ silent = true })
    end,
  })
  :map("<leader>cP")

return {

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "sql" } },
  },

  -- LSP
  -- (no brew bottle available)
  -- mise use -g npm:@postgrestools/postgrestools@latest
  {
    "neovim/nvim-lspconfig",
    -- opts = { servers = { "sqlls", "postgres_lsp" } },
    -- Disable postgres_lsp at start and use the snacks toggle defined
    -- above to enable it when needed. This reduces clutter for
    -- non postgres sql files. We always use sqlls as a baseline.
    opts = { servers = { "sqlls" } },
  },

  -- Formatter
  -- brew install sqlfluff
  -- OR
  -- mise use -g npm:sql-language-server@latest
  -- mise use -g pipx:sqlfluff@latest
  {
    "stevearc/conform.nvim",
    opts_extend = { "formatters_by_ft.sql" }, -- important to convince lazy.nvim to merge this!
    opts = { formatters_by_ft = { sql = { "sqlfluff" } } },
  },

  {
    "kndndrj/nvim-dbee",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    build = function()
      -- Install tries to automatically detect the install method.
      -- if it fails, try calling it with one of these parameters:
      --    "curl", "wget", "bitsadmin", "go"
      require("dbee").install()
    end,
    config = function()
      require("dbee").setup(--[[optional config]])
    end,
  },
}
