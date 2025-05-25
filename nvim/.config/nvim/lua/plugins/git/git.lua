local prefix = "<Leader>g"
return {
  {
    "NeogitOrg/neogit",
    lazy = true,
    cmd = "Neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
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
    opts = {
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
    },
    keys = {
      {
        prefix .. "D",
        "<Cmd>DiffviewOpen<CR>",
        desc = "Open DiffView",
        mode = "n",
      },
    },
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
    lazy = true,
    opts = {
      width = 100,
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
    },
    cmd = { "Fugit2", "Fugit2Diff", "Fugit2Graph" },
    keys = {
      { "<leader>gf", mode = "n", desc = "Fugit2", "<cmd>Fugit2<cr>" },
    },
  },
  {
    "pwntester/octo.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "folke/snacks.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      enabled = function()
        return vim.tbl_contains({ "octo", "gitcommit", "markdown" }, vim.bo.filetype)
      end,
      picker = "snacks",
      users = "assignable", -- Users for assignees or reviewers. Values: "search" | "mentionable" | "assignable"
      default_merge_method = "squash", -- default merge method which should be used for both `Octo pr merge` and merging from picker, could be `commit`, `rebase` or `squash`
    },
  },
}
