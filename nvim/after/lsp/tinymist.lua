-- Adds keymaps to pin/unpin the main file for compilation
return {
  on_attach = function(client, bufnr)
    vim.keymap.set("n", "<localleader>m", function()
      client:exec_cmd({
        title = "pin",
        command = "tinymist.pinMain",
        arguments = { vim.api.nvim_buf_get_name(bufnr) },
      })
    end, { buffer = bufnr, desc = "Pin Main" })

    vim.keymap.set("n", "<localleader>M", function()
      client:exec_cmd({
        title = "unpin",
        command = "tinymist.pinMain",
        arguments = { vim.NIL },
      })
    end, { buffer = bufnr, desc = "Un-pin main" })
  end,
}
