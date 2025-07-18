--  See :help lua-guide-autocommands

local function augroup(name)
  return vim.api.nvim_create_augroup(name, { clear = true })
end

-- Most important autocmd that reloads the config when it's saved :)
vim.api.nvim_create_autocmd("BufWritePost", {
  desc = "Reload Neovim config on save",
  group = augroup("reload_config"),
  pattern = { "init.lua", "lua/config/*.lua" },
  callback = function()
    vim.cmd("source $MYVIMRC")
    print("Config reloaded!")
  end,
})

-- Fix strange bug where first buffer has no filetype set and
-- thus treesitter and other plugins do not work
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    if vim.bo.filetype == "" then
      vim.cmd("filetype detect")
    end
  end,
})

-- Highlight when yanking (copying) text
--  See :help vim.highlight.on_yank()
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = augroup("highlight-yank"),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Checks if files have changed externally when returning to Neovim and reloads them
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  desc = "File reload on external changes",
  group = augroup("checktime"),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

-- Jump back to last edit position when reopening files
vim.api.nvim_create_autocmd("BufReadPost", {
  desc = "Last cursor position on buffer open",
  group = augroup("last_loc"),
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
      return
    end
    vim.b[buf].lazyvim_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  desc = "Auto create directory",
  group = augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- Resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  desc = "Resize splits on window resize",
  group = augroup("resize_splits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- Wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
  desc = "Wrap and spell for text filetypes",
  group = augroup("wrap_spell"),
  pattern = { "text", "plaintex", "typst", "gitcommit", "markdown", "neorg" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Fix conceallevel for JSON files
vim.api.nvim_create_autocmd({ "FileType" }, {
  desc = "Fix conceallevel for JSON files",
  group = augroup("json_conceal"),
  pattern = { "json", "jsonc", "json5" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- Close with <q> for specific filetypes
vim.api.nvim_create_autocmd("FileType", {
  desc = "Close some filetypes with q key",
  group = augroup("close_with_q"),
  pattern = {
    "PlenaryTestPopup",
    "checkhealth",
    "dbout",
    "gitsigns-blame",
    "grug-far",
    "help",
    "lspinfo",
    "neotest-output",
    "neotest-output-panel",
    "neotest-summary",
    "notify",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set("n", "q", function()
        vim.cmd("close")
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, {
        buffer = event.buf,
        silent = true,
        desc = "Quit buffer",
      })
    end)
  end,
})
-- dap-view needs special handling
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "dap-view", "dap-view-term", "dap-repl" }, -- dap-repl is set by `nvim-dap`
  callback = function(evt)
    vim.keymap.set("n", "q", "<C-w>q", { buffer = evt.buf })
  end,
})

-- Make it easier to close man-files when opened inline
vim.api.nvim_create_autocmd("FileType", {
  desc = "Close man-files opened inline",
  group = augroup("man_unlisted"),
  pattern = { "man" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
  end,
})


-- Automatically set spellchecking languages for certain text files
-- Create an autocommand for both .typ and .tex files that calls the apply_spell_language() function.
-- Search for pattern in n header lines and set desired lang if pattern is present
-- with respect to pinned main file
vim.api.nvim_create_autocmd("BufWinEnter", {
  pattern = { "*.tex" },
  callback = function()
    local tex_pattern = "\\usepackage%[[^%]]*n?german[^%]]*%]{babel}"
    local header_lines = 80
    local desired_lang = "de,en"
    local main_file = require("utils.spell_utils").get_vimtex_main_file()
    require("utils.spell_utils").apply_spell_language(main_file, tex_pattern, header_lines, desired_lang)
  end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
  pattern = { "*.typ" },
  callback = function()
    local typ_pattern = '#set%s+text%(lang:%s*"de"%s*%)'
    local header_lines = 20
    local desired_lang = "de,en"
    local main_file = require("utils.spell_utils").get_tinymist_main_file()
    require("utils.spell_utils").apply_spell_language(main_file, typ_pattern, header_lines, desired_lang)
  end,
})

