-- Everything related to AI plugins, such as Copilot, Avante, etc.

-- Where AI plugin keymaps should be put
-- avante.nvim now uses this as default, so we dont need to override default mappings
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
      { "Kaiser-Yang/blink-cmp-avante", lazy = true },
    },
    opts = {
      sources = {
        default = { "copilot", "avante" },
        providers = {
          copilot = {
            name = "copilot",
            module = "blink-copilot",
            score_offset = 100,
            async = true,
          },
          avante = {
            module = "blink-cmp-avante",
            name = "Avante",
            enabled = function()
              return vim.tbl_contains({ "AvanteInput" }, vim.bo.filetype)
            end,
            opts = {
              -- options for blink-cmp-avante
            },
            score_offset = -40,
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
        extensions = {
          avante = {
            enabled = true,
            make_slash_commands = true, -- make /slash commands from MCP server prompts
          },
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
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = true,
    version = false, -- set this if you want to always pull the latest change
    opts = {
      -- add any opts here
      behaviour = {
        auto_suggestions = false,
      },
      provider = "copilot",
      providers = {
        copilot = {
          model = "gpt-4.1",
          timeout = 30000, -- Timeout in milliseconds
          context_window = 64000, -- Number of tokens to send to the model for context
          extra_request_body = {
            temperature = 0.75,
            max_tokens = 20480,
          },
        },
        claude = {
          model = "claude-sonnet-4",
          timeout = 30000, -- Timeout in milliseconds
          context_window = 200000,
          extra_request_body = {
            temperature = 0.75,
            max_tokens = 64000,
          },
        },
      },
      -- system_prompt as function ensures LLM always has latest MCP server state
      -- This is evaluated for every message, even in existing chats
      system_prompt = function()
        local hub = require("mcphub").get_hub_instance()
        return hub and hub:get_active_servers_prompt() or ""
      end,
      -- Using function prevents requiring mcphub before it's loaded
      custom_tools = function()
        return {
          require("mcphub.extensions.avante").mcp_tool(),
        }
      end,
      disabled_tools = {
        -- Provided by default Neovim server
        -- INFO: These are kept enabled in favor of the
        -- MUCH faster avante built-in tools
        -- "list_files",
        -- "search_files",
        -- "read_file",
        -- "create_file",
        -- "rename_file",
        -- "delete_file",
        -- "create_dir",
        -- "rename_dir",
        -- "delete_dir",
        -- "bash",

        -- Provided by fetch and duckduckgo
        -- Disabling enforces duckduckgo usage
        "web_search",
      },
    },
    keys = {
      {
        prefix .. "P",
        "<Cmd>AvanteSwitchProvider<CR>",
        desc = "avante: switch provider",
        mode = "n",
      },
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    -- dynamically build it, taken from astronvim
    build = vim.fn.has("win32") == 1 and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
      or "make",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "folke/snacks.nvim",
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
    },
  },
}
