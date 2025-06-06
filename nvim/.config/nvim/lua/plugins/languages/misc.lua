return {

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "rst",
        "query",
        "regex",
        "vim",
        "vimdoc",
        "kdl",
        "ssh_config",
      },
    },
  },
}
