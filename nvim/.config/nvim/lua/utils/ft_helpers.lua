local M = {}

--- Creates a lualine condition function.
--- @param target_filetypes string | table A single filetype string or a table of filetype strings.
--- @param should_match_one_of_them boolean If true, cond is true if current filetype is one of target_filetypes.
---                                         If false, cond is true if current filetype is NOT one of target_filetypes.
--- @return function The condition function for lualine.
local function create_filetype_condition(target_filetypes, should_match_one_of_them)
  -- Make sure target_filetypes is a table of strings
  local types_to_check = {}
  if type(target_filetypes) == "string" then
    types_to_check = { target_filetypes }
  elseif type(target_filetypes) == "table" then
    types_to_check = target_filetypes
  else
    -- Error out here and return a function that always yields false
    vim.notify("create_filetype_condition: target_filetypes must be a string or table", vim.log.levels.WARN)
    return function()
      return false
    end
  end

  return function()
    local current_ft = vim.bo.filetype
    local match_found = false
    for _, ft_to_check in ipairs(types_to_check) do
      if current_ft == ft_to_check then
        match_found = true
        break
      end
    end

    if should_match_one_of_them then
      return match_found
    else
      return not match_found
    end
  end
end

-- Define the specific filetypes to handle
local picker_filetypes = { "snacks_picker_list" }

-- Create the specific condition functions using the generator
local is_picker_filetype = create_filetype_condition(picker_filetypes, true)
local is_not_picker_filetype = create_filetype_condition(picker_filetypes, false)

return {
  -- Condition function resembling == ft
  is_ft = function(ft)
    return create_filetype_condition(ft, true)
  end,

  -- Condition function resembling ~= ft
  is_not_ft = function(ft)
    return create_filetype_condition(ft, false)
  end,

  -- Specific condition functions for snacks_picker_list
  is_picker_filetype = function()
    return is_picker_filetype
  end,
  is_not_picker_filetype = function()
    return is_not_picker_filetype
  end,
}
