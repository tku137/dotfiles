-- Everything related to AI plugins, such as Copilot, CodeCompanion, MCPHub, etc.

-- Where AI plugin keymaps should be put
local prefix = "<Leader>a"

return {
  {
    "folke/which-key.nvim",
    opts = { spec = { { mode = { "n", "v" }, { "<leader>a", group = "ai" } } } },
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "BufReadPost",
    opts = {
      suggestion = {
        enabled = false,
        auto_trigger = true,
        hide_during_completion = true,
        keymap = {
          accept = false, -- handled by blink.cmp
          next = "<M-]>",
          prev = "<M-[>",
        },
      },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
      },
    },
  },
  {
    "saghen/blink.cmp",
    dependencies = {
      { "fang2hou/blink-copilot", lazy = true },
    },
    opts = {
      sources = {
        default = { "copilot" },
        providers = {
          copilot = {
            name = "copilot",
            module = "blink-copilot",
            score_offset = 100,
            async = true,
          },
        },
      },
    },
  },
  {
    "ravitemer/mcphub.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    build = "npm install -g mcp-hub@latest", -- Installs `mcp-hub` node binary globally
    config = function()
      require("mcphub").setup({
        global_env = {
          GIT_ROOT = require("utils.helpers").git_root(),
          DEFAULT_MINIMUM_TOKENS = 6000,
        },
      })
    end,
    keys = {
      {
        prefix .. "m",
        "<Cmd>MCPHub<CR>",
        desc = "Open MCPHub",
        mode = "n",
      },
    },
  },
  {
    "olimorris/codecompanion.nvim",
    event = "VeryLazy",
    lazy = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "ravitemer/mcphub.nvim",
      "folke/snacks.nvim",
    },
    opts = {
      -- adapters and models
      strategies = {
        chat = {
          adapter = {
            name = "copilot",
            model = "gpt-5",
          },
          tools = {
            opts = {
              default_tools = {
                -- core bundle with most of CCs tools
                "full_stack_dev",

                -- MCP tools (auto-generated, see below)
                "mcp",

                -- web stuff
                "search_web",
                "fetch_webpage",

                -- nice to have, maybe
                "next_edit_suggestion",
              },
            },

            groups = {
              -- one group to rule them all :)
              ["all_the_tools"] = {
                description = "All CC tools + MCP + web",
                tools = {
                  "full_stack_dev",
                  "mcp",
                  "search_web",
                  "fetch_webpage",
                  "next_edit_suggestion",
                },
                opts = { collapse_tools = true },
              },
            },
          },
        },
        inline = {
          adapter = {
            name = "copilot",
            model = "gpt-5",
          },
          -- keymaps for inline diff accept/reject
          keymaps = {
            accept_change = { modes = { "n" }, keys = "ga", description = "Accept inline change" },
            reject_change = {
              modes = { "n" },
              keys = "gr",
              opts = { nowait = true },
              description = "Reject inline change",
            },
          },
        },
      },

      -- register MCP Hub as a CodeCompanion extension (official integration)
      extensions = {
        mcphub = {
          callback = "mcphub.extensions.codecompanion",
          opts = {
            -- expose MCP resources as #{mcp:*} variables
            make_vars = true,
            -- add MCP prompts as /mcp:* slash commands
            make_slash_commands = true,
            -- show MCP tool results directly in chat
            show_result_in_chat = true,
            -- convert MCP servers and tools to CodeCompanion tools/groups
            make_tools = true,
            -- optionally show each server tool individually in chat UI
            show_server_tools_in_chat = true,
            -- add_mcp_prefix_to_tool_names = false,
          },
        },
      },

      -- UI preferences
      display = {
        action_palette = { provider = "snacks" },
      },

      prompt_library = {
        ["Search then answer"] = {
          strategy = "chat",
          description = "Search (web/MCP) first, then answer",
          prompt = [[First, gather information, then answer.

You may use:
- @{mcp} for project/services/tools
- @{all_the_tools} to access files
- search_web / fetch_webpage for external sources

Steps:
1. Collect sources (tools)
2. Synthesize
3. Answer in Markdown with links/titles from sources]],
        },

        ["Summarize changes"] = {
          strategy = "chat",
          description = "Summarize current changes made by LLM for a human",
          prompt = [[You will get code changes (diffs or edited files).

Summarize them in this format:
- What changed (bullets)
- Why it was changed (guess if needed)
- Risk level (low/med/high)
- Follow-up tasks

Keep it short.]],
        },
      },
    },

    keys = {
      { prefix .. "a", "<cmd>CodeCompanionActions<cr>", desc = "actions", mode = { "n", "v" } },
      { prefix .. "c", "<cmd>CodeCompanionChat Toggle<cr>", desc = "chat toggle", mode = { "n", "v" } },
      { prefix .. "A", "<cmd>CodeCompanionChat Add<cr>", desc = "add selection to chat", mode = "v" },
      { prefix .. "B", "<cmd>CodeCompanionChat Add<cr>", desc = "add current buffer to chat", mode = "n" },
      { prefix .. "i", "<cmd>CodeCompanion<cr>", desc = "inline assistant", mode = { "n", "v" } },
      { prefix .. "e", ":'<,'>CodeCompanion /explain<cr>", desc = "explain selection", mode = "v" },
      { prefix .. "f", ":'<,'>CodeCompanion /fix<cr>", desc = "fix selection", mode = "v" },
      { prefix .. "t", ":'<,'>CodeCompanion /tests<cr>", desc = "gen tests (vis)", mode = "v" },
      { prefix .. "R", "<cmd>CodeCompanionChat RefreshCache<cr>", desc = "refresh tool cache", mode = "n" },
    },
  },
}
