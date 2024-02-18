return {
  "nvim-telescope/telescope-ui-select.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    require("telescope").setup{
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown {
            -- Custom dropdown theme options here
          }
        }
      }
    }
    require("telescope").load_extension("ui-select")
  end,
}

