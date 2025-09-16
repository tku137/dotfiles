-- after/lsp/vtsls.lua (some minimal niceties)
return {
  on_attach = function(client, bufnr)
    if client.name ~= "vtsls" then
      return
    end
    if vim.lsp.inlay_hint then
      pcall(vim.lsp.inlay_hint.enable, true, { bufnr = bufnr })
    end
    local ok, vts = pcall(require, "vtsls")
    if ok and vts.commands and vts.commands.goto_source_definition then
      vim.keymap.set("n", "gs", vts.commands.goto_source_definition, { buffer = bufnr, desc = "Vtsls: Source def" })
    end
  end,
}
