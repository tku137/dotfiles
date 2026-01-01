local prefix = "<Leader>ct"

return {

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "javascript",
        "typescript",
        "tsx",
        "jsdoc",
        "json",
        "jsonc",
      },
    },
  },

  -- LSP
  -- mise use -g npm:@vtsls/language-server
  {
    "neovim/nvim-lspconfig",
    opts = { servers = { "vtsls" } },
  },

  -- Autotag for JSX/TSX
  {
    "windwp/nvim-ts-autotag",
    ft = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
    config = true,
  },

  -- vtsls niceties + auto on_attach when vtsls attaches
  {
    "yioneko/nvim-vtsls",
    lazy = true,
    config = function()
      require("vtsls").config({})
      local grp = vim.api.nvim_create_augroup("nvim_vtsls", { clear = true })
      vim.api.nvim_create_autocmd("LspAttach", {
        group = grp,
        desc = "Load nvim-vtsls helpers when vtsls attaches",
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.name == "vtsls" then
            require("vtsls")._on_attach(args.data.client_id, args.buf)
            -- Don't delete the augroup - it might be needed for multiple buffers
            -- not sure about this one
            -- pcall(vim.api.nvim_del_augroup_by_name, "nvim_vtsls")
          end
        end,
      })
    end,
  },

  -- Formatter chain (Biome > Prettierd > Prettier > eslint_d)
  {
    "stevearc/conform.nvim",
    opts_extend = {
      "formatters_by_ft.javascript",
      "formatters_by_ft.typescript",
      "formatters_by_ft.javascriptreact",
      "formatters_by_ft.typescriptreact",
      "formatters_by_ft.json",
      "formatters_by_ft.jsonc",
    },
    opts = {
      -- stylua: ignore
      formatters_by_ft = {
        javascript = { "prettierd", "prettier", "biome", "eslint_d", stop_after_first = true, lsp_format = "never" },
        typescript = { "prettierd", "prettier", "biome", "eslint_d", stop_after_first = true, lsp_format = "never" },
        javascriptreact = { "prettierd", "prettier", "biome", "eslint_d", stop_after_first = true, lsp_format = "never" },
        typescriptreact = { "prettierd", "prettier", "biome", "eslint_d", stop_after_first = true, lsp_format = "never" },
        json = { "prettierd", "prettier", "biome", stop_after_first = true, lsp_format = "never" },
        jsonc = { "prettierd", "prettier", "biome", stop_after_first = true, lsp_format = "never" },
      },
    },
  },

  -- package.json inline info
  {
    "vuki656/package-info.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    event = "BufRead package.json",
    opts = {},
    -- stylua: ignore
    keys = {
      { prefix .. "s", function() require("package-info").show({ force = true }) end, desc = "Show package info", ft = "json", },
      { prefix .. "h", function() require("package-info").hide() end, desc = "Hide package info", ft = "json", },
      { prefix .. "t", function() require("package-info").toggle() end, desc = "Toggle package info", ft = "json", },
      { prefix .. "u", function() require("package-info").update() end, desc = "Update package", ft = "json", },
      { prefix .. "r", function() require("package-info").delete() end, desc = "Delete package", ft = "json", },
      { prefix .. "i", function() require("package-info").install() end, desc = "Install package", ft = "json", },
      { prefix .. "v", function() require("package-info").change_version() end, desc = "Change package version", ft = "json", },
    },
  },

  -- tsc integration
  {
    "dmmulroy/tsc.nvim",
    cmd = "TSC",
    opts = { auto_open_qflist = true, auto_close_qflist = false, auto_focus_qflist = false },
    keys = {
      { prefix .. "c", "<cmd>TSC<cr>", desc = "TypeScript Compiler", ft = { "typescript", "typescriptreact" } },
    },
  },

  -- Jest tests via neotest
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = { { "nvim-neotest/neotest-jest", config = function() end } },
    opts = function(_, opts)
      opts.adapters = opts.adapters or {}
      table.insert(
        opts.adapters,
        require("neotest-jest")({
          jestCommand = "npm test --",
          jestConfigFile = function(file)
            if string.find(file, "/packages/") then
              return string.match(file, "(.-/[^/]+/)src") .. "jest.config.js"
            end
            return vim.fn.getcwd() .. "/jest.config.js"
          end,
          env = { CI = true },
          cwd = function(_)
            return vim.fn.getcwd()
          end,
        })
      )
    end,
  },
}
