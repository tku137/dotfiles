tokyonight_colors = {
  bg = "#222436",
  bg_dark = "#1e2030",
  bg_dark1 = "#191B29",
  bg_highlight = "#2f334d",
  blue = "#82aaff",
  blue0 = "#3e68d7",
  blue1 = "#65bcff",
  blue2 = "#0db9d7",
  blue5 = "#89ddff",
  blue6 = "#b4f9f8",
  blue7 = "#394b70",
  comment = "#636da6",
  cyan = "#86e1fc",
  dark3 = "#545c7e",
  dark5 = "#737aa2",
  fg = "#c8d3f5",
  fg_dark = "#828bb8",
  fg_gutter = "#3b4261",
  green = "#c3e88d",
  green1 = "#4fd6be",
  green2 = "#41a6b5",
  magenta = "#c099ff",
  magenta2 = "#ff007c",
  orange = "#ff966c",
  purple = "#fca7ea",
  red = "#ff757f",
  red1 = "#c53b53",
  teal = "#4fd6be",
  terminal_black = "#444a73",
  yellow = "#ffc777",
  git = {
    add = "#b8db87",
    change = "#7ca1f2",
    delete = "#e26a75",
  },
}

return {
  "rebelot/heirline.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  event = "VeryLazy",
  init = function(self)
    self.mode = vim.fn.mode(1)

    -- Create autocommands if they don't exist yet
    if not self.augroup_created then
      vim.api.nvim_create_autocmd({ "ModeChanged" }, {
        pattern = "*:[vV\x16]*", -- Visual, Visual Line, and Visual Block modes
        callback = function()
          vim.cmd("redrawstatus")
        end,
      })

      vim.api.nvim_create_autocmd({ "ModeChanged" }, {
        pattern = "[vV\x16]*:*", -- When leaving visual modes
        callback = function()
          vim.cmd("redrawstatus")
        end,
      })

      self.augroup_created = true
    end
  end,
  config = function()
    -- get some much used objects
    local heirline = require("heirline")
    local conditions = require("heirline.conditions")
    local utils = require("heirline.utils")

    -- Load tokyonight colors
    local colors = require("tokyonight.colors").setup()

    -------------------------------------------------
    -- LEFT SECTION
    -------------------------------------------------

    -- ViMode: Displays the current mode
    local ViMode = {
      -- get vim current mode, this information will be required by the provider
      -- and the highlight functions, so we compute it only once per component
      -- evaluation and store it as a component attribute
      init = function(self)
        self.mode = vim.fn.mode(1) -- :h mode()
      end,
      -- Now we define some dictionaries to map the output of mode() to the
      -- corresponding string and color. We can put these into `static` to compute
      -- them at initialisation time.
      static = {
        mode_names = { -- change the strings if you like it vvvvverbose!
          -- Normal
          n = "NORMAL",
          no = "O-PENDING",
          nov = "O-PENDING",
          noV = "O-PENDING",
          ["no\22"] = "O-PENDING",
          niI = "NORMAL",
          niR = "NORMAL",
          niV = "NORMAL",

          -- Visual
          v = "VISUAL",
          vs = "VISUAL",

          -- Visual-Line
          V = "V-LINE",
          Vs = "V-LINE",

          -- Visual-Block
          ["\22"] = "BLOCK",
          ["\22s"] = "BLOCK",

          -- Select (rarely used; Enter select mode via `gh`, etc.)
          s = "SELECT",
          S = "SELECT",
          ["\19"] = "BLOCK",

          -- Insert
          i = "INSERT",
          ic = "INSERT",
          ix = "INSERT",

          -- Replace
          R = "REPLACE",
          Rc = "REPLACE",
          Rx = "REPLACE",
          Rv = "V-REPLACE",
          Rvc = "V-REPLACE",
          Rvx = "V-REPLACE",

          -- Command
          c = "COMMAND",
          cv = "COMMAND",
          ce = "COMMAND",

          -- These are all “prompt” or “more” states:
          r = "PROMPT",
          rm = "MORE",
          ["r?"] = "CONFIRM",

          -- Shell or external
          ["!"] = "SHELL",

          -- Terminal
          t = "TERM",
          nt = "TERM", -- terminal normal mode
        },
        mode_colors = {
          -- Normal
          n = colors.blue,

          -- Insert
          i = colors.green,

          -- Visual
          v = colors.magenta,
          V = colors.magenta,
          ["\22"] = colors.magenta, -- ^V (visual block)

          -- Command
          c = colors.orange,

          -- Select
          s = colors.purple,
          S = colors.purple,
          ["\19"] = colors.purple, -- ^S (select block)

          -- Replace
          R = colors.orange,

          -- These are all “prompt” or “more” states:
          r = colors.yellow,

          -- Shell or external
          ["!"] = colors.red,

          -- Terminal
          t = colors.cyan,
          nt = colors.cyan, -- terminal normal mode same color as terminal
        },
      },
      -- We can now access the value of mode() that, by now, would have been
      -- computed by `init()` and use it to index our strings dictionary.
      -- note how `static` fields become just regular attributes once the
      -- component is instantiated.
      -- To be extra meticulous, we can also add some vim statusline syntax to
      -- control the padding and make sure our string is always at least 2
      -- characters long. Plus a nice Icon.
      provider = function(self)
        return " %2(" .. self.mode_names[self.mode] .. "%) "
      end,
      -- Same goes for the highlight. Now the background will change according to the current mode.
      hl = function(self)
        local mode = self.mode:sub(1, 1) -- get only the first mode character
        return {
          fg = colors.bg,
          -- fallback to first char only if there’s no direct index
          bg = self.mode_colors[mode] or self.mode_colors[self.mode:sub(1, 1)],
          bold = true,
        }
      end,
      -- WARN: this delays displaying visual and visual line mode till cursor is moved!
      -- Re-evaluate the component only on ModeChanged event!
      -- Also allows the statusline to be re-evaluated when entering operator-pending mode
      -- update = {
      --   "ModeChanged",
      --   pattern = "*:*",
      --   callback = vim.schedule_wrap(function()
      --     vim.cmd("redrawstatus")
      --   end),
      -- },
    }

    -- GitBranch: Shows the current git branch if in a git repository
    -- local GitBranch = {
    --   condition = conditions.is_git_repo,
    --   provider = function()
    --     return " " .. (vim.b.gitsigns_head or "")
    --   end,
    --   hl = { fg = colors.cyan, bg = colors.bg },
    -- }

    -- WorkDir: Displays the current working directory name
    -- local WorkDir = {
    --   provider = function()
    --     return " " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
    --   end,
    --   hl = { fg = colors.fg, bg = colors.bg },
    -- }

    -- FilePath & FileName: Using a simple approach to show the file path and name
    -- local FilePath = {
    --   provider = function()
    --     local path = vim.fn.expand("%:p:.:h")
    --     return (path ~= "" and (path .. "/") or "")
    --   end,
    --   hl = { fg = colors.fg, bg = colors.bg },
    -- }

    -- local FileName = {
    --   provider = function()
    --     local name = vim.fn.expand("%:t")
    --     if name == "" then
    --       return "[No Name]"
    --     end
    --     return name
    --   end,
    --   hl = { fg = colors.fg, bg = colors.bg },
    -- }

    local LeftSection = {
      ViMode,
      -- GitBranch,
      -- WorkDir,
      -- FilePath,
      -- FileName,
      hl = { bg = colors.bg, fg = colors.fg },
    }

    -------------------------------------------------
    -- RIGHT SECTION
    -------------------------------------------------

    -- LSPActive: Displays names of attached LSP clients
    -- local LSPActive = {
    --   condition = conditions.lsp_attached,
    --   provider = function()
    --     local clients = vim.lsp.get_clients()
    --     local client_names = {}
    --     for _, client in pairs(clients) do
    --       table.insert(client_names, client.name)
    --     end
    --     return " " .. table.concat(client_names, ",")
    --   end,
    --   hl = { fg = colors.cyan, bg = colors.bg },
    -- }

    -- Linter: Placeholder for linter/formatter status (customize as needed)
    -- local Linter = {
    --   provider = function()
    --     return "裂 Linter" -- Replace with actual linter status if available
    --   end,
    --   hl = { fg = colors.yellow, bg = colors.bg },
    -- }

    -- CursorPos: Shows current line and column
    -- local CursorPos = {
    --   provider = " %l:%c ",
    --   hl = { fg = colors.fg, bg = colors.bg },
    -- }

    -- Clock: Displays the current time
    -- local Clock = {
    --   provider = function()
    --     return " " .. os.date("%H:%M")
    --   end,
    --   hl = { fg = colors.magenta, bg = colors.bg },
    -- }

    -- local RightSection = {
    --   LSPActive,
    --   Linter,
    --   CursorPos,
    --   Clock,
    --   hl = { bg = colors.bg, fg = colors.fg },
    -- }

    -------------------------------------------------
    -- FINAL STATUSLINE
    -------------------------------------------------

    local StatusLine = {
      hl = { bg = colors.bg, fg = colors.fg },
      -- Left components
      LeftSection,
      -- Filler: pushes the right section to the far right
      { provider = "%=" },
      -- Right components
      -- RightSection,
    }

    heirline.setup({ statusline = StatusLine })
  end,
}
