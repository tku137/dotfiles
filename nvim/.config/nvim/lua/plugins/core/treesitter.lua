return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- branch = "main",
    build = ":TSUpdate",
    -- main = "nvim-treesitter.configs", -- Sets main module to use for opts
    lazy = true,
    event = { "BufReadPost", "BufNewFile" },
    -- event = "BufReadPre",
    ---@param opts TSConfig
    config = function(_, opts)
      -- **Important:** use the configs module to setup
      require("nvim-treesitter.configs").setup(opts) -- load the above options
    end,
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-textobjects" },
      -- { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
    },
    opts_extend = { "ensure_installed" },
    opts = {

      -- A list of parser names, or "all" (the listed parsers MUST always be installed)
      ensure_installed = {
        "bash",
        "c",
        "diff",
        "git_config",
        "gitcommit",
        "git_rebase",
        "gitignore",
        "gitattributes",
        "json",
        "jsonc",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "printf",
        "python",
        "query",
        "regex",
        "toml",
        "vim",
        "vimdoc",
        "yaml",
      },

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
