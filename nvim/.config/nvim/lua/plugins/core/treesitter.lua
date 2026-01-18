local function unique_sorted(list)
  local seen, out = {}, {}
  for _, v in ipairs(list or {}) do
    if type(v) == "string" and not seen[v] then
      seen[v] = true
      out[#out + 1] = v
    end
  end
  table.sort(out)
  return out
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",

    opts_extend = { "ensure_installed" },
    opts = {
      ensure_installed = {},
      install_dir = vim.fn.stdpath("data") .. "/site",
      sync_install = false,

      highlight = { enable = true },
      indent = { enable = true },
      fold = { enable = false },
    },

    config = function(_, opts)
      local ts = require("nvim-treesitter")

      ts.setup({ install_dir = opts.install_dir })

      -- Install AFTER Lazy has finished loading/merging everything
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        once = true,
        callback = function()
          local wanted = unique_sorted(opts.ensure_installed)
          if #wanted == 0 then
            return
          end

          local ok, handle = pcall(ts.install, wanted, { force = false })
          if not ok then
            -- dont brick startup if install fails, just report
            vim.schedule(function()
              vim.notify("treesitter: failed to install parsers: " .. vim.inspect(wanted), vim.log.levels.WARN)
            end)
            return
          end

          if opts.sync_install and handle and type(handle.wait) == "function" then
            pcall(function()
              handle:wait(300000)
            end)
          end
        end,
      })

      local group = vim.api.nvim_create_augroup("UserTreesitterConfig", { clear = true })

      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        callback = function(args)
          if opts.highlight and opts.highlight.enable then
            pcall(vim.treesitter.start, args.buf)
          end

          if opts.indent and opts.indent.enable then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end

          if opts.fold and opts.fold.enable then
            vim.wo[0][0].foldmethod = "expr"
            vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
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
