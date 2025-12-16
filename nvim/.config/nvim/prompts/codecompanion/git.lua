local helpers = require("utils.helpers")

return {
  status = function()
    return helpers.empty_as(
      "(not a git repo or no status)",
      helpers.run({ "git", "status", "--porcelain=v1", "--branch" })
    )
  end,

  diff_staged = function()
    return helpers.empty_as("(no staged changes)", helpers.run({ "git", "diff", "--no-ext-diff", "--staged" }))
  end,

  diff_unstaged = function()
    return helpers.empty_as("(no unstaged changes)", helpers.run({ "git", "diff", "--no-ext-diff" }))
  end,
}
