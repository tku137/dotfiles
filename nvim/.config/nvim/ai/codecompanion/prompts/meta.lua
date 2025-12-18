local helpers = require("utils.helpers")

return {
  ---Returns the user text passed after a slash-command prompt:
  ---  :CodeCompanion /write_docs <text here>
  ---@param args table
  ---@return string
  user_prompt = function(args)
    return helpers.empty_as("(no input provided)", args.user_prompt)
  end,
}
