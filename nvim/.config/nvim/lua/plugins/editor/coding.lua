-- This module sets up mini.ai with LazyVim-style textobjects and which-key labels.

-- Helper: select entire buffer (or inner non-blank range)
local function ai_buffer(ai_type)
  local start_line, end_line = 1, vim.fn.line("$")
  if ai_type == "i" then
    local first = vim.fn.nextnonblank(start_line)
    local last = vim.fn.prevnonblank(end_line)
    if first == 0 or last == 0 then
      return { from = { line = start_line, col = 1 } }
    end
    start_line, end_line = first, last
  end
  local to_col = math.max(#vim.fn.getline(end_line), 1)
  return {
    from = { line = start_line, col = 1 },
    to = { line = end_line, col = to_col },
  }
end

-- Helper: build which-key spec for mini.ai textobjects
local function ai_whichkey(opts)
  local objects = {
    { " ", desc = "whitespace" },
    { '"', desc = '" string' },
    { "'", desc = "' string" },
    { "(", desc = "() block" },
    { ")", desc = "() block with ws" },
    { "<", desc = "<> block" },
    { ">", desc = "<> block with ws" },
    { "?", desc = "user prompt" },
    { "U", desc = "use/call without dot" },
    { "[", desc = "[] block" },
    { "]", desc = "[] block with ws" },
    { "_", desc = "underscore" },
    { "`", desc = "` string" },
    { "a", desc = "argument" },
    { "b", desc = ")]}) block" },
    { "C", desc = "class" },
    { "d", desc = "digit(s)" },
    { "e", desc = "CamelCase / snake_case" },
    { "f", desc = "function" },
    { "g", desc = "entire file" },
    { "i", desc = "indent" },
    { "o", desc = "block, conditional, loop" },
    { "q", desc = "quote `\"'" },
    { "t", desc = "tag" },
    { "u", desc = "use/call" },
    { "{", desc = "{} block" },
    { "}", desc = "{} with ws" },
    { "c", desc = "comment" },
    { "m", desc = "email" },
    { "r", desc = "url adress" },
    { "p", desc = "path" },
    { "E", desc = "environment" },
  }

  local ret = { mode = { "o", "x" } }
  local mappings = vim.tbl_extend("force", {}, {
    around = "a",
    inside = "i",
    around_next = "an",
    inside_next = "in",
    around_last = "al",
    inside_last = "il",
  }, opts.mappings or {})
  mappings.goto_left = nil
  mappings.goto_right = nil

  for name, prefix in pairs(mappings) do
    name = name:gsub("^around_", ""):gsub("^inside_", "")
    table.insert(ret, { prefix, group = name })
    for _, obj in ipairs(objects) do
      local desc = obj.desc
      if prefix:sub(1, 1) == "i" then
        desc = desc:gsub(" with ws", "")
      end
      table.insert(ret, { prefix .. obj[1], desc = obj.desc })
    end
  end

  return ret
end

-- Plugin specification
return {
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 500,
        -- Custom textobjects for enhanced text manipulation and selection
        custom_textobjects = {
          o = ai.gen_spec.treesitter({ -- blocks, conditionals, loops
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- functions
          C = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }), -- classes
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- HTML/XML tags
          d = { "%f[%d]%d+" }, -- digits/numbers
          e = { -- camelCase/snake_case words
            { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
            "^().*()$",
          },
          g = ai_buffer, -- entire buffer
          u = ai.gen_spec.function_call(), -- function calls
          U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- function calls without dots
          r = { "%f[%w]https?://[%w-_%.%?%.:/%+=&]+%f[^%w-_%.%?%.:/%+=&]" }, -- URLs
          p = { "%f[%w]/[%w_/%-%.]+" }, -- file paths
          m = { "%f[%w][%w%.%+%-_]*%w@[%w%.%-]*%w%.%a%a+%f[^%w]" }, -- email addresses
          c = ai.gen_spec.treesitter({ a = "@comment.outer", i = "@comment.inner" }), -- comments
          E = ai.gen_spec.treesitter({ a = "@environment.outer", i = "@environment.inner" }), -- environments (LaTeX, etc.)
        },
      }
    end,
    config = function(_, opts)
      local ai = require("mini.ai")
      ai.setup(opts)
      -- Register which-key labels if which-key is available
      if pcall(require, "which-key") then
        require("which-key").add(ai_whichkey(opts), { notify = false })
      end
    end,
  },
}
