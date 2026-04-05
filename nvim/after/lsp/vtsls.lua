-- after/lsp/vtsls.lua (some minimal niceties)
return {
  on_attach = function(client, bufnr)
    local ok, vts = pcall(require, "vtsls")
    if ok and vts.commands and vts.commands.goto_source_definition then
      vim.keymap.set("n", "gs", vts.commands.goto_source_definition, { buffer = bufnr, desc = "Vtsls: Source def" })
    end
  end,
}
