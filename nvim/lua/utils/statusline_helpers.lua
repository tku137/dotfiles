--- Statusline Helper Utilities
---
--- This module provides helper functions used by the statusline / lualine
--- configuration. It encapsulates logic for:
--- - LSP status (spinner / attached indicator)
--- - MCPHub status + color
--- - Angular `ng serve` status
--- - Spell-check language display
---
--- Usage:
---   local sl = require("utils.statusline_helpers")
---
---   -- In lualine sections:
---   { sl.simple_lsp_status, ... }
---   { sl.ng_status, ... }
---   { sl.mcphub_status, color = sl.mcphub_color, ... }
---   {
---     function() return icons.statusline.spell .. (sl.spell_status() or "") end,
---     cond = function() return sl.spell_status() ~= nil end,
---   }
---
--- @module 'utils.statusline_helpers'

---@class NgTerm
---@field job_id? integer

---@class StatuslineHelpers
---@field spell_status fun(): string|nil
---@field simple_lsp_status fun(): string
---@field mcphub_status fun(): string
---@field mcphub_color fun(): { fg: string }
---@field ng_status fun(): string
local M = {} ---@type StatuslineHelpers

---@type table<string, string>
local colors = require("tokyonight.colors").setup()

---@type table
local icons = require("config.icons")

local uv = vim.uv or vim.loop

--------------------------------------------------------------------------------
-- Internal helpers
--------------------------------------------------------------------------------

--- Helper to check if an `ng serve` terminal is running.
--- Expects a terminal-like object with a `job_id` field.
--- @param term NgTerm|nil
--- @return boolean
local function ng_running(term)
  if not term or not term.job_id or term.job_id <= 0 then
    return false
  end
  local s = vim.fn.jobwait({ term.job_id }, 0)[1]
  return s == -1 -- still running
end

--------------------------------------------------------------------------------
-- Public API
--------------------------------------------------------------------------------

--- Returns formatted list of spell languages if spell checking is enabled.
--- If spell is off or no language is configured, returns nil.
--- @return string|nil
function M.spell_status()
  if vim.wo.spell then
    local langs = vim.bo.spelllang or ""
    langs = vim.trim(langs)
    if langs ~= "" then
      return langs
    end
  end
  return nil
end

---@type table<string, boolean>
local LSP_IGNORE = {
  copilot = true,
}

--- Returns filtered LSP clients for the current buffer.
--- @param bufnr integer
--- @return table[]
local function active_lsp_clients(bufnr)
  local clients = vim.lsp.get_clients({ bufnr = bufnr }) or {}
  if vim.tbl_isempty(clients) then
    return {}
  end

  local active = {}
  for _, client in ipairs(clients) do
    if not LSP_IGNORE[client.name] then
      active[#active + 1] = client
    end
  end
  return active
end

--- Determines the current LSP “state” for statusline purposes.
--- @param bufnr integer
--- @return '"none"'|'"progress"'|'"ready"'
local function lsp_state(bufnr)
  local active = active_lsp_clients(bufnr)
  if #active == 0 then
    return "none"
  end

  -- Check for LSP progress messages (if supported).
  local ok, util = pcall(require, "vim.lsp.util")
  if ok and util.get_progress_messages then
    local msgs = util.get_progress_messages()
    for _, msg in ipairs(msgs) do
      if msg.name and not LSP_IGNORE[msg.name] then
        return "progress"
      end
    end
  end

  return "ready"
end

--- Minimal LSP indicator:
--- - returns disabled icon if no non-ignored LSP clients are attached
--- - returns a spinner if there are active LSP progress messages
--- - otherwise returns the default LSP icon
---
--- @return string
function M.simple_lsp_status()
  local bufnr = vim.api.nvim_get_current_buf()
  local state = lsp_state(bufnr)

  local disabled_icon = icons.statusline.lsp_disabled
  if state == "none" then
    return disabled_icon
  end

  if state == "progress" then
    local frames = icons.misc.running_animated
    ---@diagnostic disable-next-line: undefined-field
    local idx = (math.floor(uv.now() / 120) % #frames) + 1
    return frames[idx]
  end

  return icons.statusline.lsp
end

--- LSP Color helper.
--- @return { fg: string }
function M.lsp_status_color()
  local bufnr = vim.api.nvim_get_current_buf()
  local state = lsp_state(bufnr)

  if state == "none" then
    return { fg = colors.comment }
  end

  return { fg = colors.fg }
end

--- MCPHub status helper.
--- Uses global variables maintained by mcphub.nvim:
---   - vim.g.loaded_mcphub
---   - vim.g.mcphub_status
---   - vim.g.mcphub_servers_count
---   - vim.g.mcphub_executing
---
--- Documented states commonly used:
---   "starting", "ready", "stopped", "restarting", "restarted"
--- @return string
function M.mcphub_status()
  local icon = icons.statusline.mcphub

  if not vim.g.loaded_mcphub then
    return icon .. " -"
  end

  ---@type string
  local status = vim.g.mcphub_status or "stopped"
  local executing = vim.g.mcphub_executing

  if executing or status == "starting" or status == "restarting" then
    local frames = icons.misc.running_animated
    ---@diagnostic disable-next-line: undefined-field
    local idx = (math.floor(uv.now() / 100) % #frames) + 1
    return icon .. " " .. frames[idx]
  end

  return icon
end

--- Color helper for MCPHub status component.
--- - gray when not loaded
--- - fg when ready / restarted
--- - orange when starting / restarting
--- - red when error / stopped / unknown
---
--- @return { fg: string }
function M.mcphub_color()
  if not vim.g.loaded_mcphub then
    return { fg = colors.comment }
  end

  ---@type string
  local status = vim.g.mcphub_status or "stopped"

  if status == "ready" or status == "restarted" then
    return { fg = colors.fg }
  elseif status == "starting" or status == "restarting" then
    return { fg = colors.orange }
  else
    return { fg = colors.red }
  end
end

--- Angular `ng serve` status.
--- Checks two global terminals:
---   - _G._NG_SERVE
---   - _G._NG_SERVE_LAN
---
--- If one/both are running, returns something like:
---   "<angular-icon> <localhost-icon> <lan-icon>"
--- Otherwise returns "".
---
--- @return string
function M.ng_status()
  local parts = {}

  ---@type NgTerm|nil
  local ng_local = _G._NG_SERVE
  ---@type NgTerm|nil
  local ng_lan = _G._NG_SERVE_LAN

  if ng_running(ng_local) then
    table.insert(parts, icons.misc.localhost)
  end
  if ng_running(ng_lan) then
    table.insert(parts, icons.misc.lan)
  end
  if #parts == 0 then
    return ""
  end
  return icons.ft.angular .. " " .. table.concat(parts, " ")
end

return M
