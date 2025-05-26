return {
  {
    "stevearc/aerial.nvim",
    lazy = true,
    event = { "BufReadPost", "BufNewFile", "BufWritePost" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      attach_mode = "global",
      backends = { "lsp", "treesitter", "markdown", "man" },
      layout = {
        default_direction = "prefer_right", -- open at right; left if not enough room
        min_width = 28,
        resize_to_content = false,
      },
      show_guides = true, -- thin ASCII tree lines
      highlight_on_jump = 300, -- flash symbol under cursor (ms)
      icons = require("config.icons").kinds,
    },
    keys = {
      { "<leader>cs", "<cmd>AerialToggle!<cr>", desc = "Symbols (Aerial)" },
    },
  },
}
