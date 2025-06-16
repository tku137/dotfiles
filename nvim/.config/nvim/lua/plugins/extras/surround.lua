-- Fast and feature-rich surround actions. For text that includes
-- surrounding characters like brackets or quotes, this allows you
-- to select the text inside, change or modify the surrounding characters,
-- and more.
return {
  "echasnovski/mini.surround",
  lazy = true,
  keys = {
    { "gsa", mode = { "n", "x" }, desc = "Add surrounding" },
    { "gsd", mode = { "n", "x" }, desc = "Delete surrounding" },
    { "gsf", mode = { "n", "x" }, desc = "Find surrounding (to the right)" },
    { "gsF", mode = { "n", "x" }, desc = "Find surrounding (to the left)" },
    { "gsh", mode = { "n", "x" }, desc = "Highlight surrounding" },
    { "gsr", mode = { "n", "x" }, desc = "Replace surrounding" },
    { "gsn", mode = { "n", "x" }, desc = "Update `n_lines`" },
  },
  opts = {
    mappings = {
      add = "gsa", -- Add surrounding in Normal and Visual modes
      delete = "gsd", -- Delete surrounding
      find = "gsf", -- Find surrounding (to the right)
      find_left = "gsF", -- Find surrounding (to the left)
      highlight = "gsh", -- Highlight surrounding
      replace = "gsr", -- Replace surrounding
      update_n_lines = "gsn", -- Update `n_lines`
    },
  },
}
