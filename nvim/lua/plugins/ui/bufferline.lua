return {
  "akinsho/bufferline.nvim",
  event = "VeryLazy",
  dependencies = "nvim-tree/nvim-web-devicons",
  -- stylua: ignore
  keys = {
    -- TODO: use proper snacks toggle
    { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
    { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
    { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },
    { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },
    { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
    { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
    { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
    { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
    { "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },
    { "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },
    { "<leader>bs", "", desc = "Sort Buffers" },
    { "<leader>bsd", function() require("bufferline").sort_by("directory") end, desc = "By Directory" },
    { "<leader>bse", function() require("bufferline").sort_by("extension") end, desc = "By Extension" },
    { "<leader>bsr", function() require("bufferline").sort_by("relative_directory") end, desc = "By Relative Directory" },
    { "<leader>bsi", function() require("bufferline").sort_by("id") end, desc = "By ID (default)", },
    { "<leader>bsR", function() require("bufferline").sort_by(function(a, b) return a.id < b.id end) end, desc = "Reset by ID", },
  },
  opts = {
    options = {
        -- stylua: ignore
        close_command = function(n) Snacks.bufdelete(n) end,
        -- stylua: ignore
        right_mouse_command = function(n) Snacks.bufdelete(n) end,
      diagnostics = "nvim_lsp",
      diagnostics_indicator = function(_, _, diag)
        local icons = require("config.icons").diagnostics
        local ret = (diag.error and icons.Error .. diag.error .. " " or "")
          .. (diag.warning and icons.Warn .. diag.warning or "")
        return vim.trim(ret)
      end,
      diagnostics_update_in_insert = false, -- silence deprecation warning
      always_show_bufferline = true,
      offsets = {
        {
          filetype = "snacks_layout_box",
        },
      },

      -- Possible orders: "insert_after_current", "insert_at_end", "extension", "directory", "relative_directory"
      -- directory groups like in the file explorer
      sort_by = "directory",

      -- Prevent weird ordering between sessions
      persist_buffer_sort = false,
    },
  },
  config = function(_, opts)
    require("bufferline").setup(opts)
    -- Fix bufferline when restoring a session
    vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
      callback = function()
        vim.schedule(function()
          pcall(function()
            require("bufferline").setup(opts)
          end)
        end)
      end,
    })
  end,
}
