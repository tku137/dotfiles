return {
  {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "macchiato", -- latte, frappe, macchiato, mocha
        background = { -- :h background
          light = "latte",
          dark = "macchiato",
        },
        transparent_background = false, -- disables setting the background color.
        dim_inactive = {
          enabled = true, -- dims the background color of inactive window
          shade = "dark",
          percentage = 0.15, -- percentage of the shade to apply to the inactive window
        },
        integrations = {
          cmp = true,
          gitsigns = true,
          treesitter = true,
          notify = true,
          aerial = true,
          alpha = true,
          flash = true,
          mason = true,
          neotree = true,
          neogit = true,
          neotest = true,
          noice = true,
          dap = true,
          dap_ui = true,
          ufo = true,
          rainbow_delimiters = true,
          telescope = {
            enabled = true,
          },
          lsp_trouble = true,
          which_key = true,
          -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
        },
      })

      -- setup must be called before loading
      vim.cmd.colorscheme("catppuccin-macchiato")
    end
  }
}
