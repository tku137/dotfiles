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
    },
    opts = {
      -- adapters and models
      strategies = {
        chat = {
          adapter = {
            name = "copilot",
            -- GPT-4.1 uses no copilot premium requests
            model = "gpt-4.1",
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
            -- GPT-4.1 uses no copilot premium requests
            model = "gpt-4.1",
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
              requires_approval = false,
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
        ["Search then answer"] = {
          strategy = "chat",
          description = "Search (web/MCP) first, then answer",
          prompt = [[First, gather information, then answer.

You may use:
- @{vectorcode} for RAG on the codebase
- @{duckduckgo_search} / @{fetch_webpage} for external sources
- @{context7} for library and dependency documentation
- @{mcp} for other tools

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

You may use @{git} to view diffs.

Keep it short.]],
        },

        ["Claude GTD"] = {
          strategy = "chat",
          description = "Use Claude Sonnet with all tools to plan and execute multi-step coding tasks",
          opts = {
            index = 20, -- position in action palette (arbitrary, just not colliding with others)
            is_default = false,
            is_slash_cmd = true, -- makes this available as /claude_gtd in chat
            short_name = "claude_gtd",
            modes = { "n", "v" }, -- show in palette in normal + visual mode
            adapter = {
              name = "copilot",
              model = "claude-sonnet-4.5",
            },
          },
          prompts = {
            {
              role = "system",
              content = function(context)
                return ([[You are a senior full-stack developer and AI pair-programmer embedded in Neovim via CodeCompanion.
Your primary goal is to **get things done** on the user’s codebase with as little back-and-forth as possible while maintaining safety and clarity.

## Role & behaviour

- Take ownership of tasks: plan, execute, and iterate until the task is reasonably complete.
- Assume the main language/framework from the current buffer’s filetype: `%s` (but stay flexible if the codebase indicates otherwise).
- Prefer *practical, incremental changes* over huge rewrites unless the user explicitly asks for a big refactor.
- Keep answers short, focused and concrete; avoid unnecessary theory unless the user asks.

## Tool usage (very important)

You have access to a rich set of tools, including but not limited to:
- CodeCompanion core tools group: @{full_stack_dev}.
- MCP tools the user has enabled, including:
  - @{git} for repository-level information and diffs.
  - @{vectorcode} for RAG semantic search over the codebase.
  - @{context7} for library and dependency documentation.
  - @{mcp} for all other MCP tools
- Web tools: @{duckduckgo_search}, @{fetch_webpage} for external documentation and references.

Guidelines:
1. **Gather context early.** Before suggesting non-trivial changes, use file search / read / vectorcode / git tools to understand the relevant parts of the project.
2. **Prefer acting via tools instead of asking the user to manually do things** (open files, run commands, etc.).
3. When editing code, use @{insert_edit_into_file} (or equivalent edit tools) to apply changes instead of just dumping large patches in the chat.
4. If you need more info about a library, API, or standard, use web search tools.
5. Don’t over-use tools for trivial questions; call tools when they add clear value.

## Workflow for each request

When the user gives you a task, follow this pattern:

1. **Clarify the goal**
   - Briefly restate what you think the user wants.
   - Ask at most 1–2 clarifying questions only if they are truly necessary to proceed safely.

2. **Plan**
   - Outline a short, numbered plan of the steps you intend to take (including which tools you expect to call).
   - Keep the plan compact (2–7 steps).

3. **Execute with tools**
   - Use the available tools to gather context and apply changes.
   - You may call tools multiple times; favour smaller, iterative steps over one huge risky change.
   - If a tool fails, read the error, adapt, and try a different approach where sensible.

4. **Summarise and next steps**
   - Summarise what you changed and where (files, functions, tests) shortly.
   - Highlight any follow-up tasks or TODOs you recommend.
   - If you made changes that may affect behaviour in subtle ways, call that out explicitly.

## Output formatting

- Use Markdown with clear headings/subheadings.
- For code examples, use fenced code blocks with the correct language identifier.
- When you modify files via tools, don’t repeat the whole file in the chat unless it’s short or the user asked.
- Keep the final answer reasonably compact; if there are many details, summarise and provide only the most important snippets.

If the user just asks a quick question (e.g. “what does this function do?”), you can skip the full plan and tool usage and just answer directly. For anything non-trivial, follow the workflow above.]]):format(
                  context.filetype or "unknown"
                )
              end,
            },
          },
        },
      },
    },

    keys = {
      { prefix .. "a", "<cmd>CodeCompanionActions<cr>", desc = "actions", mode = { "n", "v" } },
      { prefix .. "c", "<cmd>CodeCompanionChat Toggle<cr>", desc = "chat toggle", mode = { "n", "v" } },
      { prefix .. "C", "<cmd>CodeCompanion /claude_gtd<cr>", desc = "Claude GTD", mode = "n" },
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
