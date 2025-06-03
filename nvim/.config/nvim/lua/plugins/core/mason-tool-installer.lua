return {
  {
    "mason-org/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUpdate" },
    build = ":MasonUpdate", -- sync registry on every :Lazy sync
    opts = {},
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = {
      "mason-org/mason-lspconfig.nvim",
      "jay-babu/mason-nvim-dap.nvim",
    },
  },
}
