return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- Extensions should go into their own plugin spec!
    },
    keys = {
      -- Define key mappings
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
      -- Add more Telescope-related key mappings here if needed
    },
    config = function()
      require("telescope").setup({
        -- Main Telescope configuration settings
      })
    end,
  },
}
