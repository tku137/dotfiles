#!/bin/bash
# post_deploy.sh is rendered as a Handlebars template by dotter.
# Sections are conditionally included based on which packages are selected
# in local.toml, using the dotter.packages built-in variable.

# WARNING: this list is mirrored in the nvim/README.md, update both!
#
{{#if dotter.packages.nvim}}
{{#if (is_executable "mise")}}
echo "==> Installing Neovim tool prerequisites via mise..."
mise use -g ruff@latest pipx:basedpyright@latest lua-language-server@latest marksman@latest npm:vscode-langservers-extracted@latest npm:emmet-ls@latest npm:@tailwindcss/language-server@latest npm:@angular/language-server@latest npm:jsonlint@latest npm:yaml-language-server@latest aqua:Myriad-Dreamin/tinymist@latest ubi:latex-lsp/texlab@latest npm:fish-lsp@latest npm:@postgrestools/postgrestools@latest npm:sql-language-server@latest npm:@vtsls/language-server@latest stylua@latest npm:@fsouza/prettierd@latest aqua:Enter-tainer/typstyle@latest taplo@latest pipx:sqlfluff@latest npm:@biomejs/biome@latest npm:eslint_d@latest pipx:debugpy@latest npm:live-server@latest npm:typescript@latest pipx:ipython@latest npm:mcp-hub@latest
{{else}}
echo "==> Skipping Neovim tool prerequisites: mise not found."
{{/if}}
{{/if}}

{{#if dotter.packages.core}}
if command -v fish &>/dev/null && fish -c "type -q fisher"; then
  echo "==> Updating fish plugins via fisher..."
  fish -c "fisher update"
else
  echo "==> Skipping fish plugin update: fisher not available."
fi
{{/if}}

{{#if dotter.packages.tmux}}
if [ -x "$HOME/.tmux/plugins/tpm/bin/install_plugins" ]; then
  echo "==> Installing tmux plugins via TPM..."
  "$HOME/.tmux/plugins/tpm/bin/install_plugins"
else
  echo "==> Skipping tmux plugin install: TPM not found (will auto-install on first tmux launch)."
fi
{{/if}}
