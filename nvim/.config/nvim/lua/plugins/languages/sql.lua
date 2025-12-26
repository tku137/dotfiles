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
    cmd = { "Dbee" },
    build = function()
      -- Install tries to automatically detect the install method.
      -- if it fails, try calling it with one of these parameters:
      --    "curl", "wget", "bitsadmin", "go"
      require("dbee").install()
    end,
    config = function()
      local uv = vim.uv or vim.loop
      local project_root = require("utils.helpers").project_root_path()

      -- Project-local connections file and scratchpad directory
      local project_file = vim.fs.joinpath(project_root, ".dbee-connections.json")
      local local_scratch = vim.fs.joinpath(project_root, ".dbee-scratchpad")

      -- Global scratchpad directory
      local global_scratch = vim.fs.joinpath(vim.fn.stdpath("state"), "dbee", "scratch")

      -- Prefer local scratch if it already exists OR if there is a connections file
      local scratch_dir
      if uv.fs_stat(local_scratch) or uv.fs_stat(project_file) then
        scratch_dir = local_scratch
      else
        scratch_dir = global_scratch
      end

      -- Make sure scratch dir exists
      vim.fn.mkdir(scratch_dir, "p")

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

      -- Only load cmp-dbee when nvim-dbee is loaded
      pcall(function()
        require("lazy").load({ plugins = { "cmp-dbee" } })
      end)
    end,
    keys = {
      {
        "<leader>D",
        "<cmd>Dbee toggle<cr>",
        desc = "DBee UI",
      },
    },
  },
  -- using blink.compat to get suggestions of this nvim-cmp source
  {
    "MattiasMTS/cmp-dbee",
    lazy = true,
    dependencies = { "kndndrj/nvim-dbee" },
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
    },
    opts = function(_, opts)
      local function is_loaded(name)
        local ok, cfg = pcall(require, "lazy.core.config")
        return ok and cfg.plugins[name] and cfg.plugins[name]._.loaded
      end

      opts.sources = opts.sources or {}
      opts.sources.default = opts.sources.default or { "dbee" }
      opts.sources.providers = opts.sources.providers or {}

      opts.sources.providers.dbee = {
        name = "cmp-dbee",
        module = "blink.compat.source",
        enabled = function()
          return vim.tbl_contains(sql_ft, vim.bo.filetype) and is_loaded("cmp-dbee")
        end,
        opts = {},
      }
    end,
  },
}
