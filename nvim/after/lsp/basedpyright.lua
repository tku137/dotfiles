return {
  settings = {
    basedpyright = {
      analysis = {
        typeCheckingMode = "basic", -- possible values: "off", "basic", "strict"
        -- diagnosticSeverityOverrides = {
        --   reportUnknownParameterType = "none",
        --   reportMissingParameterType = "none",
        --   reportUnknownVariableType = "none",
        -- },
        inlayHints = {
          variableTypes = false,
          functionReturnTypes = false,
          callArgumentNames = false,
          -- genericTypes = false,
        },
      },
    },
  },
}
