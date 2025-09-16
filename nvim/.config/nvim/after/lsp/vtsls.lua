-- vtsls server configuration (modern per-server file)
-- Mirrors Astro community settings and adds a small on_attach for keys/hints.

return {
  -- Keymaps & behavior only when vtsls is the attached client
  on_attach = function(client, bufnr)
    if client.name ~= "vtsls" then
      return
    end

    -- Enable inlay hints by default for TS/JS buffers
    if vim.lsp.inlay_hint then
      pcall(vim.lsp.inlay_hint.enable, true, { bufnr = bufnr })
    end

    -- gs => goto source definition (vtsls)
    local ok, vts = pcall(require, "vtsls")
    if ok and vts.commands and vts.commands.goto_source_definition then
      vim.keymap.set(
        "n",
        "gs",
        vts.commands.goto_source_definition,
        { buffer = bufnr, desc = "Goto Source Definition (vtsls)" }
      )
    end
  end,

  settings = {
    -- vtsls extras
    vtsls = {
      enableMoveToFileCodeAction = true,
      autoUseWorkspaceTsdk = true, -- prefer workspace's TS if available
      experimental = {
        completion = {
          enableServerSideFuzzyMatch = true,
        },
      },
    },

    -- TypeScript language settings
    typescript = {
      updateImportsOnFileMove = { enabled = "always" },
      suggest = {
        completeFunctionCalls = true,
      },
      preferences = {
        includePackageJsonAutoImports = "auto",
        importModuleSpecifier = "shortest",
        includeCompletionsForImportStatements = true,
      },
      inlayHints = {
        enumMemberValues = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        parameterNames = { enabled = "all" },
        parameterTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        variableTypes = { enabled = true }, -- Can be overwhelming, disable if desired
      },
      format = {
        enable = false, -- Let Prettier handle formatting
      },
    },

    -- JavaScript language settings
    javascript = {
      updateImportsOnFileMove = { enabled = "always" },
      suggest = {
        completeFunctionCalls = true,
      },
      preferences = {
        includePackageJsonAutoImports = "auto",
        importModuleSpecifier = "shortest",
        includeCompletionsForImportStatements = true,
      },
      inlayHints = {
        enumMemberValues = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        parameterNames = { enabled = "literals" }, -- Less verbose for JS
        parameterTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        variableTypes = { enabled = true },
      },
      format = {
        enable = false, -- Let Prettier handle formatting
      },
    },
  },
}
