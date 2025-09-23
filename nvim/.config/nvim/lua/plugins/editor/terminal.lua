local prefix = "<Leader>k"

return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = { "ToggleTerm", "TermSelect", "ToggleTermSendCurrentLine", "ToggleTermSendVisualSelection" },
    keys = {
      -- directions (dedicated IDs so they don't fight each other)
      {
        prefix .. "f",
        function()
          local Terminal = require("toggleterm.terminal").Terminal
          _TT_FLOAT = _TT_FLOAT
            or Terminal:new({
              count = 91,
              direction = "float",
              hidden = true,
              close_on_exit = false,
            })
          _TT_FLOAT:toggle()
        end,
        desc = "Terminal float",
      },
      {
        prefix .. "v",
        function()
          local Terminal = require("toggleterm.terminal").Terminal
          _TT_VERT = _TT_VERT
            or Terminal:new({
              count = 92,
              direction = "vertical",
              hidden = true,
              close_on_exit = false,
            })
          _TT_VERT:toggle()
        end,
        desc = "Terminal vertical",
      },
      {
        prefix .. "h",
        function()
          local Terminal = require("toggleterm.terminal").Terminal
          _TT_HORIZ = _TT_HORIZ
            or Terminal:new({
              count = 93,
              direction = "horizontal",
              hidden = true,
              close_on_exit = false,
            })
          _TT_HORIZ:toggle()
        end,
        desc = "Terminal horizontal",
      },

      -- last used
      {
        prefix .. "t",
        function()
          vim.cmd("ToggleTerm")
        end,
        desc = "Toggle last terminal",
      },

      -- Python REPL (float, persistent)
      {
        prefix .. "p",
        function()
          local Terminal = require("toggleterm.terminal").Terminal
          if not _PYTHON_TERM then
            local py = (vim.fn.executable("ipython") == 1) and "ipython -i" -- nicer if available
              or ((vim.fn.executable("python3") == 1) and "python3" or "python")
            _PYTHON_TERM = Terminal:new({
              count = 101,
              cmd = py,
              hidden = true,
              direction = "float",
              close_on_exit = false,
            })
          end
          _PYTHON_TERM:toggle()
        end,
        desc = "Python REPL",
      },

      -- Node REPL
      {
        prefix .. "n",
        function()
          local Terminal = require("toggleterm.terminal").Terminal
          _NODE_TERM = _NODE_TERM
            or Terminal:new({
              count = 102,
              cmd = "node",
              hidden = true,
              direction = "float",
              close_on_exit = false,
            })
          _NODE_TERM:toggle()
        end,
        desc = "Node REPL",
      },

      -- Lazygit (project root)
      {
        prefix .. "g",
        function()
          local Terminal = require("toggleterm.terminal").Terminal
          _LAZYGIT = _LAZYGIT
            or Terminal:new({
              count = 111,
              cmd = "lazygit",
              dir = "git_dir",
              direction = "float",
              hidden = true,
              close_on_exit = true,
            })
          _LAZYGIT:toggle()
        end,
        desc = "lazygit (git root)",
      },

      -- File manager (yazi or ranger)
      {
        prefix .. "y",
        function()
          local Terminal = require("toggleterm.terminal").Terminal
          local fm = (vim.fn.executable("yazi") == 1) and "yazi" or "ranger"
          _FM = _FM
            or Terminal:new({
              count = 112,
              cmd = fm,
              dir = vim.loop.cwd(),
              direction = "float",
              hidden = true,
              close_on_exit = false,
            })
          _FM:toggle()
        end,
        desc = "File manager (yazi/ranger)",
      },

      -- System monitor
      {
        prefix .. "b",
        function()
          local Terminal = require("toggleterm.terminal").Terminal
          local mon = (vim.fn.executable("btop") == 1) and "btop"
            or ((vim.fn.executable("btm") == 1) and "btm" or "htop")
          _SYS = _SYS
            or Terminal:new({
              count = 113,
              cmd = mon,
              hidden = true,
              direction = "float",
              close_on_exit = true,
            })
          _SYS:toggle()
        end,
        desc = "System monitor (btop/htop)",
      },

      -- Send to terminal (great for REPLs)
      {
        prefix .. "s",
        function()
          vim.cmd("ToggleTermSendCurrentLine")
        end,
        desc = "Send current line to terminal",
      },
      { mode = "v", prefix .. "s", ":ToggleTermSendVisualSelection<CR>", desc = "Send selection to terminal" },

      -- Select / close-all
      {
        prefix .. "l",
        function()
          vim.cmd("TermSelect")
        end,
        desc = "Select terminal",
      },
      {
        prefix .. "q",
        function()
          vim.cmd("ToggleTermCloseAll")
        end,
        desc = "Close all terminals",
      },

      -- Quick exit from terminal-mode
      { mode = "t", "<Esc>", [[<C-\><C-n>]], desc = "Terminal normal-mode" },
      { mode = "t", "jk", [[<C-\><C-n>]], desc = "Terminal normal-mode (jk)" },
    },
    opts = {
      size = function(term)
        if term.direction == "horizontal" then
          return math.min(15, math.floor(vim.o.lines * 0.25))
        elseif term.direction == "vertical" then
          return math.min(80, math.floor(vim.o.columns * 0.35))
        end
      end,
      shade_terminals = true,
      start_in_insert = true,
      insert_mappings = true,
      persist_size = true,
      direction = "float",
      close_on_exit = true,
      float_opts = { border = "rounded", winblend = 0 },
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)
    end,
  },
}
