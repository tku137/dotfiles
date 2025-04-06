local M = {}

-- Returns the projects root directory name
function M.project_root()
  return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
end

return M
