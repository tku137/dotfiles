-- Add a keymap to toggle yamlls using schemastore or not
-- Deferred to VeryLazy because Snacks is not available at spec-parse time
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  once = true,
  callback = function()
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
  end,
})

return {

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "yaml" } },
  },

  -- LSP
  -- brew install yaml-language-server
  -- OR
  -- mise use -g npm:yaml-language-server@latest
  {
    "neovim/nvim-lspconfig",
    opts = { servers = { "yamlls" } },
  },
}
