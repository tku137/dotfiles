return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>cf",
      function()
        require("conform").format({ async = true, lsp_format = "fallback" })
      end,
      mode = "",
      desc = "Format buffer",
    },
  },
  opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
      -- Disable "format_on_save lsp_fallback" for languages that don't
      -- have a well standardized coding style. You can add additional
      -- languages here or re-enable it for the disabled ones.
      local disable_filetypes = { c = true, cpp = true }
      if disable_filetypes[vim.bo[bufnr].filetype] then
        return nil
      else
        return {
          timeout_ms = 500,
          lsp_format = "fallback",
        }
      end
    end,
    formatters_by_ft = {
      lua = { "stylua" },
      -- TODO: Add this to readme
      -- To add language specific formatters in their own config file, use this snippet:
      -- {
      --   "stevearc/conform.nvim",
      --   after = "conform.nvim",
      --   opts = function(_, opts)
      --     opts.formatters_by_ft = opts.formatters_by_ft or {}
      --     opts.formatters_by_ft.python = { "ruff_organize_imports", "ruff_format" }
      --     return opts
      --   end,
      -- },
    },
  },
}
