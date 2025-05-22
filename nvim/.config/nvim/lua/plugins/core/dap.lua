---@param config {type?:string, args?:string[]|fun():string[]?}
local function get_args(config)
  local args = type(config.args) == "function" and (config.args() or {}) or config.args or {} --[[@as string[] | string ]]
  local args_str = type(args) == "table" and table.concat(args, " ") or args --[[@as string]]

  config = vim.deepcopy(config)
  ---@cast args string[]
  config.args = function()
    local new_args = vim.fn.expand(vim.fn.input("Run with args: ", args_str)) --[[@as string]]
    if config.type and config.type == "java" then
      ---@diagnostic disable-next-line: return-type-mismatch
      return new_args
    end
    return require("dap.utils").splitstr(new_args)
  end
  return config
end

return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        -- Fancy debugger UI
        "rcarriga/nvim-dap-ui",
        dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
      },
      {
        -- Show variable values inline
        "theHamsta/nvim-dap-virtual-text",
        opts = {
          commented = true, -- prefix virtual text with comment string
        },
      },
      "Weissle/persistent-breakpoints.nvim",
      {
        "LiadOz/nvim-dap-repl-highlights",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
      },
    },
    -- Load only when a debug command is invoked
    event = "VeryLazy",
    keys = {
      -- Standard F-key controls
      {
        "<F5>",
        function()
          require("dap").continue()
        end,
        desc = "Debug: Start/Continue",
      },
      {
        "<F1>",
        function()
          require("dap").step_into()
        end,
        desc = "Debug: Step Into",
      },
      {
        "<F2>",
        function()
          require("dap").step_over()
        end,
        desc = "Debug: Step Over",
      },
      {
        "<F3>",
        function()
          require("dap").step_out()
        end,
        desc = "Debug: Step Out",
      },
      {
        "<F7>",
        function()
          require("dapui").toggle()
        end,
        desc = "Debug: Toggle DAP UI",
      },

      -- Breakpoints
      {
        "<leader>db",
        function()
          require("persistent-breakpoints.api").toggle_breakpoint()
        end,
        desc = "Toggle Breakpoint",
        silent = true,
      },
      {
        "<leader>dB",
        function()
          require("persistent-breakpoints.api").set_conditional_breakpoint(vim.fn.input("Breakpoint Condition: "))
        end,
        desc = "Conditional Breakpoint",
        silent = true,
      },
      {
        "<leader>dx",
        function()
          require("persistent-breakpoints.api").clear_all_breakpoints()
        end,
        desc = "Clear Breakpoints",
        silent = true,
      },
      {
        "<leader>dL",
        function()
          require("persistent-breakpoints.api").set_log_point(vim.fn.input("Breakpoint Message: "))
        end,
        desc = "Logging Breakpoint",
        silent = true,
      },

      -- More advanced controls
      {
        "<leader>dc",
        function()
          require("dap").continue()
        end,
        desc = "Run/Continue",
      },
      {
        "<leader>da",
        function()
          require("dap").continue({ before = get_args })
        end,
        desc = "Run with Args",
      },
      {
        "<leader>dC",
        function()
          require("dap").run_to_cursor()
        end,
        desc = "Run to Cursor",
      },
      {
        "<leader>di",
        function()
          require("dap").step_into()
        end,
        desc = "Step Into",
      },
      {
        "<leader>dO",
        function()
          require("dap").step_over()
        end,
        desc = "Step Over",
      },
      {
        "<leader>do",
        function()
          require("dap").step_out()
        end,
        desc = "Step Out",
      },

      -- DAP UI
      {
        "<leader>du",
        function()
          require("dapui").toggle({})
        end,
        desc = "Dap UI",
      },
      {
        "<leader>de",
        function()
          require("dapui").eval()
        end,
        desc = "Eval",
        mode = { "n", "v" },
      },

      -- Advanced features
      {
        "<leader>dg",
        function()
          require("dap").goto_()
        end,
        desc = "Go to Line (No Execute)",
      },
      {
        "<leader>dj",
        function()
          require("dap").down()
        end,
        desc = "Down",
      },
      {
        "<leader>dk",
        function()
          require("dap").up()
        end,
        desc = "Up",
      },
      {
        "<leader>dl",
        function()
          require("dap").run_last()
        end,
        desc = "Run Last",
      },
      {
        "<leader>dP",
        function()
          require("dap").pause()
        end,
        desc = "Pause",
      },
      {
        "<leader>dr",
        function()
          require("dap").repl.toggle()
        end,
        desc = "Toggle REPL",
      },
      {
        "<leader>ds",
        function()
          require("dap").session()
        end,
        desc = "Session",
      },
      {
        "<leader>dt",
        function()
          require("dap").terminate()
        end,
        desc = "Terminate",
      },
      {
        "<leader>dw",
        function()
          require("dap.ui.widgets").hover()
        end,
        desc = "Widgets",
      },
    },
    config = function()
      local dap, dapui = require("dap"), require("dapui")

      -- Initialize dapui with defaults
      require("dapui").setup()

      -- Automatically open and close the UI
      dap.listeners.after.event_initialized["dapui_open"] = dapui.open
      dap.listeners.before.event_terminated["dapui_close"] = dapui.close
      dap.listeners.before.event_exited["dapui_close"] = dapui.close

      -- Use custom icons and highlights for DAP signs
      local sign = vim.fn.sign_define
      sign("DapStopped", {
        text = " ",
        texthl = "DiagnosticWarn",
        linehl = "DapStoppedLine",
        numhl = "",
      })
      sign("DapBreakpoint", {
        text = " ",
        texthl = "DiagnosticInfo",
        linehl = "",
        numhl = "",
      })
      sign("DapBreakpointCondition", {
        text = " ",
        texthl = "DiagnosticSignWarn",
        linehl = "",
        numhl = "",
      })
      sign("DapBreakpointRejected", {
        text = " ",
        texthl = "DiagnosticError",
        linehl = "",
        numhl = "",
      })
      sign("DapLogPoint", {
        text = " ",
        texthl = "DiagnosticInfo",
        linehl = "",
        numhl = "",
      })

      -- Setup persistent breakpoints
      require("persistent-breakpoints").setup({
        load_breakpoints_event = { "BufReadPost" },
      })

      -- Setup REPL syntax highlighting
      require("nvim-dap-repl-highlights").setup()
    end,
  },
}
