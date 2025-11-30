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
--- @module 'statusline_helpers'

local M = {}

local colors = require("tokyonight.colors").setup()
local icons = require("config.icons")

--------------------------------------------------------------------------------
-- Internal helpers
--------------------------------------------------------------------------------

--- Helper to check if an `ng serve` terminal is running.
--- Expects a terminal-like object with a `job_id` field.
--- @param term table|nil
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

--- Minimal LSP indicator:
--- - returns "" if no non-ignored LSP clients are attached
--- - returns a spinner if there are active LSP progress messages
--- - otherwise returns the default LSP icon
---
--- This is a workaround for the default lualine `lsp_status` component,
--- which does not reliably show an icon when multiple LSPs are attached.
---
--- @return string
function M.simple_lsp_status()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = bufnr })

  if not clients or vim.tbl_isempty(clients) then
    return ""
  end

  -- Ignore some clients (e.g. copilot has its own component).
  local ignore = {
    copilot = true,
  }

  local active_clients = {}
  for _, client in ipairs(clients) do
    if not ignore[client.name] then
      table.insert(active_clients, client)
    end
  end

  if #active_clients == 0 then
    return ""
  end

  -- Check for LSP progress messages (if supported).
  local has_progress = false
  local ok, util = pcall(require, "vim.lsp.util")
  if ok and util.get_progress_messages then
    local msgs = util.get_progress_messages()
    for _, msg in ipairs(msgs) do
      if msg.name and not ignore[msg.name] then
        has_progress = true
        break
      end
    end
  end

  if has_progress then
    local frames = icons.misc.running_animated or { "⠋", "⠙", "⠹", "⠸" }
    ---@diagnostic disable-next-line: undefined-field
    local idx = (math.floor(vim.loop.now() / 120) % #frames) + 1
    return frames[idx]
  end

  -- Default: at least one LSP attached, no active progress.
  return icons.statusline.lsp
end

--- MCPHub status helper.
--- - shows `<icon>-` when not fully loaded / stopped
--- - shows `<icon><spinner>` when executing / (re)starting
--- - shows `<icon>` when connected and idle
---
--- Relies on global variables set by your MCPHub integration:
---   - vim.g.loaded_mcphub
---   - vim.g.mcphub_status
---   - vim.g.mcphub_executing
---
--- @return string
function M.mcphub_status()
  if not vim.g.loaded_mcphub then
    return icons.statusline.mcphub .. "-"
  end

  local status = vim.g.mcphub_status or "stopped"
  local executing = vim.g.mcphub_executing

  if status == "stopped" then
    return icons.statusline.mcphub .. "-"
  end

  if executing or status == "starting" or status == "restarting" then
    local frames = icons.misc.running_animated or { "⠋", "⠙", "⠹", "⠸" }
    ---@diagnostic disable-next-line: undefined-field
    local frame = math.floor(vim.loop.now() / 100) % #frames + 1
    return icons.statusline.mcphub .. frames[frame]
  end

  return icons.statusline.mcphub
end

--- Color helper for MCPHub status component.
--- - gray when not loaded
--- - fg when ready / restarted
--- - orange when starting / restarting
--- - red when error / stopped
---
--- @return { fg: string }
function M.mcphub_color()
  if not vim.g.loaded_mcphub then
    return { fg = colors.comment }
  end

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
  if ng_running(_G._NG_SERVE) then
    table.insert(parts, icons.misc.localhost)
  end
  if ng_running(_G._NG_SERVE_LAN) then
    table.insert(parts, icons.misc.lan)
  end
  if #parts == 0 then
    return ""
  end
  return icons.ft.angular .. " " .. table.concat(parts, " ")
end

return M
