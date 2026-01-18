local function uniq(list)
  local seen, out = {}, {}
  for _, v in ipairs(list or {}) do
    if type(v) == "string" and not seen[v] then
      seen[v] = true
      table.insert(out, v)
    end
  end
  return out
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = function()
      -- silently update all treesitter parsers on fresh install
      -- otherwise installation can "hang" when a bunch of parsers are installed
      vim.cmd("silent! TSUpdate")
    end,
    opts_extend = { "ensure_installed" },
    opts = {

      -- A list of parser names, or "all" (the listed parsers MUST always be installed)
      -- INFO: To add language specific parsers in their own config file, use this snippet:
      -- {
      --   "nvim-treesitter/nvim-treesitter",
      --   opts = { ensure_installed = { "python", "requirements" } },
      -- },
      -- INFO: basic and misc parsers are defined in languages/misc.lua
      ensure_installed = {},

      -- recommended install dir for the rewrite (and added to rtp by setup)
      install_dir = vim.fn.stdpath("data") .. "/site",

      -- Install parsers synchronously (only applied to `ensure_installed`)
      sync_install = false,

      -- Modules
      -- Consistent syntax highlighting.
      highlight = { enable = true },

      -- Indentation based on treesitter for the = operator.
      indent = { enable = true },
    },
    config = function(_, opts)
      local ts = require("nvim-treesitter")

      ---@diagnostic disable-next-line: redundant-parameter
      ts.setup({
        install_dir = opts.install_dir,
      })

      -- Install parsers you collected from all language modules
      local wanted = uniq(opts.ensure_installed)
      if #wanted > 0 then
        local handle = ts.install(wanted)
        if opts.sync_install and handle and handle.wait then
          pcall(function()
            handle:wait(300000)
          end) -- 5 min max
        end
      end

      -- Enable features (main rewrite expects you to do this yourself) :contentReference[oaicite:4]{index=4}
      local group = vim.api.nvim_create_augroup("UserTreesitterMain", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        callback = function(ev)
          if opts.highlight and opts.highlight.enable then
            pcall(vim.treesitter.start, ev.buf)
          end

          if opts.fold and opts.fold.enable then
            vim.wo.foldmethod = "expr"
            vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
          end

          if opts.indent and opts.indent.enable then
            vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    lazy = false,

    opts = {
      select = { lookahead = true },
      move = { set_jumps = true },
    },

    config = function(_, opts)
      require("nvim-treesitter-textobjects").setup(opts)

      local select = require("nvim-treesitter-textobjects.select")
      local move = require("nvim-treesitter-textobjects.move")

      local function sel(lhs, query)
        vim.keymap.set({ "x", "o" }, lhs, function()
          select.select_textobject(query, "textobjects")
        end, { desc = "TS select " .. query })
      end

      -- your existing selection maps
      sel("af", "@function.outer")
      sel("if", "@function.inner")
      sel("ac", "@class.outer")
      sel("ic", "@class.inner")
      sel("ap", "@parameter.outer")
      sel("ip", "@parameter.inner")

      local function nxo(lhs, fn, query)
        vim.keymap.set({ "n", "x", "o" }, lhs, function()
          fn(query, "textobjects")
        end, { desc = "TS move " .. query })
      end

      -- your existing movement maps
      nxo("]f", move.goto_next_start, "@function.outer")
      nxo("]c", move.goto_next_start, "@class.outer")
      nxo("]a", move.goto_next_start, "@parameter.inner")

      nxo("]F", move.goto_next_end, "@function.outer")
      nxo("]C", move.goto_next_end, "@class.outer")
      nxo("]A", move.goto_next_end, "@parameter.inner")

      nxo("[f", move.goto_previous_start, "@function.outer")
      nxo("[c", move.goto_previous_start, "@class.outer")
      nxo("[a", move.goto_previous_start, "@parameter.inner")

      nxo("[F", move.goto_previous_end, "@function.outer")
      nxo("[C", move.goto_previous_end, "@class.outer")
      nxo("[A", move.goto_previous_end, "@parameter.inner")
    end,
  },
}
