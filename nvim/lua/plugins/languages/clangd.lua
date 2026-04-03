return {

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "c", "cpp", "objc", "cuda", "proto", "printf" } },
  },

  -- LSP
  -- brew install llvm
  -- OR
  -- mise use -g clang@latest
  {
    "neovim/nvim-lspconfig",
    opts = { servers = { "clangd" } },
    keys = {
      {
        "<leader>ch",
        "<cmd>LspClangdSwitchSourceHeader<cr>",
        desc = "Switch Source/Header (C/C++)",
        ft = { "c", "cpp", "objc", "cuda" },
      },
      {
        "<leader>ck",
        "<cmd>LspClangdShowSymbolInfo<cr>",
        desc = "Show Symbol Info (C/C++)",
        ft = { "c", "cpp", "objc", "cuda" },
      },
    },
  },

  -- DAP
  -- brew install llvm
  -- OR
  -- mise use -g clang@latest
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    opts = function()
      local dap = require("dap")

      -- Declare the LLDB adapter (only once)
      if not dap.adapters["lldb"] then
        dap.adapters.lldb = {
          type = "executable",
          -- prefer Xcode; fall back to Home-brew:
          command = vim.fn.exepath("lldb-dap") ~= "" and "lldb-dap"
            or "/Applications/Xcode.app/Contents/Developer/usr/bin/lldb-dap",
          name = "lldb",
        }
      end

      -- Per-language launch/attach configurations
      for _, lang in ipairs({ "c", "cpp", "objc", "cuda" }) do
        dap.configurations[lang] = {
          {
            type = "lldb",
            request = "launch",
            name = "Launch file",
            program = function()
              return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
            end,
            cwd = "${workspaceFolder}",
            stopOnEntry = false,
            args = {},
            --   runInTerminal = false,  -- enable if you need an external pty
          },
          {
            type = "lldb",
            request = "attach",
            name = "Attach to process",
            pid = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
          },
        }
      end
    end,
  },

  -- Other plugins
  {
    "p00f/clangd_extensions.nvim",
    lazy = true,
    config = function() end,
    opts = {
      inlay_hints = {
        inline = false,
      },
      ast = {
        --These require codicons (https://github.com/microsoft/vscode-codicons)
        role_icons = require("config.icons").roles,
        kind_icons = require("config.icons").kinds,
      },
    },
    keys = {
      {
        "<leader>ct",
        "<cmd>ClangdAST<cr>",
        desc = "View AST (C/C++)",
        ft = { "c", "cpp", "objc", "cuda" },
      },
      {
        "<leader>cT",
        "<cmd>ClangdTypeHierarchy<cr>",
        desc = "Type Hierarchy (C/C++)",
        ft = { "c", "cpp", "objc", "cuda" },
      },
      {
        "<leader>cm",
        "<cmd>ClangdMemoryUsage<cr>",
        desc = "Memory Usage (C/C++)",
        ft = { "c", "cpp", "objc", "cuda" },
      },
    },
  },
}
