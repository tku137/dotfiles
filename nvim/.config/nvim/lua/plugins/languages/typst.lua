return {

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "typst" } },
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    opts = { servers = { "tinymist" } },
  },

  -- Formatter
  {
    "stevearc/conform.nvim",
    opts = {
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
