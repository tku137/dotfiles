-- Everything related to AI plugins, such as Copilot and opencode.nvim.

-- Where AI plugin keymaps should be put
local prefix = "<Leader>a"

return {
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        {
          mode = { "n", "v" },
          { "<leader>a", group = "ai" },
          { "<leader>ap", group = "prompts" },
        },
      },
    },
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
    "nickjvandyke/opencode.nvim",
    version = "*", -- Latest stable release
    dependencies = {
      {
        -- `snacks.nvim` integration is recommended, but optional
        ---@module "snacks" <- Loads `snacks.nvim` types for configuration intellisense
        "folke/snacks.nvim",
        optional = true,
        opts = {
          input = {}, -- Enhances `ask()`
          picker = { -- Enhances `select()`
            actions = {
              opencode_send = function(...)
                return require("opencode").snacks_picker_send(...)
              end,
            },
            win = {
              input = {
                keys = {
                  ["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
                },
              },
            },
          },
        },
      },
    },
    config = function()
      ---@type opencode.Opts
      vim.g.opencode_opts = {
        -- Your configuration, if any; goto definition on the type or field for details
      }

      vim.o.autoread = true -- Required for `opts.events.reload`
    end,
    -- stylua: ignore
    keys = {
      -- core
      { prefix .. "o", function() require("opencode").toggle() end, desc = "Toggle opencode", mode = { "n", "t" } },
      { prefix .. "a", function() require("opencode").ask("", { submit = true }) end, desc = "Ask opencode…", mode = { "n", "x" } },
      { prefix .. "q", function() require("opencode").ask("@this: ", { submit = true }) end, desc = "Quick ask with context", mode = { "n", "x" } },
      { prefix .. "A", function() require("opencode").select() end, desc = "Execute opencode action…", mode = { "n", "x" } },
      { prefix .. "c", function() require("opencode").command("agent.cycle") end, desc = "Cycle agent", mode = { "n", "x" } },
      { prefix .. "s", function() require("opencode").command("prompt.submit") end, desc = "Submit current prompt", mode = { "n", "x" } },
      { prefix .. "x", function() require("opencode").command("prompt.clear") end, desc = "Clear current prompt", mode = { "n", "x" } },

      -- prompts
      { prefix .. "pe", function() require("opencode").prompt("explain") end, desc = "Explain", mode = { "n", "x" } },
      { prefix .. "pf", function() require("opencode").prompt("fix") end, desc = "Fix", mode = { "n", "x" } },
      { prefix .. "pr", function() require("opencode").prompt("review") end, desc = "Review", mode = { "n", "x" } },
      { prefix .. "pt", function() require("opencode").prompt("test") end, desc = "Write tests", mode = { "n", "x" } },
      { prefix .. "pd", function() require("opencode").prompt("document") end, desc = "Document", mode = { "n", "x" } },
      { prefix .. "pp", function() require("opencode").prompt("optimize") end, desc = "Optimize", mode = { "n", "x" } },
      { prefix .. "pD", function() require("opencode").prompt("diff") end, desc = "Review git diff", mode = { "n", "x" } },

      -- operator (dot-repeatable, range-aware)
      { prefix .. "r",  function() return require("opencode").operator("@this ") end, desc = "Send range to opencode", mode = { "n", "x" }, expr = true },
      { prefix .. "l", function() return require("opencode").operator("@this ") .. "_" end, desc = "Send line to opencode",  mode = "n", expr = true },

      -- sessions
      { prefix .. "X", function() require("opencode").command("session.interrupt") end, desc = "Interrupt opencode", mode = "n" },

      -- misc
      { "<S-C-u>", function() require("opencode").command("session.half.page.up") end, desc = "Scroll opencode up", mode = "n" },
      { "<S-C-d>", function() require("opencode").command("session.half.page.down") end, desc = "Scroll opencode down", mode = "n" },
    },
  },
}
