local prefix = "<localLeader>"

return {

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "bibtex", "latex" } },
  },

  -- LSP
  -- brew install texlab
  -- OR
  -- mise use -g ubi:latex-lsp/texlab@latest
  {
    "neovim/nvim-lspconfig",
    opts = { servers = { "texlab" } },
  },

  -- Other plugins
  {
    "lervag/vimtex",
    lazy = false, -- lazy-loading will disable inverse search, never lazy-load VimTex!
    config = function()
      -- we create everything ourselves down below
      vim.g.vimtex_mappings_enabled = 0

      -- https://github.com/stefanhepp/pplatex
      vim.g.vimtex_quickfix_method = vim.fn.executable("pplatex") == 1 and "pplatex" or "latexlog"

      -- Set PDF viewer
      -- vim.g.vimtex_view_method = "zathura"

      -- Configure compiler settings
      -- vim.g.vimtex_compiler_latexmk = {
      --   options = {
      --     '-shell-escape',
      --     '-verbose',
      --   },
      -- }
    end,
    -- stylua: ignore
    keys = {
      -- Compilation & Control
      { prefix .. "l", "<Plug>(vimtex-compile)", desc = "Compile Document", mode = "n", ft = "tex", },
      { prefix .. "L", "<Plug>(vimtex-compile-selected)", desc = "Compile Selection", mode = { "n", "v" }, ft = "tex", },
      { prefix .. "c", "<Plug>(vimtex-clean)", desc = "Clean Auxiliary Files", mode = "n", ft = "tex", },
      { prefix .. "C", "<Plug>(vimtex-clean-full)", desc = "Clean All Files (incl. PDF)", mode = "n", ft = "tex", },
      { prefix .. "k", "<Plug>(vimtex-stop)", desc = "Stop Current Compilation", mode = "n", ft = "tex", },
      { prefix .. "K", "<Plug>(vimtex-stop-all)", desc = "Stop All Compilations", mode = "n", ft = "tex", },
      { prefix .. "v", "<Plug>(vimtex-view)", desc = "View Compiled PDF", mode = "n", ft = "tex", },

      -- Document Info & Navigation
      { prefix .. "e", "<Plug>(vimtex-errors)", desc = "Show Compilation Errors", mode = "n", ft = "tex", },
      { prefix .. "i", "<Plug>(vimtex-info)", desc = "Show Document Info", mode = "n", ft = "tex", },
      { prefix .. "I", "<Plug>(vimtex-info-full)", desc = "Show Full Document Info", mode = "n", ft = "tex", },
      { prefix .. "t", "<Plug>(vimtex-toc-open)", desc = "Open Table of Contents", mode = "n", ft = "tex", },
      { prefix .. "T", "<Plug>(vimtex-toc-toggle)", desc = "Toggle Table of Contents", mode = "n", ft = "tex", },
      { prefix .. "s", "<Plug>(vimtex-toggle-main)", desc = "Toggle Main TeX File", mode = "n", ft = "tex", },
      { prefix .. "m", "<Plug>(vimtex-imaps-list)", desc = "Show Imaps", mode = "n", ft = "tex", },
      { prefix .. "o", "<Plug>(vimtex-compile-output)", desc = "Show Compiler Output", mode = "n", ft = "tex", },
      { prefix .. "q", "<Plug>(vimtex-log)", desc = "Show VimTeX Log", mode = "n", ft = "tex", },

      -- Plugin State
      { prefix .. "x", "<Plug>(vimtex-reload)", desc = "Reload VimTeX (Current File)", mode = "n", ft = "tex", },
      { prefix .. "X", "<Plug>(vimtex-reload-state)", desc = "Reload VimTeX (Full State)", mode = "n", ft = "tex", },

      -- Context Menu
      { prefix .. "a", "<Plug>(vimtex-context-menu)", desc = "Show Context Menu", mode = "n", ft = "tex", },

      -- Motions
      { "[/", "<Plug>(vimtex-[/)", desc = "Prev Start of Comment", mode = "n", ft = "tex" },
      { "]/", "<Plug>(vimtex-]/)", desc = "Next Start of Comment", mode = "n", ft = "tex" },
      { "[*", "<Plug>(vimtex-[star)", desc = "Prev End of Comment", mode = "n", ft = "tex" },
      { "]*", "<Plug>(vimtex-]star)", desc = "Next End of Comment", mode = "n", ft = "tex" },

      { "[[", "<Plug>(vimtex-[[)", desc = "Prev Start of Section", mode = "n", ft = "tex" },
      { "]]", "<Plug>(vimtex-]])", desc = "Next Start of Section", mode = "n", ft = "tex" },
      { "[]", "<Plug>(vimtex-[])", desc = "Prev End of Section", mode = "n", ft = "tex" },
      { "][", "<Plug>(vimtex-][)", desc = "Next End of Section", mode = "n", ft = "tex" },

      { "[m", "<Plug>(vimtex-[m)", desc = "Prev Start of Environment", mode = "n", ft = "tex" },
      { "]m", "<Plug>(vimtex-]m)", desc = "Next Start of Environment", mode = "n", ft = "tex" },
      { "[M", "<Plug>(vimtex-[M)", desc = "Prev End of Environment", mode = "n", ft = "tex" },
      { "]M", "<Plug>(vimtex-]M)", desc = "Next End of Environment", mode = "n", ft = "tex" },

      { "[n", "<Plug>(vimtex-[n)", desc = "Prev Start of Math Zone", mode = "n", ft = "tex" },
      { "]n", "<Plug>(vimtex-]n)", desc = "Next Start of Math Zone", mode = "n", ft = "tex" },
      { "[N", "<Plug>(vimtex-[N)", desc = "Prev End of Math Zone", mode = "n", ft = "tex" },
      { "]N", "<Plug>(vimtex-]N)", desc = "Next End of Math Zone", mode = "n", ft = "tex" },

      -- (Optional) Beamer frame motions:
      -- { "[r", "<Plug>(vimtex-[r)", desc = "Prev Start of Frame", mode = "n", ft = "tex" },
      -- { "]r", "<Plug>(vimtex-]r)", desc = "Next Start of Frame", mode = "n", ft = "tex" },
      -- { "[R", "<Plug>(vimtex-[R)", desc = "Prev End of Frame", mode = "n", ft = "tex" },
      -- { "]R", "<Plug>(vimtex-]R)", desc = "Next End of Frame",  mode = "n", ft = "tex" },

      -- WARN: textobjects seem to interfere with mini.ai
      -- INFO: TeX textobjects are defined in after/ftplugin/tex.lua
      --
      -- -- Text Objects
      -- { "ic", "<Plug>(vimtex-ic)", desc = "Inner Command", mode = { "o", "x" }, ft = "tex" },
      -- { "ac", "<Plug>(vimtex-ac)", desc = "Around Command", mode = { "o", "x" }, ft = "tex" },
      -- { "ie", "<Plug>(vimtex-ie)", desc = "Inner Environment", mode = { "o", "x" }, ft = "tex" },
      -- { "ae", "<Plug>(vimtex-ae)", desc = "Around Environment", mode = { "o", "x" }, ft = "tex" },
      -- { "i$", "<Plug>(vimtex-i$)", desc = "Inner Math Zone", mode = { "o", "x" }, ft = "tex" },
      -- { "a$", "<Plug>(vimtex-a$)", desc = "Around Math Zone", mode = { "o", "x" }, ft = "tex" },
      -- { "id", "<Plug>(vimtex-id)", desc = "Inner Delimiter", mode = { "o", "x" }, ft = "tex" },
      -- { "ad", "<Plug>(vimtex-ad)", desc = "Around Delimiter", mode = { "o", "x" }, ft = "tex" },
      -- { "iP", "<Plug>(vimtex-iP)", desc = "Inner Section/Paragraph", mode = { "o", "x" }, ft = "tex" },
      -- { "aP", "<Plug>(vimtex-aP)", desc = "Around Section/Paragraph", mode = { "o", "x" }, ft = "tex" },
      -- { "im", "<Plug>(vimtex-im)", desc = "Inner Item", mode = { "o", "x" }, ft = "tex" },
      -- { "am", "<Plug>(vimtex-am)", desc = "Around Item", mode = { "o", "x" }, ft = "tex" },
      --
      -- -- Change/Delete Surrounding
      -- { "cz", group = "Surrounding", mode = { "n", "v" }, ft = "tex" },
      -- { "dz", group = "Surrounding", mode = { "n", "v" }, ft = "tex" },
      -- -- “cz” group for Change‐Surround
      -- { "czc", "<Plug>(vimtex-cmd-change)", desc = "Change Surrounding Command", mode = { "n", "v" }, ft = "tex", },
      -- { "cze", "<Plug>(vimtex-env-change)", desc = "Change Surrounding Environment", mode = { "n", "v" }, ft = "tex", },
      -- { "cz$", "<Plug>(vimtex-env-change-math)", desc = "Change Surrounding Math Zone", mode = { "n", "v" }, ft = "tex", },
      -- { "czd", "<Plug>(vimtex-delim-change-math)", desc = "Change Surrounding Delimiter", mode = { "n", "v" }, ft = "tex", },
      --
      -- -- “dz” group for Delete‐Surround
      -- { "dzc", "<Plug>(vimtex-cmd-delete)", desc = "Delete Surrounding Command", mode = { "n", "v" }, ft = "tex", },
      -- { "dze", "<Plug>(vimtex-env-delete)", desc = "Delete Surrounding Environment", mode = { "n", "v" }, ft = "tex", },
      -- { "dz$", "<Plug>(vimtex-env-delete-math)", desc = "Delete Surrounding Math Zone", mode = { "n", "v" }, ft = "tex", },
      -- { "dzd", "<Plug>(vimtex-delim-delete)", desc = "Delete Surrounding Delimiter", mode = { "n", "v" }, ft = "tex", },
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { mode = { "n", "v" }, { prefix, group = "VimTex" } },
        -- INFO: TeX textobjects are defined in after/ftplugin/tex.lua
      },
    },
  },
}
