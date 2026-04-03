local prefix = "<Leader>cI"

-- Helper functions

---Find project root by looking upward for common markers.
---@param bufnr? integer
---@return string
local function project_root(bufnr)
  local path = vim.api.nvim_buf_get_name(bufnr or 0)
  local markers = { ".git", "pyproject.toml", "setup.cfg", "setup.py" }
  local hit = vim.fs.find(markers, { upward = true, path = path })[1]
  return hit and vim.fs.dirname(hit) or vim.loop.cwd()
end

---Return an env table with PYTHONPATH prefixed by root (and root/src if present).
---@param root string
---@param extra_paths? string[]
---@return table<string,string>
local function env_with_pythonpath(root, extra_paths)
  local sep = package.config:sub(1, 1) == "\\" and ";" or ":"
  local env = vim.fn.environ()
  local entries = {}

  if root and root ~= "" then
    table.insert(entries, root)
  end
  local src = root and (root .. "/src") or nil
  if src and vim.uv.fs_stat(src) then
    table.insert(entries, src)
  end

  if type(extra_paths) == "table" then
    for _, p in ipairs(extra_paths) do
      if p and p ~= "" then
        table.insert(entries, p)
      end
    end
  end

  local prefix_path = table.concat(entries, sep)
  env.PYTHONPATH = prefix_path .. (env.PYTHONPATH and (sep .. env.PYTHONPATH) or "")
  return env
end

-- Add a keymap for toggling BasedPyright settings
-- This toggles BasedPyright's typeCheckingMode between "basic" and "recommended"
-- and additionally enables/disables inlay hints
Snacks.toggle
  .new({
    name = "BasedPyright Strict Mode",
    get = function()
      local client = vim.lsp.get_clients({ name = "basedpyright" })[1]
      ---@diagnostic disable-next-line: undefined-field
      return client and client.config.settings.basedpyright.analysis.typeCheckingMode == "recommended"
    end,
    set = function()
      require("utils.lsp_utils").toggle_basedpyright_settings({ silent = true })
    end,
  })
  :map("<leader>cb")

return {

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "python", "requirements" } },
  },

  -- LSP
  -- brew install ruff basedpyright
  -- OR
  -- mise use -g ruff@latest
  -- mise use -g pipx:basedpyright@latest
  {
    "neovim/nvim-lspconfig",
    opts = { servers = { "ruff", "basedpyright" } },
  },

  -- Formatter
  -- mise use -g ruff@latest
  {
    "stevearc/conform.nvim",
    opts_extend = { "formatters_by_ft.python" }, -- important to convince lazy.nvim to merge this!
    opts = { formatters_by_ft = { python = { "ruff_organize_imports", "ruff_format" } } },
  },

  -- DAP
  -- mise use -g pipx:debugpy@latest
  {
    -- Python DAP support via debugpy
    "mfussenegger/nvim-dap-python",
    -- Only activate in Python files
    ft = "python",
    -- Keys for debugging tests (uses built-in methods)
    keys = {
      {
        "<leader>dyt",
        function()
          require("dap-python").test_method()
        end,
        desc = "DAP: Debug Method",
        ft = "python",
      },
      {
        "<leader>dyc",
        function()
          require("dap-python").test_class()
        end,
        desc = "DAP: Debug Class",
        ft = "python",
      },
    },
    config = function()
      -- Use the 'python3' so we always use the current environments debugpy interpreter
      -- be it from the current venv or globally
      require("dap-python").setup("python3")
    end,
  },
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    opts = function()
      local dap = require("dap")
      dap.configurations.python = dap.configurations.python or {}

      local NAME = "Python: Launch file (root PYTHONPATH)"

      -- avoid duplicates on reload
      local exists = false
      for _, c in ipairs(dap.configurations.python) do
        if c.name == NAME then
          exists = true
          break
        end
      end
      if exists then
        return
      end

      table.insert(dap.configurations.python, 1, {
        type = "python",
        request = "launch",
        name = NAME,
        program = "${file}",

        -- make relative paths/logging resolve from repo root
        cwd = function()
          return project_root(0)
        end,

        -- ensure top-level packages are importable from any subdir
        env = function()
          return env_with_pythonpath(project_root(0))
        end,

        console = "integratedTerminal",
        justMyCode = false,

        -- Optional: honor a project .env if present
        -- envFile = function()
        --   local f = project_root(0) .. "/.env"
        --   return vim.uv.fs_stat(f) and f or nil
        -- end,
      })
    end,
  },

  -- Test
  {
    "nvim-neotest/neotest",
    dependencies = {
      { "nvim-neotest/neotest-python", config = function() end },
    },
    opts = {
      adapters = {
        ["neotest-python"] = {
          -- Here you can specify the settings for the adapter, i.e.
          -- runner = "pytest",
          -- python = ".venv/bin/python",
        },
      },
    },
  },

  -- Other plugins
  {
    "geg2102/nvim-python-repl",
    lazy = true,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    keys = {
      -- Normal mode keymaps
      {
        prefix,
        "",
        desc = "iPython Terminal",
      },
      {
        prefix .. "r",
        function()
          require("nvim-python-repl").send_statement_definition()
        end,
        desc = "Send to ipython terminal",
        mode = "n",
      },
      {
        "<Leader>r",
        function()
          require("nvim-python-repl").send_statement_definition()
        end,
        desc = "Send to ipython terminal",
        mode = "n",
      },
      {
        prefix .. "b",
        function()
          require("nvim-python-repl").send_buffer_to_repl()
        end,
        desc = "Send entire buffer to REPL",
        mode = "n",
      },
      {
        prefix .. "E",
        function()
          require("nvim-python-repl").toggle_execute()
          vim.notify(
            "Automatic REPL execution "
              .. (require("nvim-python-repl.config").defaults["execute_on_send"] and "Enabled" or "Disabled")
          )
        end,
        desc = "Toggle automatic execution",
        mode = "n",
      },
      {
        prefix .. "V",
        function()
          require("nvim-python-repl").toggle_vertical()
          vim.notify(
            "REPL split set to "
              .. (require("nvim-python-repl.config").defaults["vsplit"] and "Vertical" or "Horizontal")
          )
        end,
        desc = "Toggle vertical/horizontal split",
        mode = "n",
      },
      -- Visual mode keymaps
      {
        "<Leader>r",
        function()
          require("nvim-python-repl").send_visual_to_repl()
        end,
        desc = "Send to ipython terminal",
        mode = "v",
      },
    },
    ft = { "python", "lua", "scala" },
    config = function()
      require("nvim-python-repl").setup({
        execute_on_send = true,
        vsplit = false,
        split_dir = "right",
        spawn_command = {
          python = "ipython",
          scala = "sbt console",
          lua = "ilua",
        },
      })
    end,
  },
}
