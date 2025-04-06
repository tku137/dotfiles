return {
  -- Icons recommended for snacks.nvim
  {
    "echasnovski/mini.icons",
    lazy = true,
    opts = {
      file = {
        [".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
        ["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
      },
      filetype = {
        dotenv = { glyph = "", hl = "MiniIconsYellow" },
      },
    },
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },

  -- UI components
  { "MunifTanjim/nui.nvim", lazy = true },

  -- snacks.nvim comes with a bunch of UI components
  {
    "folke/snacks.nvim",
    opts = {
      indent = { enabled = true },
      input = { enabled = true },
      notifier = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
    },
    -- stylua: ignore
    keys = {
      { "<leader>n", function()
        if Snacks.config.picker and Snacks.config.picker.enabled then
          Snacks.picker.notifications()
        else
          Snacks.notifier.show_history()
        end
      end, desc = "Notification History" },
      { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
    },
  },

  -- Dashboard
  {
    "folke/snacks.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      dashboard = {
        -- Preset defines the default header and key mappings.
        preset = {
          -- Used by the `header` section
          header = table.concat({
            "          ██████╗ ██████╗ ███████╗          ",
            "          ██╔══██╗██╔══██╗██╔════╝          ",
            "          ██████╔╝██║  ██║█████╗            ",
            "          ██╔═══╝ ██║  ██║██╔══╝            ",
            "          ██║     ██████╔╝███████╗          ",
            "          ╚═╝     ╚═════╝ ╚══════╝ by tku137",
          }, "\n"),
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            {
              icon = " ",
              key = "c",
              desc = "Config",
              action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
            },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
          -- The pick function can be left out if you want to use the default.
          -- If needed, you could define a custom function here that wraps Snacks.dashboard.pick.
          -- pick = function(cmd, opts)
          --   return function() return Snacks.dashboard.pick(cmd, opts) end
          -- end,
        },
        -- The sections are the different parts of the dashboard.
        sections = {
          { section = "header" },
          { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
          {
            icon = " ",
            title = "Recent Files",
            section = "recent_files",
            limit = 5,
            cwd = true,
            indent = 2,
            padding = 1,
          },
          {
            icon = " ",
            title = "Git Status",
            section = "terminal",
            enabled = function()
              return Snacks.git.get_root() ~= nil
            end,
            cmd = "git status --short --branch --renames",
            height = 5,
            padding = 1,
            ttl = 5 * 60,
            indent = 2,
          },
          { section = "startup" },
        },
      },
    },
  },
}
