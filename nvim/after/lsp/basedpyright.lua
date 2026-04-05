return {
  settings = {
    basedpyright = {
      analysis = {
        typeCheckingMode = "basic", -- possible values: "off", "basic", "standard", "recommended", "all"
        -- diagnosticSeverityOverrides = {
        --   reportUnknownParameterType = "none",
        --   reportMissingParameterType = "none",
        --   reportUnknownVariableType = "none",
        -- },
        inlayHints = {
          variableTypes = true,
          functionReturnTypes = true,
          callArgumentNames = true,
          -- genericTypes = false,
        },
      },
    },
  },
}
