return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufEnter" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "nvim-treesitter/playground",
    },
    config = function()
      local config = require("nvim-treesitter.configs")
      config.setup({
        -- Ensuring these languages are installed
        ensure_installed = {
          -- lua
          "lua", "luap",
          -- Python
          "python",
          -- C/C++
          "cpp", "cmake", "make",
          -- shell
          "bash",
          -- Git
          "diff", "git_config", "git_rebase", "gitattributes", "gitignore", "gitcommit",
          -- Docker
          "dockerfile",
          -- Cloud
          "terraform",
          -- Markdown
          "markdown", "markdown_inline",
          -- general
          "json", "yaml", "toml", "query",
          -- Databases
          "sql",
        },

        -- Automatically install missing parsers when entering buffer
        auto_install = true,

        -- Consistent syntax highlighting.
        highlight = {
          enable = true, -- false will disable the whole extension
        },

        -- Indentation based on treesitter for the = operator.
        indent = {
          enable = true,
        },

        -- Incremental selection based on the named nodes from the grammar.
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "gnn", -- set to `false` to disable one of the mappings
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
          },
        },

        -- Textobjects
        textobjects = {
          select = {
            enable = true,

            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,

            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",

              -- You can optionally set descriptions to the mappings (used in the desc parameter of
              -- nvim_buf_set_keymap) which plugins like which-key display
              ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
              -- You can also use captures from other query groups like `locals.scm`
              ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
            },

            -- You can choose the select mode (default is charwise 'v')
            --
            -- Can also be a function which gets passed a table with the keys
            -- * query_string: eg '@function.inner'
            -- * method: eg 'v' or 'o'
            -- and should return the mode ('v', 'V', or '<c-v>') or a table
            -- mapping query_strings to modes.
            selection_modes = {
                ['@parameter.outer'] = 'v', -- charwise
                ['@function.outer'] = 'V', -- linewise
                ['@class.outer'] = '<c-v>', -- blockwise
            },

            -- If you set this to `true` (default is `false`) then any textobject is
            -- extended to include preceding or succeeding whitespace. Succeeding
            -- whitespace has priority in order to act similarly to eg the built-in
            -- `ap`.
            --
            -- Can also be a function which gets passed a table with the keys
            -- * query_string: eg '@function.inner'
            -- * selection_mode: eg 'v'
            -- and should return true of false
            include_surrounding_whitespace = true,
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              ["]m"] = "@function.outer",
              ["]]"] = "@class.outer",
            },
            goto_next_end = {
              ["]M"] = "@function.outer",
              ["]["] = "@class.outer",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[["] = "@class.outer",
            },
            goto_previous_end = {
              ["[M"] = "@function.outer",
              ["[]"] = "@class.outer",
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ["<leader>a"] = "@parameter.inner",
            },
            swap_previous = {
              ["<leader>A"] = "@parameter.inner",
            },
          },
        },

        -- Playground
        playground = {
          enable = true,
        },
      })
    end
  }
}
