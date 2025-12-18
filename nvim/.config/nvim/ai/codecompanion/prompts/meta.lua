local helpers = require("utils.helpers")

return {
  ---Returns the user text passed to :CodeCompanion /{alias} ...
  ---Falls back to a friendly placeholder if none was provided.
  ---@param args table
  ---@return string
  user_prompt = function(args)
    return helpers.empty_as("(no input provided)", args.user_prompt)
  end,
}
