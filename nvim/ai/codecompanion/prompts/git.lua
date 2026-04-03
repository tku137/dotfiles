---@mod ai.codecompanion.prompts.git
---@brief CodeCompanion prompt placeholders for git context (status + diffs)

local helpers = require("utils.helpers")

---Max characters to include from git output to avoid oversized prompts.
local MAX_CHARS = 20000

---@class CodeCompanionPromptContext
---@field bufnr? integer

---@class CodeCompanionPromptArgs
---@field context? CodeCompanionPromptContext

---Return the repo root (best-effort) for the current buffer context.
---@param args CodeCompanionPromptArgs
---@return string
local function cwd(args)
  local bufnr = (args.context and args.context.bufnr) or 0
  return helpers.project_root_path(bufnr)
end

---Truncate output to keep prompt payloads reasonable.
---@param s string|nil
---@return string|nil
local function trunc(s)
  return helpers.truncate(s, MAX_CHARS, "\n…(truncated)…")
end

---@class CodeCompanionGitPlaceholders
---@field status fun(args: CodeCompanionPromptArgs): string
---@field diff_staged fun(args: CodeCompanionPromptArgs): string
---@field diff_unstaged fun(args: CodeCompanionPromptArgs): string

---@type CodeCompanionGitPlaceholders
return {
  ---Git status incl. branch information.
  ---Falls back if not a git repo / no status.
  ---@param args CodeCompanionPromptArgs
  ---@return string
  status = function(args)
    local out = helpers.run({ "git", "status", "--porcelain=v1", "--branch" }, { cwd = cwd(args) })
    return helpers.empty_as("(not a git repo or no status)", trunc(out))
  end,

  ---Staged diff (index).
  ---Falls back if nothing staged.
  ---@param args CodeCompanionPromptArgs
  ---@return string
  diff_staged = function(args)
    local out = helpers.run({ "git", "diff", "--no-ext-diff", "--staged" }, { cwd = cwd(args) })
    return helpers.empty_as("(no staged changes)", trunc(out))
  end,

  ---Unstaged diff (working tree).
  ---Falls back if no local changes.
  ---@param args CodeCompanionPromptArgs
  ---@return string
  diff_unstaged = function(args)
    local out = helpers.run({ "git", "diff", "--no-ext-diff" }, { cwd = cwd(args) })
    return helpers.empty_as("(no unstaged changes)", trunc(out))
  end,
}
