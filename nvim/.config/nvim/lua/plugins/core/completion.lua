local source_priority = {
  copilot = 5,
  avante = 4,
  conventional_commits = 3,
  git = 2,
  lsp = 1,
  path = 0,
  snippets = -1,
  buffer = -2,
  lazydev = -10,
}

return {
  {
    "saghen/blink.cmp",
    event = "InsertEnter",
    version = "1.*",
    dependencies = {
      {
        -- Snippet Engine
        "L3MON4D3/LuaSnip",
        event = "InsertEnter",
        version = "2.*",
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
            return
          end
          return "make install_jsregexp"
        end)(),
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          {
            "rafamadriz/friendly-snippets",
            config = function()
              require("luasnip.loaders.from_vscode").lazy_load()
            end,
          },
        },
        opts = {},
      },
      "folke/lazydev.nvim",
      {
        "Kaiser-Yang/blink-cmp-git",
        dependencies = "nvim-lua/plenary.nvim",
      },
      { "disrupted/blink-cmp-conventional-commits" },
    },
    opts_extend = {
      "sources.completion.enabled_providers",
      "sources.compat",
      "sources.default",
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
      keymap = {
        -- 'default' (recommended) for mappings similar to built-in completions
        --   <c-y> to accept ([y]es) the completion.
        --    This will auto-import if your LSP supports it.
        --    This will expand snippets if the LSP sent a snippet.
        -- 'super-tab' for tab to accept
        -- 'enter' for enter to accept
        -- 'none' for no mappings
        --
        -- For an understanding of why the 'default' preset is recommended,
        -- you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        --
        -- All presets have the following mappings:
        -- <tab>/<s-tab>: move to right/left of your snippet expansion
        -- <c-space>: Open menu or open docs if already open
        -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
        -- <c-e>: Hide menu
        -- <c-k>: Toggle signature help
        --
        -- See :h blink-cmp-config-keymap for defining your own keymap
        preset = "default",

        -- Add non-stretch accept that is much more confortable to use
        ["<C-z>"] = { "select_and_accept" },
        -- ["<CR>"] = { "select_and_accept" },

        -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
        --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
      },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = "normal",
      },

      completion = {
        -- By default, you may press `<c-space>` to show the documentation.
        -- Optionally, set `auto_show = true` to show the documentation after a delay.
        documentation = { auto_show = true, auto_show_delay_ms = 500 },

        -- The menu is the completion popup menu
        menu = {
          draw = {
            components = {
              -- Use custom icons for each kind of completion item
              kind_icon = {
                text = function(ctx)
                  local icons_config = require("config.icons")
                  if icons_config and icons_config.kinds and icons_config.kinds[ctx.kind] then
                    return icons_config.kinds[ctx.kind]
                  end
                  return ctx.kind_icon or " " -- Default fallback icon
                end,
                highlight = function(ctx)
                  -- Reuse blink.cmp’s default highlight groups:
                  -- “BlinkCmpKindFunction”, “BlinkCmpKindClass”, …
                  return "BlinkCmpKind" .. ctx.kind
                end,
              },
              -- Keep the plain-text kind column, but reuse same HL
              kind = {
                highlight = function(ctx)
                  return "BlinkCmpKind" .. ctx.kind
                end,
              },
            },
          },
        },
      },

      -- Sources are the sources of completion items
      -- Built-in and custom sources are supported.
      sources = {
        default = { "git", "conventional_commits", "lsp", "path", "snippets", "buffer", "lazydev" },
        providers = {
          lazydev = {
            module = "lazydev.integrations.blink",
            score_offset = 100,
          },
          git = {
            module = "blink-cmp-git",
            score_offset = -20,
            name = "Git",
            enabled = function()
              return vim.tbl_contains({ "octo", "gitcommit", "markdown" }, vim.bo.filetype)
            end,
            opts = {
              -- options for the blink-cmp-git
            },
          },
          conventional_commits = {
            name = "Conventional Commits",
            module = "blink-cmp-conventional-commits",
            enabled = function()
              return vim.bo.filetype == "gitcommit"
            end,
            opts = {}, -- none so far
          },
        },
      },

      snippets = { preset = "luasnip" },

      -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
      -- which automatically downloads a prebuilt binary when enabled.
      --
      -- By default, we use the Lua implementation instead, but you may enable
      -- the rust implementation via `'prefer_rust_with_warning'`
      --
      -- See :h blink-cmp-config-fuzzy for more information
      fuzzy = {
        implementation = "lua",
        sorts = {
          -- 1) Custom source-priority comparator
          function(a, b)
            local pa = source_priority[a.source_id] or 0
            local pb = source_priority[b.source_id] or 0
            if pa ~= pb then
              return pa > pb
            end
            -- 2) Fallback to Blink’s default scoring
            return a.score > b.score
          end,
          -- 3) Then by sort_text to stabilize ties
          "sort_text",
        },
      },

      -- Shows a signature help window while you type arguments for a function
      signature = { enabled = true },
    },
  },
}
