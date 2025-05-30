return {

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "fish" } },
  },

  -- Formatter
  -- fish_indent comes with the fish shell :)
  {
    "stevearc/conform.nvim",
    opts_extend = { "formatters_by_ft.fish" }, -- important to convince lazy.nvim to merge this!
    opts = { formatters_by_ft = { fish = { "fish_indent" } } },
  },
}
