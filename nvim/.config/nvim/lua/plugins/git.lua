return {
  -- Neogit plugin configuration
  {
    "TimUntersberger/neogit",
    dependencies = "nvim-lua/plenary.nvim",  -- Neogit requires plenary.nvim
    config = function()
      require('neogit').setup({
        -- Neogit setup options here
        -- For example, to disable the integrated commit popup, you could set
        -- integrations = { diffview = false } assuming you don't have diffview installed
      })
    end,
    keys = {
      -- Keymap to open Neogit
      { "<leader>gg", ":Neogit<CR>", desc = "Open Neogit" },
    },
  },
  
  -- gitsigns.nvim plugin configuration remains the same
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
    keys = {
      -- Keymap for previewing hunk
      { "<leader>gp", ":Gitsigns preview_hunk<CR>", desc = "Preview hunk" },
      -- Keymap for toggling current line blame
      { "<leader>gt", ":Gitsigns toggle_current_line_blame<CR>", desc = "Toggle line blame" },
    },
  },
}

