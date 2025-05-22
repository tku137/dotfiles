return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")

      -- No global linters_by_ft; languages configure themselves via opts
      lint.linters_by_ft = lint.linters_by_ft or {}

      -- TODO: add this to readme
      -- To add language specific linters in their own config file, use this snippet:
      -- {
      --   "mfussenegger/nvim-lint",
      --   after = "nvim-lint",
      --   opts = function(_, opts)
      --     opts.linters_by_ft = opts.linters_by_ft or {}
      --     opts.linters_by_ft.python = { "ruff" }
      --     return opts
      --   end,
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
