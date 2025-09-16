-- Emmet Language Server configuration
-- Place this file in: after/lsp/emmet_ls.lua

return {
  filetypes = {
    "html",
    "css",
    "scss",
    "less",
    "postcss",
    "javascript",
    "typescript",
    "javascriptreact",
    "typescriptreact",
    "vue",
    "svelte",
  },

  settings = {
    emmet = {
      includeLanguages = {
        javascript = "jsx",
        typescript = "tsx",
        ["javascript.jsx"] = "jsx",
        ["typescript.tsx"] = "tsx",
      },
      excludeLanguages = {
        "markdown",
      },
      extensionsPath = {},
      preferences = {
        ["output.selfClosingStyle"] = "xml",
        ["output.field"] = function(index, placeholder)
          return placeholder
        end,
      },
      showExpandedAbbreviation = "always",
      showAbbreviationSuggestions = true,
      syntaxProfiles = {
        jsx = {
          self_closing_tag = true,
        },
      },
      variables = {
        lang = "en",
        charset = "UTF-8",
      },
    },
  },

  init_options = {
    html = {
      options = {
        -- Enable custom Emmet snippets
        ["bem.enabled"] = true,
        ["jsx.enabled"] = true,
        ["markup.attributes"] = {
          class = "className",
          ["for"] = "htmlFor",
        },
      },
    },
  },

  on_attach = function(client, bufnr)
    -- Emmet-specific keymaps (let blink.cmp handle completion automatically)
    local opts = { buffer = bufnr, silent = true }

    -- Balance tag (select tag content)
    vim.keymap.set("n", "<leader>eb", function()
      vim.cmd("normal! vat")
    end, vim.tbl_extend("force", opts, { desc = "Balance tag (select content)" }))

    -- Go to matching tag
    vim.keymap.set("n", "<leader>em", function()
      vim.cmd("normal! %")
    end, vim.tbl_extend("force", opts, { desc = "Go to matching tag" }))
  end,
}
