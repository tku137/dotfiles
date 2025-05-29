-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Indentation settings
vim.opt.expandtab = true -- Convert tabs to spaces
vim.opt.shiftwidth = 4 -- Amount to indent with < and >
vim.opt.tabstop = 4 -- How many spaces are shown per Tab
vim.opt.softtabstop = 4 -- How many spaces are applied when pressing Tab
vim.opt.smarttab = true
vim.opt.smartindent = true
vim.opt.autoindent = true -- Keep identation from previous line

-- See :help vim.opt
--  For more options, you can see :help option-list

-- Make line numbers default
vim.opt.number = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
-- vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = "a"

-- Show unified global statusline
vim.opt.laststatus = 3

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See :help 'list'
--  and :help 'listchars'
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10
-- vim.opt.scrolloff = 999 -- With this it stays in the middle.

-- If performing an operation that would fail due to unsaved changes in the buffer (like :q),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See :help 'confirm'
vim.opt.confirm = true

-- Prevent cursor from skipping a wrapped (visual) line
vim.opt.wrap = false

-- Enable truecolors from terminal (24-bit color)
vim.opt.termguicolors = true

-- Smoothscroll available since nvim 0.10
vim.opt.smoothscroll = true

-- Only consider relevant things to be part of a session so unnecessary things are ignored
vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }

-- Cursor styling
-- vim.opt.guicursor = {
--   "n-v-c:block", -- Normal, visual, command-line: block cursor
--   "i-ci-ve:ver25", -- Insert, command-line insert, visual-exclude: vertical bar cursor with 25% width
--   "r-cr:hor20", -- Replace, command-line replace: horizontal bar cursor with 20% height
--   "o:hor50", -- Operator-pending: horizontal bar cursor with 50% height
--   "a:blinkwait700-blinkoff400-blinkon250", -- All modes: blinking settings
--   "sm:block-blinkwait175-blinkoff150-blinkon175", -- Showmatch: block cursor with specific blinking settings
-- }

vim.opt.clipboard = "unnamedplus"
if vim.env.SSH_TTY then
  local function paste()
    return {
      vim.fn.split(vim.fn.getreg(""), "\n"),
      vim.fn.getregtype(""),
    }
  end

  vim.g.clipboard = {
    name = "OSC52",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
      ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
      ["+"] = paste,
      ["*"] = paste,
    },
  }
end

-- Prepend mise shims to PATH
vim.env.PATH = vim.env.HOME .. "/.local/share/mise/shims:" .. vim.env.PATH
