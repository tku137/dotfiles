return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "folke/trouble.nvim",
    },
    -- stylua: ignore
    keys = {
      { "<leader>tt", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run File (Neotest)" },
      { "<leader>tT", function() require("neotest").run.run(vim.uv.cwd()) end, desc = "Run All Test Files (Neotest)" },
      { "<leader>tr", function() require("neotest").run.run() end, desc = "Run Nearest (Neotest)" },
      { "<leader>tl", function() require("neotest").run.run_last() end, desc = "Run Last (Neotest)" },
      { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Toggle Summary (Neotest)" },
      { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show Output (Neotest)" },
      { "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Toggle Output Panel (Neotest)" },
      { "<leader>tS", function() require("neotest").run.stop() end, desc = "Stop (Neotest)" },
      { "<leader>tw", function() require("neotest").watch.toggle(vim.fn.expand("%")) end, desc = "Toggle Watch (Neotest)" },
---@diagnostic disable-next-line: missing-fields
      { "<leader>td", function() require("neotest").run.run({strategy = "dap"}) end, desc = "Debug Nearest" },
    },
    opts = {
      -- Initialize adapters as a table/map.
      -- Language-specific files will add their adapter configs here.
      adapters = {},
      -- General neotest settings
      status = { virtual_text = true },
      output = { open_on_run = true },
      quickfix = {
        open = function()
          require("trouble").open({ mode = "quickfix", focus = false })
        end,
      },
      icons = require("config.icons").tests,
    },
    config = function(_, opts)
      -- Process the adapters map into a list of adapter instances
      local processed_adapters = {}
      if opts.adapters then
        for name, adapter_config in pairs(opts.adapters) do
          -- Only process string keys (adapter names), skip numeric keys (already instantiated adapters)
          if type(name) == "string" and adapter_config ~= false then
            local ok, adapter_module = pcall(require, name)
            if ok then
              if type(adapter_config) == "table" and not vim.tbl_isempty(adapter_config) then
                table.insert(processed_adapters, adapter_module(adapter_config)) -- Call adapter with its config
              else
                table.insert(processed_adapters, adapter_module({})) -- Call adapter with empty config or default
              end
            else
              vim.notify("Failed to load neotest adapter: " .. name, vim.log.levels.WARN)
            end
          elseif type(name) == "number" then
            -- This is an already instantiated adapter, keep it as-is
            table.insert(processed_adapters, adapter_config)
          end
        end
      end
      opts.adapters = processed_adapters -- Replace the map with the list of adapter instances

      -- Setup neotest with the processed opts
      require("neotest").setup(opts)

      -- Configure Neotest diagnostics namespace
      -- Makes the inline virtual text for Neotest diagnostics cleaner and more compact.
      local neotest_ns = vim.api.nvim_create_namespace("neotest")
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
            return message
          end,
        },
      }, neotest_ns)
    end,
  },
}
