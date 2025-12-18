---@mod ai.codecompanion.prompts.meta
---@brief CodeCompanion prompt placeholders for generic metadata

local helpers = require("utils.helpers")

---@class CodeCompanionPromptArgs
---@field user_prompt? string

---@class CodeCompanionMetaPlaceholders
---@field user_prompt fun(args: CodeCompanionPromptArgs): string

---@type CodeCompanionMetaPlaceholders
return {
  ---Returns the text passed after a slash-command prompt, e.g.:
  ---  :CodeCompanion /write_docs <text here>
  ---
  ---If nothing was provided, returns a readable fallback string.
  ---@param args CodeCompanionPromptArgs
  ---@return string
  user_prompt = function(args)
    return helpers.empty_as("(no input provided)", args.user_prompt)
  end,
}
