--- DAP Breakpoints Picker Utilities
---
--- This module provides a Snacks picker integration for nvim-dap breakpoints.
--- It collects all breakpoints across buffers and exposes a single picker
--- that lets you:
--- - list all DAP breakpoints
--- - preview the corresponding file + line
--- - jump to a breakpoint on confirm
--- - delete a breakpoint from within the picker
---
--- Intended usage:
---   local dap_utils = require("utils.dap_utils")
---   dap_utils.dap_breakpoints_picker()
---
--- Notes:
--- - This module expects `Snacks` to be available (global or required elsewhere).
--- - Breakpoints are obtained from `dap.breakpoints.get()` and are mapped into
---   the item shape Snacks expects.
---
--- @module 'utils.dap_utils'

---@class DapBreakpoint
---@field line integer
---@field condition? string
---@field logMessage? string
---@field hitCondition? string

---@class DapBreakpointItem
---@field text string        Display text shown in the picker
---@field file string        Absolute file path
---@field lnum integer       1-based line number of the breakpoint
---@field bufnr integer      Buffer number the breakpoint belongs to

---@class DapBreakpointsPicker
---@field dap_breakpoints_picker fun(): nil Open Snacks picker for DAP breakpoints
local M = {} ---@type DapBreakpointsPicker

---@type any
local dap_bps = require("dap.breakpoints")

-- helper: resolve full path of a buffer
---@param bufnr integer
---@return string
local function path(bufnr)
  return vim.api.nvim_buf_get_name(bufnr)
end

--- Collect all breakpoints into the shape Snacks wants.
--- `dap_bps.get()` returns a table keyed by bufnr.
--- @return DapBreakpointItem[]
local function list_breakpoints()
  ---@type DapBreakpointItem[]
  local items = {}

  ---@type table<integer, DapBreakpoint[]>
  local all = dap_bps.get()

  for bufnr, bps in pairs(all) do
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

--- Open a Snacks picker listing all current DAP breakpoints.
--- @return nil
function M.dap_breakpoints_picker()
  ---@diagnostic disable-next-line: undefined-global
  Snacks.picker({
    title = "DAP Breakpoints",
    items = list_breakpoints(),

    -- custom previewer
    ---@param ctx table
    preview = function(ctx)
      ---@type DapBreakpointItem
      local item = ctx.item
      local preview = ctx.preview

      local file, lnum = item.file, item.lnum

      -- 1. read the file once and cache it in the preview buffer
      -- preview.state is a userland scratch table owned by Snacks.
      preview.state = preview.state or {}

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

    ---@param picker table
    ---@param item DapBreakpointItem
    confirm = function(picker, item)
      picker:close()
      vim.cmd.edit(item.file)
      vim.api.nvim_win_set_cursor(0, { item.lnum, 0 })
    end,

    keys = {
      d = {
        ---@param item DapBreakpointItem
        ---@param picker table
        function(item, picker)
          dap_bps.toggle(item.bufnr, item.lnum)
          picker:list():remove(item)
        end,
        desc = "delete breakpoint",
      },
    },
  })

  return nil
end

return M
