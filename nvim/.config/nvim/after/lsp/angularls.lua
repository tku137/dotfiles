-- Angular Language Server configuration
-- Place this file in: after/lsp/angularls.lua

return {
  -- Angular Language Server requires a specific setup for the project root
  root_dir = require("lspconfig.util").root_pattern("angular.json", "project.json"),

  settings = {
    angular = {
      -- Enable/disable Angular Language Service features
      enable = true,
      -- Experimental features
      experimental = {
        ivy = true, -- Enable Ivy renderer support
        strictTemplates = true, -- Enable strict template checking
      },
      -- Template and component analysis
      suggest = {
        autoImports = true,
      },
      format = {
        enable = false, -- Let Prettier handle formatting
      },
      trace = {
        server = "messages", -- "off" | "messages" | "verbose"
      },
    },
  },

  -- Custom command and initialization
  cmd = { "ngserver", "--stdio", "--tsProbeLocations", "", "--ngProbeLocations", "" },

  on_new_config = function(new_config, new_root_dir)
    -- Dynamically set the TypeScript SDK path
    local tsdk_path = new_root_dir .. "/node_modules/typescript/lib"
    if vim.fn.isdirectory(tsdk_path) == 1 then
      new_config.cmd = {
        "ngserver",
        "--stdio",
        "--tsProbeLocations",
        tsdk_path,
        "--ngProbeLocations",
        new_root_dir .. "/node_modules/@angular/language-service",
      }
    end
  end,

  on_attach = function(client, bufnr)
    -- Disable formatting (let Prettier handle it)
    if client.server_capabilities.documentFormattingProvider then
      client.server_capabilities.documentFormattingProvider = false
    end
    if client.server_capabilities.documentRangeFormattingProvider then
      client.server_capabilities.documentRangeFormattingProvider = false
    end

    local opts = { buffer = bufnr, silent = true }

    -- Angular-specific keymaps
    vim.keymap.set("n", "<leader>ag", function()
      vim.lsp.buf.definition()
    end, vim.tbl_extend("force", opts, { desc = "Go to definition" }))

    vim.keymap.set("n", "<leader>ar", function()
      vim.lsp.buf.references()
    end, vim.tbl_extend("force", opts, { desc = "Find references" }))

    vim.keymap.set("n", "<leader>ah", function()
      vim.lsp.buf.hover()
    end, vim.tbl_extend("force", opts, { desc = "Hover documentation" }))

    vim.keymap.set("n", "<leader>as", function()
      vim.lsp.buf.signature_help()
    end, vim.tbl_extend("force", opts, { desc = "Signature help" }))

    vim.keymap.set("n", "<leader>aR", function()
      vim.lsp.buf.rename()
    end, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))

    vim.keymap.set("n", "<leader>aa", function()
      vim.lsp.buf.code_action()
    end, vim.tbl_extend("force", opts, { desc = "Code actions" }))

    -- Angular template <-> component navigation
    vim.keymap.set("n", "<leader>at", function()
      -- This requires ng.nvim plugin for enhanced functionality
      if pcall(require, "ng") then
        vim.cmd("AngularGotoTemplateForComponent")
      else
        -- Fallback: try to find template file
        local current_file = vim.fn.expand("%:p")
        local template_file = current_file:gsub("%.ts$", ".html")
        if vim.fn.filereadable(template_file) == 1 then
          vim.cmd("edit " .. template_file)
        else
          vim.notify("Template file not found", vim.log.levels.WARN)
        end
      end
    end, vim.tbl_extend("force", opts, { desc = "Go to template" }))

    vim.keymap.set("n", "<leader>ac", function()
      -- This requires ng.nvim plugin for enhanced functionality
      if pcall(require, "ng") then
        vim.cmd("AngularGotoComponentWithTemplateFile")
      else
        -- Fallback: try to find component file
        local current_file = vim.fn.expand("%:p")
        local component_file = current_file:gsub("%.html$", ".ts")
        if vim.fn.filereadable(component_file) == 1 then
          vim.cmd("edit " .. component_file)
        else
          vim.notify("Component file not found", vim.log.levels.WARN)
        end
      end
    end, vim.tbl_extend("force", opts, { desc = "Go to component" }))

    -- Restart Angular Language Server (useful for configuration changes)
    vim.keymap.set("n", "<leader>aR", function()
      vim.cmd("LspRestart angularls")
    end, vim.tbl_extend("force", opts, { desc = "Restart Angular LS" }))
  end,

  -- File types that should trigger Angular Language Server
  filetypes = { "typescript", "html", "typescriptreact", "typescript.tsx" },

  -- Additional configuration for better Angular support
  init_options = {
    angularOnly = true,
  },

  -- Custom handlers for Angular-specific features
  handlers = {
    -- Handle Angular template diagnostics
    ["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
      -- Filter out some noisy Angular template diagnostics if needed
      if result and result.diagnostics then
        result.diagnostics = vim.tbl_filter(function(diagnostic)
          -- You can add custom filtering logic here
          return true
        end, result.diagnostics)
      end
      vim.lsp.handlers["textDocument/publishDiagnostics"](err, result, ctx, config)
    end,
  },
}
