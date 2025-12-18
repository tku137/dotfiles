local helpers = require("utils.helpers")

-- Truncate git outputs to avoid exceeding token limits
local MAX_CHARS = 20000

-- Small helper to get the current working directory in the context of the
-- LLMs context handed over by codecompanion
local function cwd(args)
  local bufnr = (args.context and args.context.bufnr) or 0
  return helpers.project_root_path(bufnr)
end

return {
  status = function(args)
    local out = helpers.run({ "git", "status", "--porcelain=v1", "--branch" }, { cwd = cwd(args) })
    return helpers.empty_as("(not a git repo or no status)", out)
  end,

  diff_staged = function(args)
    local out = helpers.run({ "git", "diff", "--no-ext-diff", "--staged" }, { cwd = cwd(args) })
    return helpers.empty_as("(no staged changes)", helpers.truncate(out, MAX_CHARS))
  end,

  diff_unstaged = function(args)
    local out = helpers.run({ "git", "diff", "--no-ext-diff" }, { cwd = cwd(args) })
    return helpers.empty_as("(no unstaged changes)", helpers.truncate(out, MAX_CHARS))
  end,
}
