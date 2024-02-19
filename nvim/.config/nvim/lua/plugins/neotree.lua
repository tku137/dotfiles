return {
  "nvim-neo-tree/neo-tree.nvim",
  lazy = false,
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
    -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
  },
  keys = {
    -- Toggle Neo-tree on or off
    {
      "<leader>e",
      function()
        require("neo-tree.command").execute({
          toggle = true
        })
      end,
      desc = "Toggle NeoTree",
    },
    {
      "<leader>E",
      function()
        require("neo-tree.command").execute({
          action = "focus",
          reveal = true
        })
      end,
      desc = "Toggle NeoTree",
    },
    -- { "<leader>e",  ":Neotree toggle<cr>", desc = "Toggle Neo-tree" },

    -- Additional key mappings can be placed here
    -- Example: Open Neo-tree focused on the current file
    -- { "<leader>ef", ":Neotree reveal<cr>", desc = "Reveal current file in Neo-tree" },

    -- Feel free to add more keybindings as per your requirement
  },
}
