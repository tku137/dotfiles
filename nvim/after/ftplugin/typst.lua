vim.opt_local.expandtab = true
vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2

local function typst_compile()
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    vim.notify("Typst: buffer has no file", vim.log.levels.WARN)
    return
  end

  local efm = "%f:%l:%c: %t%*[^:]: %m"

  vim.notify("Typst: compiling…", vim.log.levels.INFO)

  vim.system(
    { "typst", "compile", "--diagnostic-format", "short", file },
    { text = true },
    vim.schedule_wrap(function(obj)
      local output = (obj.stderr or "") .. (obj.stdout or "")
      local lines = vim.split(output, "\n", { trimempty = true })

      if obj.code == 0 and #lines == 0 then
        vim.fn.setqflist({}, "r")
        vim.notify("Typst: compiled " .. vim.fn.fnamemodify(file, ":t:r") .. ".pdf")
        return
      end

      vim.fn.setqflist({}, " ", {
        title = "typst compile",
        lines = lines,
        efm = efm,
      })

      local ok, trouble = pcall(require, "trouble")
      if ok then
        trouble.open({ mode = "quickfix", focus = false })
      else
        vim.cmd("cwindow")
      end

      if obj.code ~= 0 then
        vim.notify("Typst: compile failed", vim.log.levels.ERROR)
      else
        vim.notify("Typst: compiled with warnings", vim.log.levels.WARN)
      end
    end)
  )
end

vim.keymap.set("n", "<localleader>c", typst_compile, { buffer = true, desc = "Compile Document" })

vim.keymap.set("n", "<localleader>o", function()
  local pdf = vim.fn.expand("%:p:r") .. ".pdf"
  if vim.fn.filereadable(pdf) == 0 then
    vim.notify("Typst: no PDF found at " .. pdf .. " (compile first)", vim.log.levels.WARN)
    return
  end
  vim.ui.open(pdf)
end, { buffer = true, desc = "Open PDF" })

local ok, wk = pcall(require, "which-key")
if ok then
  wk.add({
    { "<localleader>", group = "Typst", buffer = 0 },
  })
end
