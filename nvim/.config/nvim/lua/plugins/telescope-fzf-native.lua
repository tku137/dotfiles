return {
  "nvim-telescope/telescope-fzf-native.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  build = "make",  -- Required build step as specified in the plugin's documentation
  config = function()
    require('telescope').load_extension('fzf')
    -- If there were specific configurations or additional setup needed for fzf-native, it would go here
  end,
}

