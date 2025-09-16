local prefix = "<Leader>ca"

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
    keys = {
      { prefix .. "a", "<cmd>AngularGotoTemplateForComponent<cr>", desc = "Go to Angular template" },
      { prefix .. "c", "<cmd>AngularGotoComponentWithTemplateFile<cr>", desc = "Go to Angular component" },
      { prefix .. "T", "<cmd>AngularGotoStylesheetForComponent<cr>", desc = "Go to Angular stylesheet" },
      { prefix .. "g", "<cmd>AngularGenerateClass<cr>", desc = "Generate Angular class" },
      { prefix .. "G", "<cmd>AngularGenerateComponent<cr>", desc = "Generate Angular component" },
      { prefix .. "s", "<cmd>AngularGenerateService<cr>", desc = "Generate Angular service" },
      { prefix .. "p", "<cmd>AngularGeneratePipe<cr>", desc = "Generate Angular pipe" },
      { prefix .. "d", "<cmd>AngularGenerateDirective<cr>", desc = "Generate Angular directive" },
      { prefix .. "m", "<cmd>AngularGenerateModule<cr>", desc = "Generate Angular module" },
      { prefix .. "i", "<cmd>AngularGenerateInterface<cr>", desc = "Generate Angular interface" },
      { prefix .. "e", "<cmd>AngularGenerateEnum<cr>", desc = "Generate Angular enum" },
      { prefix .. "r", "<cmd>AngularGenerateGuard<cr>", desc = "Generate Angular guard" },
    },
    config = function()
      -- Optional: Configure ng.nvim if needed
      -- Most configuration is handled by the Angular Language Server
    end,
  },

  -- Angular CLI integration (optional but useful)
  {
    "akinsho/toggleterm.nvim",
    optional = true,
    keys = {
      {
        prefix .. "t",
        function()
          local Terminal = require("toggleterm.terminal").Terminal
          local ng_terminal = Terminal:new({
            cmd = "ng serve",
            direction = "horizontal",
            close_on_exit = false,
            display_name = "Angular Dev Server",
          })
          ng_terminal:toggle()
        end,
        desc = "Start Angular dev server",
      },
      {
        prefix .. "b",
        function()
          local Terminal = require("toggleterm.terminal").Terminal
          local build_terminal = Terminal:new({
            cmd = "ng build",
            direction = "horizontal",
            close_on_exit = false,
            display_name = "Angular Build",
          })
          build_terminal:toggle()
        end,
        desc = "Build Angular project",
      },
      {
        prefix .. "T",
        function()
          local Terminal = require("toggleterm.terminal").Terminal
          local test_terminal = Terminal:new({
            cmd = "ng test",
            direction = "horizontal",
            close_on_exit = false,
            display_name = "Angular Tests",
          })
          test_terminal:toggle()
        end,
        desc = "Run Angular tests",
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
