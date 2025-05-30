local prefix = "<Leader>g"
return {
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "diff",
        "git_config",
        "gitcommit",
        "git_rebase",
        "gitignore",
        "gitattributes",
      },
    },
  },
  {
    "NeogitOrg/neogit",
    lazy = true,
    cmd = "Neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "folke/snacks.nvim",
    },
    keys = {
      {
        prefix .. "n",
        "<Cmd>Neogit<CR>",
        desc = "Open Neogit Tab Page",
        mode = "n",
      },
    },

    specs = {
      {
        "catppuccin",
        optional = true,
        opts = { integrations = { neogit = true } },
      },
    },
  },
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen" },
    opts = function()
      local actions = require("diffview.actions")

      return {
        enhanced_diff_hl = true,
        view = {
          default = { winbar_info = true },
          file_history = { winbar_info = true },
        },
        hooks = {
          diff_buf_read = function(bufnr)
            vim.b[bufnr].view_activated = false
          end,
        },

        -- 2️⃣  only the key-maps that matter
        -- stylua: ignore
        keymaps = {
          view = {
            -- disable originals
            ["<leader>co"] = false,
            ["<leader>ct"] = false,
            ["<leader>cb"] = false,
            ["<leader>ca"] = false,
            ["<leader>cO"] = false,
            ["<leader>cT"] = false,
            ["<leader>cB"] = false,
            ["<leader>cA"] = false,
            ["dx"] = false,
            ["dX"] = false,
            -- local-leader replacements
            { "n", "<localleader>o", actions.conflict_choose("ours"),       { desc = "Choose OURS" } },
            { "n", "<localleader>t", actions.conflict_choose("theirs"),     { desc = "Choose THEIRS" } },
            { "n", "<localleader>b", actions.conflict_choose("base"),       { desc = "Choose BASE" } },
            { "n", "<localleader>a", actions.conflict_choose("all"),        { desc = "Choose ALL" } },
            { "n", "<localleader>x", actions.conflict_choose("none"),       { desc = "Delete conflict" } },
            { "n", "<localleader>O", actions.conflict_choose_all("ours"),   { desc = "Choose OURS for all" } },
            { "n", "<localleader>T", actions.conflict_choose_all("theirs"), { desc = "Choose THEIRS for all" } },
            { "n", "<localleader>B", actions.conflict_choose_all("base"),   { desc = "Choose BASE for all" } },
            { "n", "<localleader>A", actions.conflict_choose_all("all"),    { desc = "Choose ALL for all" } },
            { "n", "<localleader>X", actions.conflict_choose_all("none"),   { desc = "Delete conflict for all" } },
          },
          file_panel = {
            ["<leader>cO"] = false,
            ["<leader>cT"] = false,
            ["<leader>cB"] = false,
            ["<leader>cA"] = false,
            ["dX"] = false,
            { "n", "<localleader>O", actions.conflict_choose_all("ours"),   { desc = "OURS for all" } },
            { "n", "<localleader>T", actions.conflict_choose_all("theirs"), { desc = "THEIRS for all" } },
            { "n", "<localleader>B", actions.conflict_choose_all("base"),   { desc = "BASE for all" } },
            { "n", "<localleader>A", actions.conflict_choose_all("all"),    { desc = "ALL for all" } },
            { "n", "<localleader>X", actions.conflict_choose_all("none"),   { desc = "Delete conflict for the whole file" } },
          },
        },
      }
    end,
    keys = {
      {
        prefix .. "v",
        "<Cmd>DiffviewOpen<CR>",
        desc = "Open DiffView",
        mode = "n",
      },
      {
        prefix .. "q",
        "<Cmd>DiffviewClose<CR>",
        desc = "Close DiffView",
        mode = "n",
      },
    },
    -- temp comment
    specs = {
      {
        "NeogitOrg/neogit",
        optional = true,
        opts = { integrations = { diffview = true } },
      },
    },
  },
  {
    "wintermute-cell/gitignore.nvim",
    lazy = true,
    dependencies = {
      "folke/snacks.nvim",
    },
    config = function()
      local gitignore = require("gitignore")
      -- The template contents are in a table in this module
      local templates_data = require("gitignore.templates")

      ---@diagnostic disable-next-line: duplicate-set-field
      gitignore.generate = function(opts)
        Snacks.picker({
          items = vim.tbl_map(function(name)
            return {
              id = name,
              text = name,
              file = name, -- This is whats displayed in the picker list
            }
          end, gitignore.templateNames),
          preview = function(ctx)
            local key = ctx.item.id:match("%.gitignore$") and ctx.item.id or (ctx.item.id .. ".gitignore")
            local body = templates_data[key] or ("# (template not found: " .. key .. ")")
            ctx.preview:reset() -- Clear old
            ctx.preview:set_lines(vim.split(body, "\n"))
            ctx.preview:set_title(key)
            ctx.preview:highlight({ ft = "gitignore" }) -- Syntax highlighting in preview
          end,
          title = "Select templates for .gitignore file",
          confirm = function(picker)
            local selected = picker:selected({ fallback = true })
            if selected and #selected > 0 then
              local templates = vim.tbl_map(function(item)
                return item.id
              end, selected)
              picker:close()
              gitignore.createGitignoreBuffer(opts.args, templates)
            end
            picker:close()
          end,
        })
      end

      vim.api.nvim_create_user_command("Gitignore", gitignore.generate, {
        nargs = "?",
        complete = "file",
      })
    end,
    keys = {
      { "<leader>gi", mode = "n", desc = "Generate .gitignore", "<cmd>Gitignore<cr>" },
    },
  },
  {
    "SuperBo/fugit2.nvim",
    build = false,
    lazy = true,
    opts = {
      width = 100,
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
      "nvim-lua/plenary.nvim",
    },
    cmd = { "Fugit2", "Fugit2Diff", "Fugit2Graph" },
    keys = {
      { "<leader>gF", mode = "n", desc = "Fugit2", "<cmd>Fugit2<cr>" },
    },
  },
}
