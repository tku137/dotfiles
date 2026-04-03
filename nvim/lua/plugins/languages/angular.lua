local prefix = "<Leader>cn"
local opts = { noremap = true, silent = true }

return {
  -- Treesitter for Angular templates
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "angular" },
    },
  },

  -- Angular Language Server
  -- Install: npm install -g @angular/language-server
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = { "angularls" },
    },
  },

  -- Enhanced Angular support
  {
    "joeveiga/ng.nvim",
    ft = { "typescript", "html", "typescriptreact", "scss", "css" },
    -- stylua: ignore
    keys = {
      { prefix .. "t", function() require("ng").goto_template_for_component(opts) end, desc = "Angular: goto template", },
      { prefix .. "c", function() require("ng").goto_component_with_template_file(opts) end, desc = "Angular: goto component", },
      -- TCB (optional, handy when templates act weird)
      { prefix .. "T", function() require("ng").get_template_tcb() end, desc = "Angular: show template TCB", },
    },
  },

  -- Angular CLI integration (optional but useful)
  {
    "akinsho/toggleterm.nvim",
    optional = true,
    keys = {
      {
        prefix .. "s",
        function()
          local T = require("toggleterm.terminal").Terminal
          _NG_SERVE = _NG_SERVE
            or T:new({
              count = 201,
              name = "ng serve",
              cmd = "ng serve",
              dir = "git_dir",
              direction = "horizontal",
              close_on_exit = false,
            })
          _NG_SERVE:toggle()
        end,
        desc = "Angular: ng serve (local)",
      },
      {
        prefix .. "S",
        function()
          local T = require("toggleterm.terminal").Terminal
          _NG_SERVE_LAN = _NG_SERVE_LAN
            or T:new({
              count = 202,
              name = "ng serve (LAN)",
              cmd = "ng serve --host 0.0.0.0 --port 4200",
              dir = "git_dir",
              direction = "horizontal",
              close_on_exit = false,
            })
          _NG_SERVE_LAN:toggle()
        end,
        desc = "Angular: ng serve (LAN 0.0.0.0:4200)",
      },
      {
        prefix .. "b",
        function()
          local T = require("toggleterm.terminal").Terminal
          _NG_BUILD = _NG_BUILD
            or T:new({
              count = 203,
              name = "ng build",
              cmd = "ng build",
              dir = "git_dir",
              direction = "horizontal",
              close_on_exit = false,
            })
          _NG_BUILD:toggle()
        end,
        desc = "Angular: ng build",
      },
      {
        prefix .. "t",
        function()
          local T = require("toggleterm.terminal").Terminal
          _NG_TEST = _NG_TEST
            or T:new({
              count = 204,
              name = "ng test",
              cmd = "ng test",
              dir = "git_dir",
              direction = "horizontal",
              close_on_exit = false,
            })
          _NG_TEST:toggle()
        end,
        desc = "Angular: ng test",
      },
    },
  },

  -- Angular testing with Jest/Karma
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      { "nvim-neotest/neotest-jest", config = function() end },
    },
    opts = function(_, opts)
      opts.adapters = opts.adapters or {}
      -- Jest adapter for Angular (if using Jest instead of Karma)
      table.insert(
        opts.adapters,
        require("neotest-jest")({
          jestCommand = "npm run test --",
          jestConfigFile = function(file)
            if string.find(file, "src") then
              return vim.fn.getcwd() .. "/jest.config.js"
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

  -- Enhanced HTML/Template support for Angular
  {
    "windwp/nvim-ts-autotag",
    ft = { "html", "typescript", "typescriptreact" },
    opts = {
      opts = {
        enable_close = true, -- Auto close tags
        enable_rename = true, -- Auto rename pairs of tags
        enable_close_on_slash = true, -- Auto close on trailing </
      },
      -- Add Angular-specific settings
      per_filetype = {
        ["html"] = {
          enable_close = true,
          enable_rename = true,
          enable_close_on_slash = true,
        },
      },
    },
  },

  -- Angular-specific formatters
  {
    "stevearc/conform.nvim",
    opts_extend = {
      "formatters_by_ft.html", -- Angular templates
    },
    opts = {
      formatters_by_ft = {
        -- Angular HTML templates
        html = { "prettierd", "prettier", stop_after_first = true },
      },
      -- Custom formatter for Angular HTML templates
      formatters = {
        ["angular-prettier"] = {
          command = "prettier",
          args = { "--parser", "angular", "--stdin-filepath", "$FILENAME" },
          stdin = true,
        },
      },
    },
  },

  -- Angular project file recognition
  {
    "neovim/nvim-lspconfig",
    init = function()
      -- Recognize Angular files
      vim.filetype.add({
        pattern = {
          [".*%.component%.html"] = "html", -- Angular component templates
          [".*%.component%.ts"] = "typescript", -- Angular components
          [".*%.service%.ts"] = "typescript", -- Angular services
          [".*%.directive%.ts"] = "typescript", -- Angular directives
          [".*%.pipe%.ts"] = "typescript", -- Angular pipes
          [".*%.guard%.ts"] = "typescript", -- Angular guards
          [".*%.module%.ts"] = "typescript", -- Angular modules
          [".*%.spec%.ts"] = "typescript", -- Angular test files
        },
      })
    end,
  },

  -- Optional: Angular snippets
  {
    "L3MON4D3/LuaSnip",
    optional = true,
    dependencies = {
      {
        "rafamadriz/friendly-snippets",
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load({
            include = { "angular", "typescript", "html" },
          })
        end,
      },
    },
  },
}
