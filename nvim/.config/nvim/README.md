# Personal Development Environment

[![Neovim ≥ 0.11](https://img.shields.io/badge/nvim-%E2%89%A50.11-57A143?logo=neovim&logoColor=white)](https://neovim.io/)
![Last commit](https://img.shields.io/github/last-commit/tku137/dotfiles)
<a href="https://dotfyle.com/tku137/dotfiles-nvim-config-nvim"><img src="https://dotfyle.com/tku137/dotfiles-nvim-config-nvim/badges/plugins?style=flat" /></a>
<a href="https://dotfyle.com/tku137/dotfiles-nvim-config-nvim"><img src="https://dotfyle.com/tku137/dotfiles-nvim-config-nvim/badges/leaderkey?style=flat" /></a>
![Coffee consumed](https://img.shields.io/badge/coffee%20consumed-%E2%88%9E-B5651d?style=flat&logo=buymeacoffee&logoColor=white)

A modern, modular and highly opinionated Neovim configuration.

> Always a WIP...

## Quick Start

1. **Prerequisites**:
   - Neovim 0.11+ required (this config uses the new `vim.lsp` API)
   - Git
   - a [Nerd Font](https://www.nerdfonts.com/)
   - Treesitter CLI
   - a C compiler for nvim-treesitter. See [here](https://github.com/nvim-treesitter/nvim-treesitter#requirements)
   - [luarocks](https://www.lua.org/start.html#installing)
   - curl for [blink.cmp](https://github.com/Saghen/blink.cmp) (completion engine)
   - [fzf](https://github.com/junegunn/fzf)
   - [ripgrep](https://github.com/BurntSushi/ripgrep)
   - [fd](https://github.com/sharkdp/fd)
2. **Installation**: Clone this repository to your Neovim config directory
3. **First Run**: Open Neovim and let Lazy.nvim automatically install all plugins

> [!NOTE]
> For a full list of used third-party tools and their installation instructions, see the [Prerequisites](#prerequisites) section below.

## Configuration Structure

### Root Files

```
.
├── init.lua                # Entry point - bootstraps the configuration
├── lazy-lock.json          # Plugin version lockfile (managed by Lazy.nvim)
├── stylua.toml             # Lua code formatting configuration
└── README.md               # This file
```

### Main Configuration (`lua/config/`)

Core configuration modules that set up the foundation:

- **`lazy.lua`** - Plugin manager setup and main plugin imports
- **`options.lua`** - Neovim options and settings (leader keys, indentation, etc.)
- **`keymaps.lua`** - Global keybindings and shortcuts
- **`autocmds.lua`** - Autocommands for various events
- **`icons.lua`** - Icon definitions used throughout the UI

### Plugin Organization (`lua/plugins/`)

Plugins are organized into logical categories and load in that particular order:

#### Core (`lua/plugins/core/`)

Essential functionality for modern development:

- **`lsp.lua`** - Language Server Protocol configuration
- **`completion.lua`** - Autocompletion with blink.cmp
- **`treesitter.lua`** - Syntax highlighting and text objects
- **`formatting.lua`** - Code formatting with conform.nvim
- **`linting.lua`** - Code linting with nvim-lint
- **`dap.lua`** - Debug Adapter Protocol setup
- **`snacks.nvim`** - Collection of useful utilities
- **`sessions.lua`** - Session management

#### Editor (`lua/plugins/editor/`)

Editor experience enhancements:

- **`coding.lua`** - Coding utilities and enhancements
- **`comments.lua`** - Comment handling
- **`diagnostics.lua`** - Enhanced diagnostics display
- **`movement.lua`** - Enhanced navigation and movement
- **`search-replace.lua`** - Advanced search and replace
- **`which-key.lua`** - Keymap discovery and hints in a nice menu

#### UI (`lua/plugins/ui/`)

Visual enhancements and interface components:

- **`colorscheme.lua`** - Color schemes (Tokyonight is the default)
- **`lualine.lua`** - Status line configuration
- **`bufferline.lua`** - Buffer/tab line
- **`gitsigns.lua`** - Git integration and signs
- **`dashboard.lua`** - Start screen
- **`components.lua`** - UI components and utilities

#### Languages (`lua/plugins/languages/`)

Language-specific configurations:

- **`lua.lua`** - Lua development (includes this config)
- **`python.lua`** - Python with LSP (Ruff and BasedPyright with toggle between basic and strict typechecking mode), formatter, debugger UI, test suite, interactive REPL
- **`clangd.lua`** - C/C++ development
- **`markdown.lua`** - Markdown editing with visual rendering
- **`typst.lua`** - Typst document setting
- **`tex.lua`** - Full fledged LaTeX suite
- **`fish.lua`** - Fish shell scripting
- **`sql.lua`** - SQL support with database UI suite
- **`json.lua`** - JSON support
- **`yaml.lua`** - YAML support
- **`toml.lua`** - TOML support
- **`misc.lua`** - Other language support, mostly treesitter parsers

#### Extras (`lua/plugins/extras/`)

Optional plugins for extended functionality:

- **`ai.lua`** - AI integration (Copilot, CodeCompanion)
- **`git.lua`** - Advanced Git tools like Neogit, DiffView, `.gitignore` generation
- **`surround.lua`** - Text object surrounding
- **`yank.lua`** - Enhanced clipboard functionality
- **`aerial.lua`** - Code outline and navigation
- **`test.lua`** - Testing framework integration
- **`helpview-nvim.lua`** - Enhanced help viewing

### Utilities (`lua/utils/`)

Helper functions and utilities:

- **`helpers.lua`** - General utility functions
- **`lsp_utils.lua`** - LSP-specific utilities like toggling BasedPyright typechecking mode and advanced YAML schema validation
- **`spell_utils.lua`** - Spell checking utilities
- **`ft_helpers.lua`** - Filetype-specific helpers

### After Directory (`after/`)

Neovim's after directory for overrides and filetype-specific settings:

#### LSP Overrides (`after/lsp/`)

Language server specific overrides:

- **`tinymist.lua`** - Typst LSP configuration
- **`basedpyright.lua`** - Python LSP overrides
- **`clangd.lua`** - C/C++ LSP overrides
- **`yamlls.lua`** - YAML LSP overrides

#### Filetype Plugins (`after/ftplugin/`)

Filetype-specific settings and configurations:

- **`lua.lua`** - Lua-specific settings
- **`python.lua`** - Python-specific settings
- **`tex.lua`** - LaTeX-specific settings
- **`yaml.lua`** - YAML-specific settings
- **`json.lua`** - JSON-specific settings

## Key Features

### Leader Keys

- **Leader**: `<Space>` (main leader key)
- **Local Leader**: `,` (for buffer/filetype-specific actions)

### Core Functionality

- **LSP Integration**: Full language server support with automatic setup
- **Autocompletion**: Fast completion with blink.cmp and additional sources
- **Syntax Highlighting**: Enhanced with Tree-sitter
- **Code Formatting**: Automatic formatting with conform.nvim
- **Linting**: Real-time linting with nvim-lint for languages without a good LSP
- **Debugging**: Debug Adapter Protocol support
- **Session Management**: Automatic session saving and restoration

### UI Enhancements

- **Modern Theme**: Tokyonight color scheme
- **Status Line**: Informative lualine configuration with several third-party modules
- **Buffer Management**: Enhanced buffer navigation
- **Git Integration**: Visual git status and hunks
- **Diagnostics**: Clear error and warning display

## Customization Guide

### Adding New Plugins

Add to the appropriate file in `lua/plugins/extras/` or `lua/plugins/languages/` (or any of the other paces of you want to edit core functionalities) or create a new one according to the `lazy.nvim` specifications.

### Adding Language Support

Language support in this configuration follows a modular approach where each language is configured in its own file under `lua/plugins/languages/`. This section provides comprehensive examples for adding complete language support including Treesitter, LSP, Linter, Formatter, and DAP configurations.

#### Basic Setup Steps

1. **Create Language File**: Add `lua/plugins/languages/mylang.lua`
2. **LSP Configuration**: The LSP will be auto-configured if available by `nvim-lspconfig`
3. **Linter/Formatter and language specific plugins** (if needed): add in the language file as well
4. **LSP Overrides** (if needed): Add `after/lsp/mylsp.lua`
5. **Filetype Settings** (if needed): Add `after/ftplugin/mylang.lua`

#### Complete Language Configuration Examples

Here are detailed examples showing how to configure each component:

##### Treesitter Configuration

Add syntax highlighting and text objects support:

```lua
-- Treesitter
{
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      "mylang",        -- Main language parser
      "mylang_extras", -- Additional parsers (if available)
    }
  },
},
```

##### LSP Configuration

Configure Language Server Protocol support:

```lua
-- LSP
{
  "neovim/nvim-lspconfig",
  opts = { servers = { "mylsp" } },
},
```

> [!NOTE]
> This config uses nvim-lspconfig to automatically detect and configure the LSP with sane, community maintained defaults. For custom configs see [LSP Configuration Overrides](#lsp-configuration-overrides) section below.

##### Formatter Configuration

Set up code formatting with conform.nvim:

```lua
-- Formatter
{
  "stevearc/conform.nvim",
  opts_extend = { "formatters_by_ft.mylang" }, -- important to convince lazy.nvim to merge this!
  opts = {
    formatters_by_ft = {
      mylang = { "my_formatter" }
    }
  },
},

-- Multiple formatters (run in sequence)
{
  "stevearc/conform.nvim",
  opts_extend = { "formatters_by_ft.mylang" },
  opts = {
    formatters_by_ft = {
      mylang = { "import_organizer", "my_formatter" }
    }
  },
},

-- Formatter with LSP fallback
{
  "stevearc/conform.nvim",
  opts_extend = { "formatters_by_ft.mylang" },
  opts = {
    formatters_by_ft = {
      mylang = { "my_formatter", lsp_format = "fallback" }
    }
  },
},
```

##### Linter Configuration

Configure linting with nvim-lint:

```lua
-- Linter
{
  "mfussenegger/nvim-lint",
  opts_extend = { "linters_by_ft.mylang" }, -- important to convince lazy.nvim to merge this!
  opts = {
    linters_by_ft = {
      mylang = { "my_linter" }
    }
  },
},
```

##### DAP (Debug Adapter Protocol) Configuration

Set up debugging support:

```lua
-- DAP
{
  "mfussenegger/nvim-dap",
  lazy = true,
  opts = function()
    local dap = require("dap")

    -- Configure adapter
    dap.adapters.mylang = {
      type = "executable",
      command = "my-debug-adapter",
      args = { "--stdio" },
      name = "mylang",
    }

    -- Configure launch configurations
    dap.configurations.mylang = {
      {
        type = "mylang",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        cwd = "${workspaceFolder}",
      },
      {
        type = "mylang",
        request = "attach",
        name = "Attach to process",
        pid = require("dap.utils").pick_process,
        cwd = "${workspaceFolder}",
      },
    }
  end,
},

-- Language-specific DAP plugin
{
  "author/nvim-dap-mylang",
  ft = "mylang",
  dependencies = { "mfussenegger/nvim-dap" },
  keys = {
    {
      "<leader>dT",
      function()
        require("dap-mylang").debug_test()
      end,
      desc = "Debug Test",
      ft = "mylang",
    },
  },
  config = function()
    require("dap-mylang").setup({
      -- Plugin-specific configuration
    })
  end,
},
```

##### Complete Language File Example

Here's a comprehensive example combining all components:

```lua
return {
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "mylang" } },
  },

  -- LSP
  -- Installation: brew install my-language-server
  -- OR: mise use -g my-language-server@latest
  {
    "neovim/nvim-lspconfig",
    opts = { servers = { "mylsp" } },
  },

  -- Formatter
  -- Installation: brew install my-formatter
  -- OR: mise use -g my-formatter@latest
  {
    "stevearc/conform.nvim",
    opts_extend = { "formatters_by_ft.mylang" },
    opts = { formatters_by_ft = { mylang = { "my_formatter" } } },
  },

  -- Linter
  -- Installation: brew install my-linter
  -- OR: mise use -g my-linter@latest
  {
    "mfussenegger/nvim-lint",
    opts_extend = { "linters_by_ft.mylang" },
    opts = { linters_by_ft = { mylang = { "my_linter" } } },
  },

  -- DAP
  -- Installation: brew install my-debugger
  -- OR: mise use -g my-debugger@latest
  {
    "mfussenegger/nvim-dap",
    opts = function()
      local dap = require("dap")
      dap.adapters.mylang = {
        type = "executable",
        command = "my-debug-adapter",
      }
      dap.configurations.mylang = {
        {
          type = "mylang",
          request = "launch",
          name = "Launch file",
          program = "${file}",
        },
      }
    end,
  },

  -- Language-specific plugins
  {
    "author/mylang-plugin",
    ft = { "mylang" },
    keys = {
      {
        "<leader>cr",
        "<cmd>MyLangRun<cr>",
        desc = "Run Code",
        ft = "mylang",
      },
    },
    opts = {
      -- Plugin-specific configuration
    },
  },
}
```

#### Installation Comments

Each tool configuration includes installation comments showing how to install the required external tools using either Homebrew or Mise. This helps users understand the dependencies and how to install them.

#### Key Configuration Patterns

1. **`opts_extend`**: Essential for formatters and linters to ensure proper merging of nested configuration tables
2. **Filetype restrictions**: Use `ft = { "mylang" }` to load plugins only for specific file types
3. **Lazy loading**: Most language-specific plugins are automatically lazy-loaded by filetype
4. **Keymaps**: Language-specific keymaps should include `ft` restrictions
5. **Installation notes**: Include comments showing how to install external dependencies

### LSP Configuration Overrides

To override LSP settings for specific servers, create a file in `after/lsp/`:

```lua
-- after/lsp/mylsp.lua
return {
  on_attach = function(client, bufnr)
    -- Custom keymaps or client-specific setup
    -- For example:
    vim.keymap.set("n", "<localleader>m", function()
      do_stuff()
    end, { desc = "Pin Main" })
  end,
  settings = {
    -- LSP-specific settings
  },
}
```

### Custom Keymaps

Add global keymaps in `lua/config/keymaps.lua`:

```lua
local map = vim.keymap.set
map("n", "<leader>mc", "<cmd>MyCommand<cr>", { desc = "My Custom Command" })
```

For plugin-specific or filetype-specific keymaps, add them in the respective plugin file or ftplugin file.

### Options and Settings

Modify Neovim options in `lua/config/options.lua`:

```lua
vim.opt.my_option = "value"
vim.g.my_global = true
```

## Design Philosophy

This configuration follows several key principles:

1. **Modularity**: Each feature is self-contained and can be easily modified or disabled
2. **Performance**: Lazy loading and optimized startup time
3. **Consistency**: Unified approach to keybindings and UI elements
4. **Extensibility**: Easy to add new languages and tools
5. **Documentation**: Clear structure and comprehensive documentation

## Custom functionality

This configuration includes some custom functionality coded inside this config (not available as plugins):

- **BasedPyright Dynamic Toggle**: Live switching between basic and strict type checking modes with inlay hints toggle without LSP restart (`lsp_utils.toggle_basedpyright_settings()`) with `<Leader>cb`
- **YAML Schema Validation**: Validate YAML files with custom schema loading from `.yamlls.extra.lua` files and live schema store toggle (`lsp_utils.toggle_yaml_schema_store()`) with `<Leader>uy`. Custom schema file declaration can be achieved using for example

```lua
-- .yamlls.extra.lua
return {
  {
    name = "Project Config",
    description = "Schema for project-specific configuration",
    fileMatch = { "**/config/**/*.projectconfig.yaml" },
    url = "./projectconfig.schema.json",
  },
}
```

- **Intelligent Spell Language Detection**: Automatic spell language switching for LaTeX and Typst documents based on content patterns in the first N lines (e.g., German language package imports) by matching patterns, includes caching via lua meta-tables, easily configurable and extensible for other document types by modifying existing or adding new autocmds to `lua/config/autocmds.lua`
- **PostgreSQL Dialect switching**: Additionally activate the `postgres_lsp` on demand with `<Leader>cp`. The `sqlls` LSP is used as a basis and you can specifically turn in a Postgres LSP (providing much better support), since it is impossible to distinguish dialects.
- **Project Root Detection**: Smart project and git root discovery functions for consistent workspace navigation (`helpers.project_root()`, `helpers.git_root()`)
- **Filetype-Aware UI Components**: Conditional lualine components with filetype-based visibility logic for cleaner status line management (`ft_helpers.is_ft()`, `ft_helpers.is_not_ft()`)

## Prerequisites

1. **Prerequisites**:
   - Neovim 0.11+ required (this config uses the new `vim.lsp` API)
   - Git
   - a [Nerd Font](https://www.nerdfonts.com/)
   - Treesitter CLI
   - a C compiler for nvim-treesitter. See [here](https://github.com/nvim-treesitter/nvim-treesitter#requirements)
   - [luarocks](https://www.lua.org/start.html#installing)
   - curl for [blink.cmp](https://github.com/Saghen/blink.cmp) (completion engine)
   - [fzf](https://github.com/junegunn/fzf)
   - [ripgrep](https://github.com/BurntSushi/ripgrep)
   - [fd](https://github.com/sharkdp/fd)
   - [lazygit](https://github.com/jesseduffield/lazygit) (optional)
2. **Third-party tools for preconfigured languages**:
   - **Package Manangers:**
     - npm
     - pipx
   - **LSPs:**
     - **ruff** - Python LSP and linter (`brew install ruff` or `mise use -g ruff@latest`)
     - **basedpyright** - Python type checker (`brew install basedpyright` or `mise use -g pipx:basedpyright@latest`)
     - **clangd** - C/C++ LSP (`brew install llvm` or `mise use -g clang@latest`)
     - **lua-language-server** - Lua LSP (`brew install lua-language-server` or `mise use -g lua-language-server@latest`)
     - **marksman** - Markdown LSP (`brew install marksman` or `mise use -g marksman@latest`)
     - **vscode-langservers-extracted** - JSON LSP (`brew install vscode-langservers-extracted` or `mise use -g npm:vscode-langservers-extracted@latest`)
     - **emmet-ls** - Emmet LSP for HTML/CSS expansion (`mise use -g npm:emmet-ls@latest`)
     - **tailwindcss-language-server** - Tailwind CSS LSP (optional) (`mise use -g npm:@tailwindcss/language-server@latest`)
     - **angular-language-server** - Angular LSP (`mise use -g npm:@angular/language-server@latest`)
     - **jsonlint** - JSON linting (`brew install jsonlin` or `mise use -g npm:jsonlint@latest`)
     - **yaml-language-server** - YAML LSP (`brew install yaml-language-server` or `mise use -g npm:yaml-language-server@latest`)
     - **tinymist** - Typst LSP (`brew install tinymist` or `mise use -g aqua:Myriad-Dreamin/tinymist@latest`)
     - **texlab** - LaTeX LSP (`brew install texlab` or `mise use -g ubi:latex-lsp/texlab@latest`)
     - **fish-lsp** - Fish shell LSP (`brew install fish-lsp` or `mise use -g npm:fish-lsp@latest`)
     - **postgres_lsp** - PostgreSQL LSP (`mise use -g npm:@postgrestools/postgrestools@latest`)
     - **sql-language-server** - SQL LSP (`brew install sql-language-server` or `mise use -g npm:sql-language-server@latest`)
     - **vtsls** - vtsls typescript LSP (`mise use -g npm:@vtsls/language-server@latest`)
   - **Formatters:**
     - **stylua** - Lua formatter (`brew install stylua` or `mise use -g stylua@latest`)
     - **prettierd/prettier** - Markdown formatter (`brew install prettier prettierd` or `mise use -g npm:@fsouza/prettierd@latest`)
     - **typstyle** - Typst formatter (`brew install typstyle` or `mise use -g aqua:Enter-tainer/typstyle@latest`)
     - **fish_indent** - Fish formatter (comes with fish shell)
     - **taplo** - TOML formatter (`brew install taplo` or `mise use -g taplo@latest`)
     - **sqlfluff** - SQL Formatter (`brew install sqlfluff` or `mise use -g pipx:sqlfluff@latest`)
     - **biome** - Fast JS/TS/JSON formatter and linter (`brew install biome` or `mise use -g npm:@biomejs/biome@latest`)
     - **eslint_d** - Fast ESLint daemon (`mise use -g npm:eslint_d@latest`)
   - **Linters:**
     - **fish** - Fish shell linter (comes with fish shell)
   - **Debug Adapters:**
     - **debugpy** - Python debugger (`mise use -g pipx:debugpy@latest`)
     - **lldb-dap** - C/C++ debugger (comes with LLVM or Xcode)
   - **Test runners:**
     - **pytest** - Python testing (used by neotest-python)
     - **jest** - JavaScript/TypeScript testing (used by neotest-jest)
   - **Development servers:**
     - **live-server** - HTML development server (`mise use -g npm:live-server@latest`)
   - **Additional Tools:**
     - **ipython** - Interactive Python REPL (`brew install ipython` or `mise use -g pipx:ipython@latest`)
     - **mcp-hub** - MCP Hub management and server interface (`mise use -g npm:mcp-hub@latest`)
     - **vectorcode** - used by CodeCompanion, provides efficient codebase indexing (`uv tool install "vectorcode<1.0.0"` or `mise use -g pipx:vectorcode@latest`)
     - **pplatex** - latex error parsing (optional, for vimtex)
     - **uv** - python package manager (used by dap-python for auto-detection)
     - **typescript** - TypeScript compiler (`brew install typescript` or `mise use -g npm:typescript@latest`)

### Install basic prerequisites

> [!NOTE]
> It is generally recommended to use a system package manager like apt or homebrew for the basic tools where versioning is not important for development!

Using homebrew:

```bash
brew install neovim
brew install git
brew install luarocks
brew install gcc  # or use xcode-select --install for macOS
brew install curl
brew install tree-sitter
brew install fzf
brew install ripgrep
brew install fd
brew install lazygit
```

You can also use mise, but at least some of the basic tools are _not_ available. Also, these packages are not that relevant to versioning so it is advised to use a system package manager like homebrew:

> [!WARNING]
> git, gcc and curl are not available with mise!

```bash
mise use -g neovim@latest
mise use -g tree-sitter@latest
mise use -g fzf@latest
mise use -g ripgrep@latest
mise use -g fd@latest
mise use -g lazygit@latest
```

### Install all third-party dependencies at once

Other than basic packages, the following might be relevant to versioning, for example formatters, so it is advised to use something like mise to be able to have consistent tooling across projects.

> [!WARNING]
> Postgrestools and debugpy are not available with homebrew! Recommended install method for vectorcode is uv!

```bash
brew install ruff basedpyright llvm lua-language-server marksman vscode-langservers-extracted jsonlint yaml-language-server tinymist texlab fish-lsp sql-language-server stylua prettier prettierd typstyle taplo sqlfluff biome typescript ipython
uv tool install "vectorcode<1.0.0"
```

```bash
mise use -g ruff@latest pipx:basedpyright@latest clang@latest lua-language-server@latest marksman@latest npm:vscode-langservers-extracted@latest npm:emmet-ls@latest npm:@tailwindcss/language-server@latest npm:@tailwindcss/language-server@latest npm:@angular/language-server@latest npm:jsonlint@latest npm:yaml-language-server@latest aqua:Myriad-Dreamin/tinymist@latest ubi:latex-lsp/texlab@latest npm:fish-lsp@latest npm:@postgrestools/postgrestools@latest npm:sql-language-server@latest npm:@vtsls/language-server@latest stylua@latest npm:@fsouza/prettierd@latest aqua:Enter-tainer/typstyle@latest taplo@latest pipx:sqlfluff@latest npm:@biomejs/biome@latest npm:eslint_d@latest pipx:debugpy@latest npm:live-server@latest npm:typescript@latest pipx:ipython@latest npm:mcp-hub@latest
```

## Troubleshooting

### Plugin Issues

1. Check `<Leader>l` or `:Lazy` for plugin status
2. Run `:Lazy clean` to remove unused plugins
3. Run `:Lazy sync` to update all plugins

### LSP Issues

1. Check `<Leader>cl` or `:LspInfo` for server status
2. Verify language servers are installed
3. Check `after/lsp/` files for custom configurations

### Formatter Issues

1. Check `<Leader>cc` or `:ConformInfo` for formatter status
2. Verify formatters are installed

### Performance Issues

1. Use `:Lazy profile` to identify slow plugins
2. Check startup time with `nvim --startuptime startup.log`

## Notes

- The configuration automatically installs Lazy.nvim on first run
- Plugin versions are locked in `lazy-lock.json` for reproducibility
- LSP servers are automatically configured when available
- The configuration supports both local and remote development (SSH)
