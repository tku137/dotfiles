-- CSS Language Server configuration
-- Place this file in: after/lsp/cssls.lua

return {
  settings = {
    css = {
      validate = true,
      lint = {
        unknownAtRules = "ignore", -- Don't warn about Tailwind directives
        unknownProperties = "ignore", -- Don't warn about CSS custom properties
      },
      format = {
        enable = false, -- Let Prettier handle formatting
      },
      hover = {
        documentation = true,
        references = true,
      },
      completion = {
        triggerPropertyValueCompletion = true,
        completePropertyWithSemicolon = true,
      },
    },
    scss = {
      validate = true,
      lint = {
        unknownAtRules = "ignore",
        unknownProperties = "ignore",
      },
      format = {
        enable = false, -- Let Prettier handle formatting
      },
      hover = {
        documentation = true,
        references = true,
      },
      completion = {
        triggerPropertyValueCompletion = true,
        completePropertyWithSemicolon = true,
      },
    },
    less = {
      validate = true,
      lint = {
        unknownAtRules = "ignore",
        unknownProperties = "ignore",
      },
      format = {
        enable = false, -- Let Prettier handle formatting
      },
      hover = {
        documentation = true,
        references = true,
      },
      completion = {
        triggerPropertyValueCompletion = true,
        completePropertyWithSemicolon = true,
      },
    },
  },

  init_options = {
    provideFormatter = false, -- Disable built-in formatter
  },

  on_attach = function(client, bufnr)
    -- Disable semantic tokens if they interfere with syntax highlighting
    if client.server_capabilities.semanticTokensProvider then
      client.server_capabilities.semanticTokensProvider = nil
    end

    -- CSS-specific keymaps
    local opts = { buffer = bufnr, silent = true }

    -- Sort CSS properties
    vim.keymap.set("v", "<leader>cs", function()
      vim.cmd("'<,'>sort")
    end, vim.tbl_extend("force", opts, { desc = "Sort CSS properties" }))
  end,
}
