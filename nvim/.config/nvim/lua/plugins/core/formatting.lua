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
  opts_extend = { "formatters_by_ft" },
  opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
      -- Skip entirely when the user disabled it (see config/keymaps.lua)
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end

      -- Disable "format_on_save lsp_fallback" for languages that don't
      -- have a well standardized coding style. You can add additional
      -- languages here or re-enable it for the disabled ones.
      local disable_filetypes = { c = true, cpp = true }
      if disable_filetypes[vim.bo[bufnr].filetype] then
        return nil
      else
        return {
          timeout_ms = 3000,
          lsp_format = "fallback",
        }
      end
    end,
    formatters_by_ft = {
      -- TODO: Add this to readme
      -- INFO: To add language specific formatters in their own config file, use this snippet:
      -- Important to set opts_extended so lazy.nvim merges the nested formatters_by_ft correctly!
      -- {
      --   "stevearc/conform.nvim",
      --   opts_extend = { "formatters_by_ft.python" }, -- important to convince lazy.nvim to merge this!
      --   opts = { formatters_by_ft = { python = { "ruff_organize_imports", "ruff_format" } } },
      -- },
    },
  },
}
