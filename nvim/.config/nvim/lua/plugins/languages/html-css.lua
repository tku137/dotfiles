local prefix = "<Leader>ch"

return {
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "html",
        "css",
        "scss",
        "styled", -- for styled-components
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
      -- Register additional parsers
      vim.treesitter.language.register("scss", "less")
      vim.treesitter.language.register("scss", "postcss")
    end,
  },

  -- Additional filetypes
  {
    "neovim/nvim-lspconfig",
    init = function()
      -- Set up additional filetypes
      vim.filetype.add({
        extension = {
          pcss = "postcss",
          postcss = "postcss",
        },
      })
    end,
    opts = {
      servers = {
        "html", -- HTML language server
        "cssls", -- CSS language server
        "emmet_ls", -- Emmet for HTML/CSS expansion
        "tailwindcss", -- Tailwind CSS IntelliSense (optional but recommended)
      },
    },
  },

  -- Emmet support for HTML/CSS expansion
  {
    "olrtg/nvim-emmet",
    config = function()
      vim.keymap.set({ "n", "v" }, prefix .. "e", require("nvim-emmet").wrap_with_abbreviation)
    end,
    keys = {
      { prefix .. "e", mode = { "n", "v" }, desc = "Emmet wrap with abbreviation" },
    },
    ft = { "html", "css", "scss", "less", "postcss", "javascript", "typescript", "javascriptreact", "typescriptreact" },
  },

  -- Enhanced Tailwind CSS support
  {
    "luckasRanarison/tailwind-tools.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ft = {
      "html",
      "css",
      "scss",
      "less",
      "postcss",
      "javascript",
      "typescript",
      "javascriptreact",
      "typescriptreact",
      "vue",
      "svelte",
    },
    keys = {
      { prefix .. "t", "<cmd>TailwindConcealToggle<cr>", desc = "Toggle Tailwind concealing" },
      { prefix .. "s", "<cmd>TailwindSort<cr>", desc = "Sort Tailwind classes", mode = { "n", "v" } },
      { prefix .. "n", "<cmd>TailwindNextClass<cr>", desc = "Next Tailwind class" },
      { prefix .. "p", "<cmd>TailwindPrevClass<cr>", desc = "Previous Tailwind class" },
    },
    opts = {
      document_color = {
        enabled = true, -- can be toggled by commands
        kind = "inline", -- "inline" | "foreground" | "background"
        inline_symbol = "󰝤 ", -- only used in inline mode
        debounce = 200, -- in milliseconds, only applied in insert mode
      },
      conceal = {
        enabled = false, -- can be toggled by commands
        min_length = nil, -- only conceal classes exceeding the provided length
        symbol = "󱏿", -- only a single character is allowed
        highlight = {
          fg = "#38BDF8", -- text color
        },
      },
      custom_filetypes = {}, -- see the extension section to learn how it works
    },
  },

  -- Color preview and picker
  {
    "uga-rosa/ccc.nvim",
    cmd = { "CccPick", "CccConvert", "CccHighlighterEnable", "CccHighlighterDisable", "CccHighlighterToggle" },
    ft = { "html", "css", "scss", "less", "postcss", "javascript", "typescript", "javascriptreact", "typescriptreact" },
    keys = {
      { prefix .. "c", "<cmd>CccPick<cr>", desc = "Color picker" },
      { prefix .. "C", "<cmd>CccConvert<cr>", desc = "Color converter" },
      { prefix .. "h", "<cmd>CccHighlighterToggle<cr>", desc = "Toggle color highlighter" },
    },
    config = function()
      local ccc = require("ccc")
      ccc.setup({
        highlighter = {
          auto_enable = true,
          lsp = true,
        },
        pickers = {
          ccc.picker.hex,
          ccc.picker.css_rgb,
          ccc.picker.css_hsl,
          ccc.picker.css_hwb,
          ccc.picker.css_lab,
          ccc.picker.css_lch,
          ccc.picker.css_oklab,
          ccc.picker.css_oklch,
        },
        outputs = {
          ccc.output.hex,
          ccc.output.css_rgb,
          ccc.output.css_hsl,
          ccc.output.css_hwb,
          ccc.output.css_lab,
          ccc.output.css_lch,
          ccc.output.css_oklab,
          ccc.output.css_oklch,
        },
        convert = {
          { ccc.picker.hex, ccc.output.css_hsl },
          { ccc.picker.css_rgb, ccc.output.css_hsl },
          { ccc.picker.css_hsl, ccc.output.hex },
        },
      })
    end,
  },

  -- Auto-close and auto-rename HTML tags
  {
    "windwp/nvim-ts-autotag",
    dependencies = "nvim-treesitter/nvim-treesitter",
    ft = { "html", "javascript", "typescript", "javascriptreact", "typescriptreact", "vue", "svelte" },
    config = true,
  },

  -- Formatters for HTML/CSS
  {
    "stevearc/conform.nvim",
    opts_extend = {
      "formatters_by_ft.html",
      "formatters_by_ft.css",
      "formatters_by_ft.scss",
      "formatters_by_ft.less",
      "formatters_by_ft.postcss",
    },
    opts = {
      formatters_by_ft = {
        html = { "prettierd", "prettier", stop_after_first = true },
        css = { "prettierd", "prettier", stop_after_first = true },
        scss = { "prettierd", "prettier", stop_after_first = true },
        less = { "prettierd", "prettier", stop_after_first = true },
        postcss = { "prettierd", "prettier", stop_after_first = true },
      },
    },
  },

  -- Linting for HTML/CSS
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        html = { "htmlhint" },
        css = { "stylelint" },
        scss = { "stylelint" },
        less = { "stylelint" },
        postcss = { "stylelint" },
      },
    },
  },

  -- Live server for HTML development
  {
    "barrett-ruth/live-server.nvim",
    cmd = { "LiveServerStart", "LiveServerStop" },
    keys = {
      { prefix .. "l", "<cmd>LiveServerToggle<cr>", desc = "Toggle Live Server" },
    },
    build = "npm add -g live-server",
    config = true,
  },

  -- HTML tag matching
  {
    "andymass/vim-matchup",
    event = "BufReadPost",
    ft = { "html", "javascript", "typescript", "javascriptreact", "typescriptreact", "vue", "svelte" },
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
      vim.g.matchup_matchparen_deferred = 1
    end,
  },

  -- CSS/SCSS snippets and completion
  {
    "razak17/tailwind-fold.nvim",
    ft = { "html", "javascript", "typescript", "javascriptreact", "typescriptreact", "vue", "svelte" },
    opts = {
      min_chars = 50, -- minimum characters to fold
      symbol = "󱏿", -- fold symbol
    },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
}
