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
--- @module 'helpers'

--- @class Helpers
--- @field project_root fun(): string Returns the current project's root directory name
--- @field git_root fun(): string|nil Returns the git repository root path or nil if not in a git repo
local M = {}

--- Returns the current project's root directory name.
--- This function gets the current working directory and extracts just the directory name.
--- @return string The name of the current project's root directory
function M.project_root()
  return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
end

--- Returns the git repository root directory path.
--- This is a pure Lua implementation that walks up the directory tree
--- until it finds a `.git` directory, indicating the root of a git repository.
--- @return string|nil The absolute path to the git repository root, or nil if not in a git repo
function M.git_root()
  local git_dir = vim.fs.find(".git", { upward = true, type = "directory" })[1]
  return git_dir and vim.fs.dirname(git_dir) or nil
end

return M
