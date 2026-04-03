return {

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "typst" } },
  },

  -- LSP
  -- brew install tinymist
  -- OR
  -- mise use -g aqua:Myriad-Dreamin/tinymist@latest
  {
    "neovim/nvim-lspconfig",
    opts = { servers = { "tinymist" } },
  },

  -- Formatter
  -- brew install typstyle
  -- OR
  -- mise use -g aqua:Enter-tainer/typstyle@latest
  {
    "stevearc/conform.nvim",
    opts = {
      opts_extend = { "formatters_by_ft.typst" }, -- important to convince lazy.nvim to merge this!
      formatters_by_ft = {
        typst = { "typstyle", lsp_format = "prefer" },
      },
    },
  },

  -- Other plugins
  {
    "kaarmu/typst.vim",
    ft = { "typst" },
    keys = {
      {
        "<localleader>c",
        ft = "typst",
        "<cmd>make<cr>",
        desc = "Compile Document",
      },
      {
        "<localleader>w",
        ft = "typst",
        "<cmd>TypstWatch<cr>",
        desc = "Typst Watch",
      },
    },
  },
  {
    "chomosuke/typst-preview.nvim",
    cmd = { "TypstPreview", "TypstPreviewToggle", "TypstPreviewUpdate" },
    keys = {
      {
        "<localleader>p",
        ft = "typst",
        "<cmd>TypstPreview<cr>",
        desc = "Typst Preview",
      },
      {
        "<localleader>P",
        ft = "typst",
        "<cmd>TypstPreviewToggle<cr>",
        desc = "Toggle Typst Preview",
      },
    },
    opts = {
      dependencies_bin = {
        tinymist = "tinymist",
      },
    },
  },
}
