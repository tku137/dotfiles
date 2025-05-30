-- Chosen LLM model used for all AI plugins
local model_for_coding = "claude-sonnet-4"

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
        -- debounce = 200,
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
      { "giuxtaposition/blink-cmp-copilot", lazy = true },
      { "Kaiser-Yang/blink-cmp-avante", lazy = true },
    },
    opts = {
      sources = {
        default = { "copilot", "avante" },
        providers = {
          copilot = {
            name = "copilot",
            module = "blink-cmp-copilot",
            opts = {
              kind = "Copilot",
            },
            score_offset = -10,
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
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = true,
    version = false, -- set this if you want to always pull the latest change
    opts = {
      -- add any opts here
      mappings = {
        ask = prefix .. "<CR>",
        edit = prefix .. "e",
        refresh = prefix .. "r",
        focus = prefix .. "f",
        toggle = {
          default = prefix .. "t",
          debug = prefix .. "d",
          hint = prefix .. "h",
          suggestion = prefix .. "s",
          repomap = prefix .. "R",
        },
        diff = {
          next = "]c",
          prev = "[c",
        },
        files = {
          add_current = prefix .. ".",
        },
      },
      behaviour = {
        auto_suggestions = false,
      },
      provider = "copilot",
      copilot = {
        model = model_for_coding,
        temperature = 0,
        max_tokens = 8192,
      },
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    -- dynamically build it, taken from astronvim
    build = vim.fn.has("win32") == 1 and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
      or "make",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
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
      -- TODO: configure render-markdown wiht opts_extend = { "file_types" }
      -- {
      --   -- Make sure to set this up properly if you have lazy=true
      --   "MeanderingProgrammer/render-markdown.nvim",
      --   opts = {
      --     file_types = { "Avante" },
      --   },
      --   ft = { "Avante" },
      -- },
    },
  },
}
