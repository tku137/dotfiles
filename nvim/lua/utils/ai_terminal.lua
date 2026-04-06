--- AI CLI Terminal Integration
---
--- Provides a snacks picker to launch AI CLI tools (Opencode, Claude Code, etc.)
--- in toggleterm vertical splits, and a function to send file references
--- (path or path:line-range) to the active AI terminal.
---
--- @module 'utils.ai_terminal'

local M = {}

local helpers = require("utils.helpers")
local Snacks = require("snacks")

--- @class AiCli
--- @field name string Display name
--- @field cmd string Executable command
--- @field icon string Nerd Font icon

--- @type AiCli[]
local clis = {
  { name = "Opencode", cmd = "opencode", icon = "󱨦 " },
  { name = "Claude Code", cmd = "claude", icon = " " },
  { name = "Copilot", cmd = "copilot", icon = " " },
}

--- Toggleterm count offset for AI terminals (121, 122, …)
local COUNT_BASE = 121

--- @type table<string, any> cmd -> Terminal instance
local terminals = {}

--- @type any|nil Currently active AI terminal
local active_term = nil

--- Open a snacks picker to select an AI CLI tool, then launch it in a vertical split.
function M.pick()
  local available = {}
  for i, cli in ipairs(clis) do
    if vim.fn.executable(cli.cmd) == 1 then
      table.insert(available, {
        text = cli.icon .. "  " .. cli.name,
        cmd = cli.cmd,
        idx = i,
      })
    end
  end

  if #available == 0 then
    vim.notify("No AI CLI tools found on PATH", vim.log.levels.WARN)
    return
  end

  Snacks.picker({
    title = "AI Assistant",
    items = available,
    format = function(item)
      return { { item.text } }
    end,
    confirm = function(picker, item)
      picker:close()
      if item then
        M._open(item.cmd, item.idx)
      end
    end,
  })
end

--- Open or toggle a specific AI CLI terminal.
--- @param cmd string CLI command
--- @param idx integer Index in the clis table (used for toggleterm count)
function M._open(cmd, idx)
  local Terminal = require("toggleterm.terminal").Terminal

  if not terminals[cmd] then
    terminals[cmd] = Terminal:new({
      count = COUNT_BASE + idx,
      cmd = cmd,
      dir = helpers.project_root_path(),
      direction = "vertical",
      hidden = true,
      close_on_exit = false,
    })
  end

  active_term = terminals[cmd]
  active_term:toggle()
end

--- Toggle the last-opened AI terminal without showing the picker.
function M.toggle()
  if active_term then
    active_term:toggle()
  else
    vim.notify("No AI terminal has been opened yet. Use the picker first.", vim.log.levels.INFO)
  end
end

--- Build a file reference for the current buffer and send it to the active AI terminal.
--- Normal mode: sends relative file path.
--- Visual mode: sends relative file path with line range (path:startline-endline).
function M.send_file_ref()
  if not active_term then
    vim.notify("No active AI terminal. Open one first.", vim.log.levels.WARN)
    return
  end

  if not active_term:is_open() then
    vim.notify("AI terminal is not visible. Toggle it first.", vim.log.levels.WARN)
    return
  end

  local bufpath = vim.api.nvim_buf_get_name(0)
  if bufpath == "" then
    vim.notify("Current buffer has no file path", vim.log.levels.WARN)
    return
  end

  -- Make path relative to project root
  local root = helpers.project_root_path()
  local ref = vim.fn.fnamemodify(bufpath, ":.")
  -- If fnamemodify didn't make it relative, try stripping project root
  if vim.startswith(ref, "/") and root and vim.startswith(bufpath, root) then
    ref = bufpath:sub(#root + 2) -- +2 to skip the trailing slash
  end

  -- Append line range only when invoked from visual mode
  local mode = vim.fn.mode()
  if mode == "v" or mode == "V" or mode == "\22" then
    -- Exit visual mode to populate '< and '> marks without side effects
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)

    local start_line = vim.fn.line("'<")
    local end_line = vim.fn.line("'>")

    if start_line > 0 and end_line > 0 and start_line ~= end_line then
      ref = ref .. ":" .. start_line .. "-" .. end_line
    elseif start_line > 0 and end_line > 0 then
      ref = ref .. ":" .. start_line
    end
  end

  -- Send ref to the terminal prompt without a trailing newline,
  -- so the user can review/edit before pressing Enter.
  active_term:send(ref, false)
end

return M
