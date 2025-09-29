local prefix = "<Leader>cI"

-- Add a keymap for toggling BasedPyright settings
-- This toggles BasedPyright's typeCheckingMode between "basic" and "recommended"
-- and additionally enables/disables inlay hints
Snacks.toggle
  .new({
    name = "BasedPyright Strict Mode",
    get = function()
      local client = vim.lsp.get_clients({ name = "basedpyright" })[1]
      ---@diagnostic disable-next-line: undefined-field
      return client and client.config.settings.basedpyright.analysis.typeCheckingMode == "recommended"
    end,
    set = function()
      require("utils.lsp_utils").toggle_basedpyright_settings({ silent = true })
    end,
  })
  :map("<leader>cb")

return {

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "python", "requirements" } },
  },

  -- LSP
  -- brew install ruff basedpyright
  -- OR
  -- mise use -g ruff@latest
  -- mise use -g pipx:basedpyright@latest
  {
    "neovim/nvim-lspconfig",
    opts = { servers = { "ruff", "basedpyright" } },
  },

  -- Formatter
  -- mise use -g ruff@latest
  {
    "stevearc/conform.nvim",
    opts_extend = { "formatters_by_ft.python" }, -- important to convince lazy.nvim to merge this!
    opts = { formatters_by_ft = { python = { "ruff_organize_imports", "ruff_format" } } },
  },

  -- DAP
  -- mise use -g pipx:debugpy@latest
  {
    -- Python DAP support via debugpy
    "mfussenegger/nvim-dap-python",
    -- Only activate in Python files
    ft = "python",
    -- Keys for debugging tests (uses built-in methods)
    keys = {
      {
        "<leader>dyt",
        function()
          require("dap-python").test_method()
        end,
        desc = "DAP: Debug Method",
        ft = "python",
      },
      {
        "<leader>dyc",
        function()
          require("dap-python").test_class()
        end,
        desc = "DAP: Debug Class",
        ft = "python",
      },
    },
    config = function()
      -- Use the 'python3' so we always use the current environments debugpy interpreter
      -- be it from the current venv or globally
      require("dap-python").setup("python3")
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
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
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
        vsplit = false,
        split_dit = "right",
        spawn_command = {
          python = "ipython",
          scala = "sbt console",
          lua = "ilua",
        },
      })
    end,
  },
}
