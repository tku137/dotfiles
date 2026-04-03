-- ftplugin/tex.lua - Enable VimTeX textobjects for tex files only
-- This file simply enables the VimTeX textobjects that are commented out in the main config

-- Only run for tex files (extra safety check)
if vim.bo.filetype ~= "tex" then
  return
end

-- Map VimTeX textobjects (these are normally disabled to avoid conflicts with mini.ai)
local function map_textobj(lhs, plug, desc)
  vim.keymap.set({ "o", "x" }, lhs, plug, {
    buffer = 0, -- explicitly use current buffer
    desc = desc,
    silent = true,
  })
end

-- LaTeX Command textobjects
map_textobj("iK", "<Plug>(vimtex-ic)", "inner command")
map_textobj("aK", "<Plug>(vimtex-ac)", "around command")

-- LaTeX Environment textobjects
map_textobj("iN", "<Plug>(vimtex-ie)", "inner environment")
map_textobj("aN", "<Plug>(vimtex-ae)", "around environment")

-- Math zone textobjects
map_textobj("i$", "<Plug>(vimtex-i$)", "inner math zone")
map_textobj("a$", "<Plug>(vimtex-a$)", "around math zone")

-- Delimiter textobjects
map_textobj("iD", "<Plug>(vimtex-id)", "inner delimiter")
map_textobj("aD", "<Plug>(vimtex-ad)", "around delimiter")

-- Section/Paragraph textobjects
map_textobj("iP", "<Plug>(vimtex-iP)", "inner section/paragraph")
map_textobj("aP", "<Plug>(vimtex-aP)", "around section/paragraph")

-- Item textobjects
map_textobj("iM", "<Plug>(vimtex-im)", "inner item")
map_textobj("aM", "<Plug>(vimtex-am)", "around item")

-- Additional which-key labels for tex-specific textobjects
if pcall(require, "which-key") then
  require("which-key").add({
    { "iK", desc = "inner command", mode = { "o", "x" }, buffer = true },
    { "aK", desc = "around command", mode = { "o", "x" }, buffer = true },
    { "iN", desc = "inner environment", mode = { "o", "x" }, buffer = true },
    { "aN", desc = "around environment", mode = { "o", "x" }, buffer = true },
    { "i$", desc = "inner math zone", mode = { "o", "x" }, buffer = true },
    { "a$", desc = "around math zone", mode = { "o", "x" }, buffer = true },
    { "iD", desc = "inner delimiter", mode = { "o", "x" }, buffer = true },
    { "aD", desc = "around delimiter", mode = { "o", "x" }, buffer = true },
    { "iP", desc = "inner section/paragraph", mode = { "o", "x" }, buffer = true },
    { "aP", desc = "around section/paragraph", mode = { "o", "x" }, buffer = true },
    { "iM", desc = "inner item", mode = { "o", "x" }, buffer = true },
    { "aM", desc = "around item", mode = { "o", "x" }, buffer = true },
  })
end

local wk = require("which-key")

wk.add({
  { "<localleader>", group = "VimTex", buffer = 0 },
})
