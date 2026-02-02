local prefix = "<localLeader>"
local sql_ft = { "sql", "mysql", "plsql" }

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
  :map("<leader>cp")

return {

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "sql" } },
  },

  -- LSP
  -- brew install sql-language-server
  -- OR
  -- mise use -g npm:sql-language-server@latest
  -- no brew bottle available for this:
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
  -- mise use -g pipx:sqlfluff@latest
  {
    "stevearc/conform.nvim",
    opts_extend = { "formatters_by_ft.sql" }, -- important to convince lazy.nvim to merge this!
    opts = { formatters_by_ft = { sql = { "sqlfluff" } } },
  },

  -- Dadbod backend
  { "tpope/vim-dadbod", cmd = { "DB" } },

  -- Completion source (also provides the blink provider module)
  {
    "kristijanhusak/vim-dadbod-completion",
    dependencies = { "tpope/vim-dadbod" },
    ft = sql_ft,
  },

  -- Dadbod UI
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      "tpope/vim-dadbod",
      "kristijanhusak/vim-dadbod-completion",
    },
    cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
    ft = sql_ft,
    keys = {
      { "<leader>D", "<cmd>DBUIToggle<cr>", desc = "Dadbod UI" },

      { prefix .. "r", ":%DB<cr>", ft = sql_ft, desc = "Run buffer" },
      { prefix .. "r", ":DB<cr>", mode = "v", ft = sql_ft, desc = "Run selection" },
      { prefix .. "p", "vip:DB<cr>", ft = sql_ft, desc = "Run paragraph" },
      { prefix .. "l", ":.DB<cr>", ft = sql_ft, desc = "Run line" },

      { prefix .. "i", "<cmd>DBUILastQueryInfo<cr>", ft = sql_ft, desc = "Last query info" },
      { prefix .. "u", "<cmd>DBUIToggle<cr>", ft = sql_ft, desc = "Toggle drawer" },
      { prefix .. "b", "<cmd>DBUIFindBuffer<cr>", ft = sql_ft, desc = "Find buffer" },
      { prefix .. "B", "<cmd>DBUIRenameBuffer<cr>", ft = sql_ft, desc = "Rename buffer" },
    },
    init = function()
      local project_root = require("utils.helpers").project_root_path()

      -- UI niceties
      vim.g.db_ui_use_nerd_fonts = true
      vim.g.db_ui_show_database_icon = true
      vim.g.db_ui_use_nvim_notify = true

      -- Dont execute on every save
      vim.g.db_ui_execute_on_save = false

      -- Reads env vars like DB_UI_DEV, DB_UI_PROD, …
      vim.g.db_ui_dotenv_variable_prefix = "DB_UI_"

      -- Always store DBUI state inside the project
      local base = vim.fs.joinpath(project_root, ".dbui")
      vim.g.db_ui_save_location = base
      vim.g.db_ui_tmp_query_location = vim.fs.joinpath(base, "tmp")
      vim.fn.mkdir(vim.g.db_ui_save_location, "p")
      vim.fn.mkdir(vim.g.db_ui_tmp_query_location, "p")
    end,
  },

  -- blink.cmp: inject provider + per-filetype sources
  {
    "saghen/blink.cmp",
    dependencies = { "kristijanhusak/vim-dadbod-completion" },
    opts = {
      sources = {
        providers = {
          dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
        },
        per_filetype = {
          sql = { "dadbod", "snippets", "buffer" },
          mysql = { "dadbod", "snippets", "buffer" },
          plsql = { "dadbod", "snippets", "buffer" },
        },
      },
    },
  },
}
