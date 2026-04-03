return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    opts_extend = { "linters_by_ft" },
    config = function()
      local lint = require("lint")

      -- No global, default nvim-lint linters_by_ft; languages configure themselves via opts
      lint.linters_by_ft = {}

      -- TODO: add this to readme
      -- INFO: To add language specific linters in their own config file, use this snippet:
      -- {
      --   "mfussenegger/nvim-lint",
      --   opts_extend = { "linters_by_ft.python" }, -- important to convince lazy.nvim to merge this!
      --   opts = { linters_by_ft = { python = { "ruff" } } },
      -- },

      -- Create autocommand which carries out the actual linting
      -- on the specified events.
      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          -- Only run the linter in buffers that you can modify in order to
          -- avoid superfluous noise, notably within the handy LSP pop-ups that
          -- describe the hovered symbol using Markdown.
          if vim.bo.modifiable then
            lint.try_lint()
          end
        end,
      })
    end,
  },
}
