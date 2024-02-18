return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
  },
  config = function()
    require("dapui").setup()

    local dap, dapui = require("dap"), require("dapui")

    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end
  end,
  keys = {
    -- Toggle breakpoint
    { "<Leader>dt", ":DapToggleBreakpoint<CR>", desc = "Toggle DAP Breakpoint" },
    -- Start/continue debugging
    { "<Leader>dc", ":DapContinue<CR>", desc = "DAP Continue" },
    -- Terminate session
    { "<Leader>dx", ":DapTerminate<CR>", desc = "DAP Terminate" },
    -- Step over
    { "<Leader>do", ":DapStepOver<CR>", desc = "DAP Step Over" },
  },
}

