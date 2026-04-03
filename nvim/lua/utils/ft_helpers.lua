--- Filetype Helper Utilities
---
--- This module provides utility functions for creating filetype-based condition functions,
--- primarily designed for use with lualine components. It allows you to create conditional
--- logic based on the current buffer's filetype.
---
--- The module exports functions that can be used to:
--- - Check if the current buffer matches a specific filetype or list of filetypes
--- - Check if the current buffer does NOT match a specific filetype or list of filetypes
--- - Provide pre-configured conditions for specific filetypes (e.g., snacks_picker_list)
---
--- Usage examples:
---   local ft_helpers = require("utils.ft_helpers")
---
---   -- Use in lualine component:
---   {
---     "some_component",
---     cond = ft_helpers.is_ft("lua")  -- Only show for Lua files
---   }
---
---   {
---     "another_component",
---     cond = ft_helpers.is_not_ft({"help", "man"})  -- Hide for help/man pages
---   }
---
--- @module 'utils.ft_helpers'

---@alias FiletypeTarget string|string[]
---@alias LualineCond fun(): boolean

--- Creates a lualine condition function.
--- @param target_filetypes FiletypeTarget A single filetype string or a table of filetype strings.
--- @param should_match_one_of_them boolean If true, cond is true if current filetype is one of target_filetypes.
---                                         If false, cond is true if current filetype is NOT one of target_filetypes.
--- @return LualineCond The condition function for lualine that returns true/false.
local function create_filetype_condition(target_filetypes, should_match_one_of_them)
  ---@type string[]
  local types_to_check = {}

  if type(target_filetypes) == "string" then
    types_to_check = { target_filetypes }
  elseif type(target_filetypes) == "table" then
    types_to_check = target_filetypes
  else
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

    return should_match_one_of_them and match_found or not match_found
  end
end

-- Define the specific filetypes to handle
---@type string[]
local picker_filetypes = { "snacks_picker_list" }

-- Create the specific condition functions using the generator
---@type LualineCond
local is_picker_filetype = create_filetype_condition(picker_filetypes, true)
---@type LualineCond
local is_not_picker_filetype = create_filetype_condition(picker_filetypes, false)

--- @class FtHelpers
--- @field is_ft fun(ft: FiletypeTarget): LualineCond Creates a condition that matches specific filetypes
--- @field is_not_ft fun(ft: FiletypeTarget): LualineCond Creates a condition that excludes specific filetypes
--- @field is_picker_filetype fun(): LualineCond Returns condition for snacks_picker_list filetype
--- @field is_not_picker_filetype fun(): LualineCond Returns condition excluding snacks_picker_list filetype
local M = {} ---@type FtHelpers

-- Condition function resembling == ft
--- @param ft FiletypeTarget A single filetype string or table of filetype strings
--- @return LualineCond The condition function for lualine
function M.is_ft(ft)
  return create_filetype_condition(ft, true)
end

-- Condition function resembling ~= ft
--- @param ft FiletypeTarget A single filetype string or table of filetype strings
--- @return LualineCond The condition function for lualine
function M.is_not_ft(ft)
  return create_filetype_condition(ft, false)
end

-- Specific condition functions for snacks_picker_list
--- @return LualineCond The condition function for snacks_picker_list filetype
function M.is_picker_filetype()
  return is_picker_filetype
end

--- @return LualineCond The condition function excluding snacks_picker_list filetype
function M.is_not_picker_filetype()
  return is_not_picker_filetype
end

return M
