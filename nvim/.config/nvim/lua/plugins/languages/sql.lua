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
      -- Project-local connections file and scratchpad directory
      local project_root = require("utils.helpers").project_root_path()
      local project_file = vim.fs.joinpath(project_root, ".dbee-connections.json")
      local scratch_dir = vim.fs.joinpath(project_root, ".dbee-scratchpad")
      vim.fn.mkdir(scratch_dir, "p") -- ensure dir exists

      require("dbee").setup({
        result = {
          mappings = {
            -- next/previous page
            { key = "L", mode = "", action = "page_next" },
            { key = "H", mode = "", action = "page_prev" },
            { key = "E", mode = "", action = "page_last" },
            { key = "F", mode = "", action = "page_first" },

            -- yank rows as csv/json
            { key = prefix .. "j", mode = "n", action = "yank_current_json", opts = { desc = "copy row as JSON" } },
            {
              key = prefix .. "j",
              mode = "v",
              action = "yank_selection_json",
              opts = { desc = "copy selection as JSON" },
            },
            { key = prefix .. "J", mode = "", action = "yank_all_json", opts = { desc = "copy all as JSON" } },
            { key = prefix .. "c", mode = "n", action = "yank_current_csv", opts = { desc = "copy row as CSV" } },
            {
              key = prefix .. "c",
              mode = "v",
              action = "yank_selection_csv",
              opts = { desc = "copy selection as CSV" },
            },
            { key = prefix .. "C", mode = "", action = "yank_all_csv", opts = { desc = "copy all as CSV" } },

            -- cancel current call execution
            { key = "<C-c>", mode = "", action = "cancel_call" },
          },
        },
        editor = {
          -- store scratchpad files to persistent directory defined above
          directory = scratch_dir,
        },
        sources = {
          -- load project specific connections, reads a `.dbee-connections.json` file
          -- from the project root path with following content:
          -- [
          --   {
          --     "id": "dev_db",
          --     "name": "Dev DB",
          --     "type": "postgres",
          --     "url": "postgres://user:pass@host:5432/mydb?sslmode=disable"
          --   }
          -- ]
          require("dbee.sources").FileSource:new(project_file),
        },
      })
    end,
    keys = {
      {
        "<leader>D",
        function()
          require("dbee").toggle()
        end,
        desc = "DBee UI",
      },
    },
  },
  -- using blink.compat to get suggestions of this nvim-cmp source
  {
    "MattiasMTS/cmp-dbee",
    dependencies = { "kndndrj/nvim-dbee" },
    ft = sql_ft,
    opts = {}, -- needed
  },
  {
    "saghen/blink.cmp",
    dependencies = {
      {
        "saghen/blink.compat",
        version = "2.*",
        lazy = true,
        opts = {}, -- needed
      },
      { "MattiasMTS/cmp-dbee" },
    },
    opts = {
      sources = {
        default = { "dbee" },

        providers = {
          dbee = {
            name = "cmp-dbee",
            module = "blink.compat.source",
            enabled = function()
              return vim.tbl_contains(sql_ft, vim.bo.filetype)
            end,
            opts = {},
          },
        },
      },
    },
  },
}
