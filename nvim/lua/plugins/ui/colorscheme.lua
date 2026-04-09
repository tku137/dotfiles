return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      flavour = "macchiato",
      integrations = {
        aerial = true,
        blink_cmp = { style = "bordered" },
        dap = true,
        dap_ui = true,
        dadbod_ui = true,
        flash = true,
        gitsigns = true,
        grug_far = true,
        lsp_trouble = true,
        mini = { enabled = true },
        neogit = true,
        neotest = true,
        noice = true,
        render_markdown = true,
        snacks = { enabled = true },
        telescope = { enabled = true },
        treesitter = true,
        treesitter_context = true,
        which_key = true,
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin-macchiato")
    end,
  },
}
