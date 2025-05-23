return {
  -- git signs highlights text that has changed since the last
  -- git commit, provides git blame and also lets you interactively
  -- stage & unstage hunks in a commit.
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      signs_staged = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
      },
    },
    config = function(_, opts)
      require("gitsigns").setup(opts)

      -- Create the Snacks toggle right after gitsigns is set up
      Snacks.toggle
        .new({
          name = "Git Signs",
          get = function()
            return require("gitsigns.config").config.signcolumn
          end,
          set = function(state)
            require("gitsigns").toggle_signs(state)
          end,
        })
        :map("<leader>uG")
    end,
    keys = {
      -- navigate hunks
      {
        "]h",
        function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            require("gitsigns").nav_hunk("next")
          end
        end,
        mode = "n",
        buffer = true,
        desc = "Next Hunk",
      },
      {
        "[h",
        function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            require("gitsigns").nav_hunk("prev")
          end
        end,
        mode = "n",
        buffer = true,
        desc = "Previous Hunk",
      },
      {
        "]H",
        function()
          require("gitsigns").nav_hunk("last")
        end,
        mode = "n",
        buffer = true,
        desc = "Last Hunk",
      },
      {
        "[H",
        function()
          require("gitsigns").nav_hunk("first")
        end,
        mode = "n",
        buffer = true,
        desc = "First Hunk",
      },

      -- stage/reset hunks
      {
        "<leader>ghs",
        ":Gitsigns stage_hunk<CR>",
        mode = { "n", "v" },
        buffer = true,
        desc = "Stage Hunk",
      },
      {
        "<leader>ghr",
        ":Gitsigns reset_hunk<CR>",
        mode = { "n", "v" },
        buffer = true,
        desc = "Reset Hunk",
      },
      {
        "<leader>ghS",
        function()
          require("gitsigns").stage_buffer()
        end,
        mode = "n",
        buffer = true,
        desc = "Stage Buffer",
      },
      {
        "<leader>ghu",
        function()
          require("gitsigns").undo_stage_hunk()
        end,
        mode = "n",
        buffer = true,
        desc = "Undo Stage Hunk",
      },
      {
        "<leader>ghR",
        function()
          require("gitsigns").reset_buffer()
        end,
        mode = "n",
        buffer = true,
        desc = "Reset Buffer",
      },

      -- preview, blame, diff
      {
        "<leader>ghp",
        function()
          require("gitsigns").preview_hunk_inline()
        end,
        mode = "n",
        buffer = true,
        desc = "Preview Hunk Inline",
      },
      {
        "<leader>ghb",
        function()
          require("gitsigns").blame_line({ full = true })
        end,
        mode = "n",
        buffer = true,
        desc = "Blame Line",
      },
      {
        "<leader>ghB",
        function()
          require("gitsigns").blame()
        end,
        mode = "n",
        buffer = true,
        desc = "Blame Buffer",
      },
      {
        "<leader>ghd",
        function()
          require("gitsigns").diffthis()
        end,
        mode = "n",
        buffer = true,
        desc = "Diff This",
      },
      {
        "<leader>ghD",
        function()
          require("gitsigns").diffthis("~")
        end,
        mode = "n",
        buffer = true,
        desc = "Diff This ~",
      },

      -- text-object for a hunk
      { "ih", ":<C-U>Gitsigns select_hunk<CR>", mode = { "o", "x" }, buffer = true, desc = "Select Hunk" },
    },
  },
}
