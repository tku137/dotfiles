-- after/lsp/cssls.lua
return {
  init_options = { provideFormatter = false },
  settings = {
    css = { lint = { unknownAtRules = "ignore" } }, -- keep only if you use Tailwind
    scss = {},
    less = {},
  },
}
