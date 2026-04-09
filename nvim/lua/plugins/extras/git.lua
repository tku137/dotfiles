-- Where git plugin keymaps should be put
local prefix = "<Leader>g"

return {

  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        {
          mode = { "n", "v" },
          { prefix, group = "git" },
          { prefix .. "h", group = "hunks" },
          { prefix .. "H", group = "GitHub" },
        },
      },
    },
  },

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
      "folke/snacks.nvim",
    },
    keys = {
      {
        prefix .. "g",
        "<Cmd>Neogit<CR>",
        desc = "Open Neogit Tab Page",
        mode = "n",
      },
    },
  },
  {
    "spacedentist/resolve.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      on_conflict_detected = function(ctx)
        local bufnr = ctx.bufnr
        -- remember original state only once
        if vim.b[bufnr].resolve_prev_diags_enabled == nil then
          vim.b[bufnr].resolve_prev_diags_enabled = vim.diagnostic.is_enabled({ bufnr = bufnr })
        end
        vim.diagnostic.enable(false, { bufnr = bufnr })
      end,
      on_conflicts_resolved = function(ctx)
        local bufnr = ctx.bufnr
        local prev = vim.b[bufnr].resolve_prev_diags_enabled
        if prev ~= nil then
          vim.diagnostic.enable(prev, { bufnr = bufnr })
          vim.b[bufnr].resolve_prev_diags_enabled = nil
        end
      end,
    },
    config = function(_, opts)
      -- setup with opts defined above
      require("resolve").setup(opts)

      -- load catppuccin colors and utils for blending colors
      -- (otherwise its too much highlighting)
      local U = require("catppuccin.utils.colors")
      local C = require("catppuccin.palettes").get_palette("macchiato")

      -- set colors for highlights
      local OursBaseColor = C.green
      local TheirsBaseColor = C.blue
      local AncestorBaseColor = C.mauve
      local SeparatorBaseColor = C.peach

      -- apply based on above colors (alpha: 0 = pure base, 1 = pure color)
      local highlights = {
        ResolveOursMarker = { bg = U.blend(OursBaseColor, C.base, 0.4), bold = true },
        ResolveOursSection = { bg = U.blend(OursBaseColor, C.base, 0.15) },

        ResolveTheirsMarker = { bg = U.blend(TheirsBaseColor, C.base, 0.4), bold = true },
        ResolveTheirsSection = { bg = U.blend(TheirsBaseColor, C.base, 0.15) },

        ResolveAncestorMarker = { bg = U.blend(AncestorBaseColor, C.base, 0.4), bold = true },
        ResolveAncestorSection = { bg = U.blend(AncestorBaseColor, C.base, 0.15) },

        ResolveSeparatorMarker = { bg = U.blend(SeparatorBaseColor, C.base, 0.3), bold = true },
      }

      for group, settings in pairs(highlights) do
        vim.api.nvim_set_hl(0, group, settings)
      end
    end,
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

      -- Override the default generate function to use Snacks.picker for template selection
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
}
