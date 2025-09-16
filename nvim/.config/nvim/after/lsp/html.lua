-- HTML Language Server configuration
-- Place this file in: after/lsp/html.lua

return {
  settings = {
    html = {
      format = {
        enable = false, -- Let Prettier handle formatting
      },
      hover = {
        documentation = true,
        references = true,
      },
      completion = {
        attributeDefaultValue = "doublequotes",
      },
      validate = {
        scripts = true,
        styles = true,
      },
      autoClosingTags = true,
      suggest = {
        html5 = true,
      },
    },
  },

  init_options = {
    provideFormatter = false, -- Disable built-in formatter
    embeddedLanguages = {
      css = true,
      javascript = true,
    },
    configurationSection = { "html", "css", "javascript" },
  },

  on_attach = function(client, bufnr)
    -- Disable semantic tokens if they interfere with syntax highlighting
    if client.server_capabilities.semanticTokensProvider then
      client.server_capabilities.semanticTokensProvider = nil
    end

    -- HTML-specific keymaps
    local opts = { buffer = bufnr, silent = true }

    -- Jump between opening and closing tags
    vim.keymap.set("n", "<leader>ht", function()
      vim.cmd("normal! vat")
    end, vim.tbl_extend("force", opts, { desc = "Select HTML tag" }))

    -- Wrap in HTML tag
    vim.keymap.set("v", "<leader>hw", function()
      local tag = vim.fn.input("Tag name: ")
      if tag ~= "" then
        vim.cmd("'<,'>s/\\%V.*\\%V/<" .. tag .. ">\\0<\\/" .. tag .. ">/")
      end
    end, vim.tbl_extend("force", opts, { desc = "Wrap in HTML tag" }))
  end,
}
