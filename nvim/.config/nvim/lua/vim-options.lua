-- This file contains all vim options

-- Line numbering
vim.opt.number = true
vim.opt.relativenumber = true

-- Open splits at bottom and right
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Prevent cursor from skipping a wrapped (visual) line
vim.opt.wrap = false

-- Enable spaces as tabs
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4

-- When indenting using < and > we have to set another option
vim.opt.shiftwidth = 2

-- Enable system clipboard. This is the + register
vim.opt.clipboard = "unnamed,unnamedplus"

-- Set leader key to space
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Enable mouse mode
vim.opt.mouse = "a"

-- Enable persistent undo history
vim.opt.undofile = true

-- Enable the sign column to prevent the screen from jumping
vim.opt.signcolumn = "yes"

-- Enable cursor line highlight
vim.opt.cursorline = true

-- Prevent cursor from hitting top or bottom before scrolling. 
-- With this it stays in the middle.
vim.opt.scrolloff = 999

-- Place a visual column line
vim.opt.colorcolumn = "88"

-- Navigate vim panes better
vim.keymap.set('n', '<c-k>', ':wincmd k<CR>')
vim.keymap.set('n', '<c-j>', ':wincmd j<CR>')
vim.keymap.set('n', '<c-h>', ':wincmd h<CR>')
vim.keymap.set('n', '<c-l>', ':wincmd l<CR>')

-- Fixes for visual block mode <C-v>, this sets selecting on 
-- not present characters after EOL
vim.opt.virtualedit = "block"

-- Setting that incremental commands open in split, such 
-- as search and replace
vim.opt.inccommand = "split"

-- Ignore cases in for example command line
vim.opt.ignorecase = true

-- Enable truecolors from terminal (24-bit color)
vim.opt.termguicolors = true

-- Cursor styling
vim.opt.guicursor = {
	"n-v-c:block", -- Normal, visual, command-line: block cursor
	"i-ci-ve:ver25", -- Insert, command-line insert, visual-exclude: vertical bar cursor with 25% width
	"r-cr:hor20", -- Replace, command-line replace: horizontal bar cursor with 20% height
	"o:hor50", -- Operator-pending: horizontal bar cursor with 50% height
	"a:blinkwait700-blinkoff400-blinkon250", -- All modes: blinking settings
	"sm:block-blinkwait175-blinkoff150-blinkon175", -- Showmatch: block cursor with specific blinking settings
}
