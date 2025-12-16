--- General Helper Utilities
---
--- This module provides common utility functions for Neovim configuration.
--- It includes functions for working with project directories, git repositories,
--- and other general-purpose helpers that can be used throughout the configuration.
---
--- The module exports functions that can be used to:
--- - Get project root directory information
--- - Find git repository root directories
--- - Perform common path and directory operations
---
--- Usage examples:
---   local helpers = require("utils.helpers")
---
---   -- Get the current project's root directory name
---   local project_name = helpers.project_root()
---
---   -- Get the git repository root path
---   local git_root = helpers.git_root()
---   if git_root then
---     print("Git repo found at: " .. git_root)
---   end
---
--- @module 'utils.helpers'

--- @class Helpers
--- @field project_root_name fun(): string Returns the current project's root directory name
--- @field project_root_path fun(bufnr?: integer): string Returns the current project's root directory path
--- @field git_root fun(): string|nil Returns the git repository root path or nil if not in a git repo
local M = {} ---@type Helpers

--- Returns the current project's root directory name.
--- This function gets the current working directory and extracts just the directory name.
--- @return string The name of the current project's root directory
function M.project_root_name()
  return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
end

--- Returns the current project's root directory path.
--- Prefer LSP workspace root if available, otherwise fall back to marker search.
--- @param bufnr? integer Buffer number (defaults to current buffer)
--- @return string
function M.project_root_path(bufnr)
  bufnr = bufnr or 0

  -- Try LSP workspace folders
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  for _, client in ipairs(clients) do
    local wf = client.config and client.config.workspace_folders
    if wf and wf[1] and wf[1].name then
      return wf[1].name
    end
    if client.config and client.config.root_dir then
      return client.config.root_dir
    end
  end

  -- If above fails, try marker-based root detection from buffer path
  local bufname = vim.api.nvim_buf_get_name(bufnr)
  local startpath = (bufname ~= "" and vim.fs.dirname(bufname)) or (vim.uv or vim.loop).cwd()

  local markers = {
    ".git",
    ".hg",
    ".svn",
    "pyproject.toml",
    "poetry.lock",
    "package.json",
    "go.mod",
    "Cargo.toml",
    "Makefile",
    "justfile",
  }

  local found = vim.fs.find(markers, { upward = true, path = startpath })[1]
  if found then
    return vim.fs.dirname(found)
  end

  -- If all above fails, use plain cwd fallback
  return vim.fn.getcwd()
end

--- Returns the git repository root directory path.
--- Uses git to resolve the top-level directory.
--- @return string|nil The absolute path to the git repository root, or nil if not in a git repo
function M.git_root()
  local out = vim.fn.systemlist("git rev-parse --show-toplevel")
  if vim.v.shell_error ~= 0 or #out == 0 or out[1] == "" then
    return nil
  end
  return out[1]
end

---Run a command and return stdout (trimmed). On error, return a readable message.
---@param cmd string[]
---@param opts? table
---@return string|nil
function M.run(cmd, opts)
  opts = opts or {}
  opts.text = true

  local res = vim.system(cmd, opts):wait()
  if res.code ~= 0 then
    return nil
  end
  return ((res.stdout or ""):gsub("%s+$", ""))
end

---Return `fallback` if `s` is nil/empty, otherwise return `s`.
---@param fallback string
---@param s string|nil
---@return string
function M.empty_as(fallback, s)
  if not s or s == "" then
    return fallback
  end
  return s
end

return M
