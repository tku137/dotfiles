-- Add a keymap to toggle yamlls using schemastore or not
Snacks.toggle
  .new({
    name = "YAML SchemaStore Toggle",
    get = function()
      local client = vim.lsp.get_clients({ name = "yamlls" })[1]
      ---@diagnostic disable-next-line: undefined-field
      return client and client.config.settings.yaml.schemaStore.enable
    end,
    set = function(_)
      require("utils.lsp_utils").toggle_yaml_schema_store({ silent = true })
    end,
  })
  :map("<leader>uy")

return {

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "yaml" } },
  },

  -- LSP
  -- brew install yaml-language-server
  {
    "neovim/nvim-lspconfig",
    opts = { servers = { "yamlls" } },
  },
}
