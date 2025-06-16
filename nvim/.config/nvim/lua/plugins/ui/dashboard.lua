return {
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
          { icon = " ", key = "p", desc = "Projects", action = ":lua Snacks.dashboard.pick('projects')" },
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
}
