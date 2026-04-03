-- after/lsp/html.lua
return {
  init_options = { provideFormatter = false }, -- let Conform/Prettier handle it
  settings = { html = { format = { enable = false } } },
}
