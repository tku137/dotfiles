return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main", lazy = true },
    },
    lazy = vim.fn.argc(-1) == 0, -- load treesitter immediately when opening a file from the cmdline
    event = { "BufReadPre", "BufNewFile" },
    cmd = {
      "TSBufDisable",
      "TSBufEnable",
      "TSBufToggle",
      "TSDisable",
      "TSEnable",
      "TSToggle",
      "TSInstall",
      "TSInstallInfo",
      "TSInstallSync",
      "TSModuleInfo",
      "TSUninstall",
      "TSUpdate",
      "TSUpdateSync",
    },
    build = function()
      -- silently update all treesitter parsers on fresh install
      -- otherwise installation can "hang" when a bunch of parsers are installed
      vim.cmd("silent! TSUpdate")
    end,
    init = function(plugin)
      -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
      -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
      -- no longer trigger the **nvim-treeitter** module to be loaded in time.
      -- Luckily, the only thins that those plugins need are the custom queries, which we make available
      -- during startup.
      -- CODE FROM LazyVim (thanks folke!) https://github.com/LazyVim/LazyVim/commit/1e1b68d633d4bd4faa912ba5f49ab6b8601dc0c9
      require("lazy.core.loader").add_to_rtp(plugin)
      pcall(require, "nvim-treesitter.query_predicates")
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

      -- Automatically install missing parsers when entering buffer
      -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
      auto_install = true,

      -- Install parsers synchronously (only applied to `ensure_installed`)
      sync_install = false,

      -- Modules
      -- Consistent syntax highlighting.
      highlight = { enable = true },

      -- Indentation based on treesitter for the = operator.
      indent = { enable = true },

      -- Add all the textobjects modules in one place:
      textobjects = {
        -- Selection: af/if around functions, ac/ic around classes, ap/ip for params
        select = {
          enable = true,
          lookahead = true, -- jump forward to textobject
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["ap"] = "@parameter.outer",
            ["ip"] = "@parameter.inner",
          },
        },

        -- Movement: ]f/[f to go to next/prev function, ]c/[c to class, etc.
        move = {
          enable = true,
          set_jumps = true, -- add to jumplist
          goto_next_start = {
            ["]f"] = "@function.outer",
            ["]c"] = "@class.outer",
            ["]a"] = "@parameter.inner",
          },
          goto_next_end = {
            ["]F"] = "@function.outer",
            ["]C"] = "@class.outer",
            ["]A"] = "@parameter.inner",
          },
          goto_previous_start = {
            ["[f"] = "@function.outer",
            ["[c"] = "@class.outer",
            ["[a"] = "@parameter.inner",
          },
          goto_previous_end = {
            ["[F"] = "@function.outer",
            ["[C"] = "@class.outer",
            ["[A"] = "@parameter.inner",
          },
        },

        -- Swap: <leader>a swaps next parameter, <leader>A previous
        -- TODO: find better keymaps
        -- swap = {
        --   enable = true,
        --   swap_next = {
        --     ["<leader>a"] = "@parameter.inner",
        --   },
        --   swap_previous = {
        --     ["<leader>A"] = "@parameter.inner",
        --   },
        -- },

        -- LSP Interop: peek definition of function/class under cursor
        -- TODO: check if this is useful
        -- lsp_interop = {
        --   enable = true,
        --   border = "single",
        --   peek_definition_code = {
        --     ["<leader>df"] = "@function.outer",
        --     ["<leader>dF"] = "@class.outer",
        --   },
        -- },
      },
    },
  },
}
