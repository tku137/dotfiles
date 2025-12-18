-- Everything related to AI plugins, such as Copilot, CodeCompanion, MCPHub, etc.

-- Where AI plugin keymaps should be put
local prefix = "<Leader>a"

-- Define a 0x default model for copilot to preserve premium requests
local free_model_copilot = "gpt-5-mini"

-- Used in codecompanion config
local cc_base = vim.fn.stdpath("config") .. "/ai/codecompanion"

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
    config = function()
      require("mcphub").setup({
        global_env = {
          GIT_ROOT = require("utils.helpers").git_root(),
          DEFAULT_MINIMUM_TOKENS = "6000",
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
    "Davidyz/VectorCode",
    version = "*", -- optional, depending on whether you're on nightly or release
    dependencies = { "nvim-lua/plenary.nvim" },
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
      "ravitemer/codecompanion-history.nvim",
    },
    opts = {
      -- adapters and models
      interactions = {
        chat = {
          adapter = {
            name = "copilot",
            model = free_model_copilot,
          },
          tools = {
            opts = {
              default_tools = {
                -- core bundle with most of CCs tools
                "full_stack_dev",

                -- useful MCP servers
                "git",
                "vectorcode",
                "context7",

                -- web stuff
                "duckduckgo_search",
                "fetch_webpage",
              },
            },

            groups = {
              -- one group to rule them all :)
              ["all_the_tools"] = {
                description = "All CC tools + MCP + web",
                tools = {
                  -- core bundle with most of CCs tools
                  "full_stack_dev",

                  -- useful MCP servers
                  -- NOTE: these are available in the mcp group,
                  -- but we make them explicitly available here so
                  -- the chat does not need to go through the @{mcp} tool
                  -- to get to these very important ones
                  "git",
                  "vectorcode",
                  "context7",

                  -- meta-group containing all MCP server tools
                  "mcp",

                  -- web stuff
                  "duckduckgo_search",
                  "fetch_webpage",

                  -- probably nice to have?
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
            model = free_model_copilot,
          },
        },
      },

      extensions = {
        -- register MCP Hub as a CodeCompanion extension (official integration)
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
        -- register VectorCode as a CodeCompanion extension
        vectorcode = {
          opts = {
            add_tool = true,
            add_slash_command = true,
          },
          tool_opts = {
            -- configure all tools with common settings
            ["*"] = {
              require_approval_before = false,
              include_in_toolbox = true,
            },
            -- specific config for querying vectorcode DB
            query = {
              chunk_mode = false,
              max_num = 10, -- max files to retrieve
              default_num = 5, -- default files to retrieve
            },
          },
        },
        -- register history extension
        history = {
          enabled = true,
          opts = {
            -- Keymap to open history from chat buffer (default: gh)
            keymap = "gh",
            -- Keymap to save the current chat manually (when auto_save is disabled)
            save_chat_keymap = "gH",
            -- Save all chats by default (disable to save only manually using 'sc')
            auto_save = true,
            -- Number of days after which chats are automatically deleted (0 to disable)
            expiration_days = 0,
            -- Picker interface (auto resolved to a valid picker)
            picker = "snacks", --- ("telescope", "snacks", "fzf-lua", or "default")
            ---Optional filter function to control which chats are shown when browsing
            chat_filter = function(chat_data)
              -- only use chats from cwd
              local same_cwd = (chat_data.cwd == vim.fn.getcwd())

              -- only keep chats from last 14 days
              local last_seven_days = os.time() - (14 * 24 * 60 * 60)
              local is_recent = chat_data.updated_at ~= nil and chat_data.updated_at >= last_seven_days

              return same_cwd and is_recent
            end,
            -- Customize picker keymaps (optional)
            picker_keymaps = {
              rename = { n = "r", i = "<M-r>" },
              delete = { n = "d", i = "<M-d>" },
              duplicate = { n = "<C-y>", i = "<C-y>" },
            },
            ---Automatically generate titles for new chats
            auto_generate_title = true,
            title_generation_opts = {
              ---Adapter for generating titles (defaults to current chat adapter)
              adapter = "copilot", -- "copilot"
              ---Model for generating titles (defaults to current chat model)
              model = free_model_copilot, -- "gpt-4o"
              ---Number of user prompts after which to refresh the title (0 to disable)
              refresh_every_n_prompts = 3, -- e.g., 3 to refresh after every 3rd user prompt
              ---Maximum number of times to refresh the title (default: 3)
              max_refreshes = 3,
              format_title = function(original_title)
                -- this can be a custom function that applies some custom
                -- formatting to the title.
                return original_title
              end,
            },
            ---On exiting and entering neovim, loads the last chat on opening chat
            continue_last_chat = false,
            ---When chat is cleared with `gx` delete the chat from history
            delete_on_clearing_chat = false,
            ---Directory path to save the chats
            dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
            ---Enable detailed logging for history extension
            enable_logging = false,

            -- Summary system
            summary = {
              -- Keymap to generate summary for current chat (default: "gcs")
              create_summary_keymap = "gZ",
              -- Keymap to browse summaries (default: "gbs")
              browse_summaries_keymap = "gz",

              generation_opts = {
                adapter = "copilot", -- defaults to current chat adapter
                model = free_model_copilot, -- defaults to current chat model
                context_size = 90000, -- max tokens that the model supports
                include_references = true, -- include slash command content
                include_tool_outputs = true, -- include tool execution results
                system_prompt = nil, -- custom system prompt (string or function)
                format_summary = nil, -- custom function to format generated summary e.g to remove <think/> tags from summary
              },
            },

            -- Memory system (requires VectorCode CLI)
            memory = {
              -- Automatically index summaries when they are generated
              auto_create_memories_on_summary_generation = true,
              -- Path to the VectorCode executable
              vectorcode_exe = "vectorcode",
              -- Tool configuration
              tool_opts = {
                -- Default number of memories to retrieve
                default_num = 10,
              },
              -- Enable notifications for indexing progress
              notify = true,
              -- Index all existing memories on startup
              -- (requires VectorCode 0.6.12+ for efficient incremental indexing)
              index_on_startup = true,
            },
          },
        },
      },

      -- UI preferences
      display = {
        action_palette = { provider = "snacks" },
        chat = {
          -- needs to be false, otherwise cant switch adapters :rolleyes:
          show_settings = false,
          show_context = true,
        },
      },

      prompt_library = {
        markdown = {
          dirs = {
            -- globel prompts in this config
            cc_base .. "/prompts",

            -- project local prompts
            "/.codecompanion/prompts",
          },
        },
      },

      rules = {
        -- Personal defaults (live nvim config)
        personal = {
          description = "Personal defaults (always loaded)",
          parser = "CodeCompanion",
          files = {
            cc_base .. "/rules/personal.md",
          },
        },

        -- task rules (loaded per-prompt via opts.rules)
        task_research = {
          description = "Task: Search then answer",
          parser = "CodeCompanion",
          files = { cc_base .. "/rules/task/research.md" },
        },
        task_gtd = {
          description = "Task: GTD (plan + execute)",
          parser = "CodeCompanion",
          files = { cc_base .. "/rules/task/gtd.md" },
        },
        task_change_summary = {
          description = "Task: Summarize git changes",
          parser = "CodeCompanion",
          files = { cc_base .. "/rules/task/change-summary.md" },
        },

        -- project rules (autoloaded when present in the repo)
        project = {
          description = "Collection of common files for all projects",
          files = {
            ".clinerules",
            ".cursorrules",
            ".goosehints",
            ".rules",
            ".windsurfrules",
            ".github/copilot-instructions.md",
            "AGENT.md",
            "AGENTS.md",
            { path = "CLAUDE.md", parser = "claude" },
            { path = "CLAUDE.local.md", parser = "claude" },
            { path = "~/.claude/CLAUDE.md", parser = "claude" },
            ".codecompanion/rules/**/*.md",
          },
          is_preset = true,
        },

        opts = {
          chat = {
            enabled = true,
            autoload = { "personal", "project" },
          },
        },
      },
    },

    keys = {
      { prefix .. "a", "<cmd>CodeCompanionActions<cr>", desc = "Actions palette", mode = { "n", "v" } },
      { prefix .. "c", "<cmd>CodeCompanionChat Toggle<cr>", desc = "Chat toggle", mode = { "n", "v" } },
      -- stylua: ignore
      { prefix .. "C", function() require("codecompanion.adapters.http.copilot.stats").show() end, desc = "Copilot stats", mode = "n" },
      { prefix .. "A", "<cmd>CodeCompanionChat Add<cr>", desc = "Add selection to chat", mode = "v" },
      { prefix .. "B", "<cmd>CodeCompanionChat Add<cr>", desc = "Add current buffer to chat", mode = "n" },
      { prefix .. "i", "<cmd>CodeCompanion<cr>", desc = "Inline assistant", mode = { "n", "v" } },
      { prefix .. "e", ":'<,'>CodeCompanion /explain<cr>", desc = "Explain selection", mode = "v" },
      { prefix .. "f", ":'<,'>CodeCompanion /fix<cr>", desc = "Fix selection", mode = "v" },
      { prefix .. "t", ":'<,'>CodeCompanion /tests<cr>", desc = "Generate tests", mode = "v" },
      { prefix .. "R", "<cmd>CodeCompanionChat RefreshCache<cr>", desc = "Refresh tool cache", mode = "n" },
    },
  },
}
