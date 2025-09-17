local M = {}
local dap_bps = require("dap.breakpoints")

-- helper: resolve full path of a buffer
local function path(bufnr)
  return vim.api.nvim_buf_get_name(bufnr)
end

-- collect all breakpoints into the shape Snacks wants
local function list_breakpoints()
  local items = {}
  for bufnr, bps in pairs(dap_bps.get()) do -- dap_bps.get() → { [bufnr] = { bp1, bp2 … } }
    local file = path(bufnr)
    for _, bp in ipairs(bps) do
      table.insert(items, {
        text = ("%s:%d"):format(vim.fn.fnamemodify(file, ":."), bp.line),
        file = file,
        lnum = bp.line,
        bufnr = bufnr,
      })
    end
  end
  return items
end

function M.dap_breakpoints_picker()
  Snacks.picker({
    title = "DAP Breakpoints",
    items = list_breakpoints(),

    -- custom previewer
    preview = function(ctx)
      local file, lnum = ctx.item.file, ctx.item.lnum
      local preview = ctx.preview

      -- 1. read the file once and cache it in the preview buffer
      if preview.state.file ~= file then
        preview.state.file = file -- remember for next run
        preview:reset()
        preview:highlight({ ft = vim.filetype.match({ filename = file }) })
        preview:set_lines(vim.fn.readfile(file))
      end

      -- 2. move the preview cursor and switch on cursorline
      -- unwrap to a raw winid, fall back to current win if nil
      local win = (preview.win and preview.win.win) or vim.api.nvim_get_current_win()
      vim.api.nvim_win_set_cursor(win, { lnum, 0 })
      vim.api.nvim_set_option_value("cursorline", true, { win = win })
    end,

    confirm = function(picker, item)
      picker:close()
      vim.cmd.edit(item.file)
      vim.api.nvim_win_set_cursor(0, { item.lnum, 0 })
    end,

    keys = {
      d = {
        function(item, picker)
          dap_bps.toggle(item.bufnr, item.lnum)
          picker:list():remove(item)
        end,
        desc = "delete breakpoint",
      },
    },
  })
end

return M
