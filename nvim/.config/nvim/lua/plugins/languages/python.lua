local prefix = "<Leader>cI"

return {

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "python" } },
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    opts = { servers = { "ruff", "basedpyright" } },
  },

  -- Formatter
  {
    "stevearc/conform.nvim",
    opts = { formatters_by_ft = { python = { "ruff_organize_imports", "ruff_format" } } },
  },

  -- Linter
  {
    "mfussenegger/nvim-lint",
    opts = { linters_by_ft = { python = { "ruff" } } },
  },

  -- DAP
  {
    -- Python DAP support via debugpy
    "mfussenegger/nvim-dap-python",
    -- Only activate in Python files
    ft = "python",
    -- Keys for debugging tests (uses built-in methods)
    keys = {
      {
        "<leader>dPt",
        function()
          require("dap-python").test_method()
        end,
        desc = "DAP: Debug Method",
        ft = "python",
      },
      {
        "<leader>dPc",
        function()
          require("dap-python").test_class()
        end,
        desc = "DAP: Debug Class",
        ft = "python",
      },
    },
    config = function()
      -- Use the 'uv' strategy to auto-detect your debugpy interpreter
      require("dap-python").setup("uv")
    end,
  },

  -- Test
  {
    "nvim-neotest/neotest",
    dependencies = {
      { "nvim-neotest/neotest-python", config = function() end },
    },
    opts = {
      adapters = {
        ["neotest-python"] = {
          -- Here you can specify the settings for the adapter, i.e.
          -- runner = "pytest",
          -- python = ".venv/bin/python",
        },
      },
    },
  },

  -- Other plugins
  {
    "geg2102/nvim-python-repl",
    lazy = true,
    ft = "python",
    dependencies = {
      "nvim-treesitter",
    },
    keys = {
      -- Normal mode keymaps
      {
        prefix,
        "",
        desc = "iPython Terminal",
      },
      {
        prefix .. "r",
        function()
          require("nvim-python-repl").send_statement_definition()
        end,
        desc = "Send to ipython terminal",
        mode = "n",
      },
      {
        "<Leader>r",
        function()
          require("nvim-python-repl").send_statement_definition()
        end,
        desc = "Send to ipython terminal",
        mode = "n",
      },
      {
        prefix .. "b",
        function()
          require("nvim-python-repl").send_buffer_to_repl()
        end,
        desc = "Send entire buffer to REPL",
        mode = "n",
      },
      {
        prefix .. "E",
        function()
          require("nvim-python-repl").toggle_execute()
          vim.notify(
            "Automatic REPL execution "
            .. (require("nvim-python-repl.config").defaults["execute_on_send"] and "Enabled" or "Disabled")
          )
        end,
        desc = "Toggle automatic execution",
        mode = "n",
      },
      {
        prefix .. "V",
        function()
          require("nvim-python-repl").toggle_vertical()
          vim.notify(
            "REPL split set to "
            .. (require("nvim-python-repl.config").defaults["vsplit"] and "Vertical" or "Horizontal")
          )
        end,
        desc = "Toggle vertical/horizontal split",
        mode = "n",
      },
      -- Visual mode keymaps
      {
        "<Leader>r",
        function()
          require("nvim-python-repl").send_visual_to_repl()
        end,
        desc = "Send to ipython terminal",
        mode = "v",
      },
    },
    ft = { "python", "lua", "scala" },
    config = function()
      require("nvim-python-repl").setup({
        execute_on_send = true,
        vsplit = true,
        spawn_command = {
          python = "ipython",
          scala = "sbt console",
          lua = "ilua",
        },
      })
    end,
  },
}
