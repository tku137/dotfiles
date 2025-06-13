local M = {}

---Toggle typeCheckingMode and inlay-hints for **basedpyright** without restart
---@param opts? { silent?: boolean }
function M.toggle_basedpyright_settings(opts)
  opts = opts or {}
  local client = vim.lsp.get_clients({ name = "basedpyright" })[1]
  if not client then
    vim.notify("BasedPyright LSP is not active", vim.log.levels.WARN)
    return
  end

  local analysis = client.config.settings.basedpyright.analysis
  -- flip the mode
  analysis.typeCheckingMode = (analysis.typeCheckingMode == "basic") and "recommended" or "basic"

  -- flip the three inlay-hint booleans
  local hints = analysis.inlayHints or {}
  hints.variableTypes = not hints.variableTypes
  hints.functionReturnTypes = not hints.functionReturnTypes
  hints.parameterNames = not hints.parameterNames --  ← renamed
  analysis.inlayHints = hints

  -- push the change to the running server
  ---@diagnostic disable-next-line: inject-field
  client.config.settings.basedpyright.analysis = analysis
  ---@diagnostic disable-next-line: param-type-mismatch
  client.notify("workspace/didChangeConfiguration", {
    settings = client.config.settings,
  })

  if not opts.silent then
    vim.notify(
      ("BasedPyright: %s, inlay-hints %s"):format(analysis.typeCheckingMode, hints.variableTypes and "on" or "off"),
      vim.log.levels.INFO
    )
  end
end

-- Toggle yamlls schemaStore.enable setting
---@param opts? { silent?: boolean }
function M.toggle_yaml_schema_store(opts)
  opts = opts or {}

  -- grab the first attached yamlls client
  local client = vim.lsp.get_clients({ name = "yamlls" })[1]
  if not client then
    vim.notify("YAML LSP is not active", vim.log.levels.WARN)
    return
  end

  -- flip the setting in the client-side copy
  local cfg = client.config.settings
  ---@diagnostic disable-next-line: need-check-nil
  local store = cfg.yaml.schemaStore or {}
  store.enable = not store.enable
  ---@diagnostic disable-next-line: need-check-nil, inject-field
  cfg.yaml.schemaStore = store

  -- notify the server
  ---@diagnostic disable-next-line: param-type-mismatch
  client.notify("workspace/didChangeConfiguration", { settings = cfg })

  if not opts.silent then
    vim.notify(
      ("yamlls: yaml.schemaStore.enable = %s (applied live)"):format(tostring(store.enable)),
      vim.log.levels.INFO
    )
  end
end

-- Loads and merges extra schema files from a list.
-- 'files' is a list of absolute file paths.
-- 'default_base' is the fallback base directory for relative URLs.
---@param files string[] List of file paths to load schemas from.
---@param default_base? string Fallback base directory for relative URLs.
function M.load_schema_files(files, default_base)
  default_base = default_base or vim.fn.getcwd()
  local schemas = {}
  for _, file in ipairs(files) do
    ---@diagnostic disable: undefined-field
    if vim.loop.fs_stat(file) then
      local ok, result = pcall(dofile, file)
      if ok and type(result) == "table" then
        for _, schema in ipairs(result) do
          -- Convert relative URLs to absolute file URIs.
          if schema.url and schema.url:sub(1, 1) == "." then
            local relative_path = schema.url:sub(3) -- remove "./"
            schema.url = "file://" .. default_base .. "/" .. relative_path
          end
          table.insert(schemas, schema)
        end
      end
    end
  end
  return schemas
end

function M.toggle_postgres(opts)
  opts = opts or {}
  local name = "postgres_lsp"
  local active = vim.lsp.is_enabled(name)

  if active then
    vim.lsp.stop_client(vim.lsp.get_clients({ name = name }), true)
    if not opts.silent then
      vim.notify("Postgres LSP disabled")
    end
  else
    vim.lsp.enable(name)
    -- start immediately for the current buffer if the ft matches
    if vim.bo.filetype == "sql" or vim.bo.filetype == "psql" then
      ---@diagnostic disable-next-line: missing-fields
      vim.lsp.start({ name = name })
    end
    if not opts.silent then
      vim.notify("Postgres LSP enabled")
    end
  end
end

return M
