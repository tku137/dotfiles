local M = {}

-- Returns the projects root directory name
function M.project_root()
  return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
end

-- Returns the git root directory name
-- pure lua implementation, walks up until it finds a `.git`
function M.git_root()
  local git_dir = vim.fs.find(".git", { upward = true, type = "directory" })[1]
  return git_dir and vim.fs.dirname(git_dir) or nil
end

return M
