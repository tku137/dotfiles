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
    },

    keys = {
      { prefix .. "a", "<cmd>CodeCompanionActions<cr>", desc = "codecompanion: actions", mode = { "n", "v" } },
      { prefix .. "c", "<cmd>CodeCompanionChat Toggle<cr>", desc = "codecompanion: chat toggle", mode = { "n", "v" } },
      { prefix .. "A", "<cmd>CodeCompanionChat Add<cr>", desc = "codecompanion: add selection to chat", mode = "v" },
      { prefix .. "i", "<cmd>CodeCompanion<cr>", desc = "codecompanion: inline assistant", mode = { "n", "v" } },
      { prefix .. "e", ":'<,'>CodeCompanion /explain<cr>", desc = "cc: explain selection", mode = "v" },
      { prefix .. "f", ":'<,'>CodeCompanion /fix<cr>", desc = "cc: fix selection", mode = "v" },
      { prefix .. "t", ":'<,'>CodeCompanion /tests<cr>", desc = "cc: gen tests (vis)", mode = "v" },
    },
  },
}
