return {
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "markdown",
        "markdown_inline",
      },
    },
  },

  -- LSP
  -- brew install marksman
  {
    "neovim/nvim-lspconfig",
    opts = { servers = { "marksman" } },
  },

  -- Formatter
  -- brew install prettier prettierd
  {
    "stevearc/conform.nvim",
    opts_extend = { "formatters_by_ft.markdown" }, -- important to convince lazy.nvim to merge this!
    opts = { formatters_by_ft = {
      markdown = { "prettierd", "prettier", stop_after_first = true },
    } },
  },

  -- Other plugins
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      code = {
        sign = false,
        width = "block",
        right_pad = 1,
      },
      heading = {
        sign = false,
        icons = {},
      },
      checkbox = {
        enabled = false,
      },
    },
    ft = { "markdown", "norg", "rmd", "org", "codecompanion" },
    config = function(_, opts)
      require("render-markdown").setup(opts)
      Snacks.toggle({
        name = "Render Markdown",
        get = function()
          return require("render-markdown.state").enabled
        end,
        set = function(enabled)
          local m = require("render-markdown")
          if enabled then
            m.enable()
          else
            m.disable()
          end
        end,
      }):map("<leader>um")
    end,
  },
}
