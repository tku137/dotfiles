return {
  "debugloop/telescope-undo.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  keys = {
    {"<leader>fu", "<cmd>Telescope undo<cr>", desc = "Undo history"}
  },
  config = function()
    require("telescope").load_extension("undo")
    -- Extension-specific configuration (if any) goes here
  end,
}

