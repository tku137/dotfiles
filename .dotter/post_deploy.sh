#!/bin/bash
# post_deploy.sh is rendered as a Handlebars template by dotter.
# Sections are conditionally included based on which packages are selected
# in local.toml, using the dotter.packages built-in variable.

{{#if dotter.packages.fish}}
if ! command -v fish &>/dev/null; then
  echo "==> WARNING: fish not found."
else
  if fish -c "type -q fisher"; then
    echo "==> Updating fish plugins via fisher..."
    fish -c "fisher update"
  else
    echo "==> Skipping fish plugin update: fisher not available."
  fi
fi
{{/if}}

{{#if dotter.packages.starship}}
if ! command -v starship &>/dev/null; then
  echo "==> WARNING: starship not found."
fi
{{/if}}

{{#if dotter.packages.bat}}
if ! command -v bat &>/dev/null; then
  echo "==> WARNING: bat not found."
else
  echo "==> Rebuilding bat cache to apply theme..."
  bat cache --build
fi
{{/if}}

{{#if dotter.packages.btop}}
if ! command -v btop &>/dev/null; then
  echo "==> WARNING: btop not found."
fi
{{/if}}

# WARNING: this mise tool list is mirrored in nvim/README.md, update both!
{{#if dotter.packages.nvim}}
if ! command -v nvim &>/dev/null; then
  echo "==> WARNING: nvim not found."
fi
{{#if (is_executable "mise")}}
echo "==> Installing Neovim tool prerequisites via mise..."
mise use -g ruff@latest pipx:basedpyright@latest lua-language-server@latest marksman@latest npm:vscode-langservers-extracted@latest npm:emmet-ls@latest npm:@tailwindcss/language-server@latest npm:@angular/language-server@latest npm:jsonlint@latest npm:yaml-language-server@latest aqua:Myriad-Dreamin/tinymist@latest github:latex-lsp/texlab@latest npm:fish-lsp@latest npm:@postgrestools/postgrestools@latest npm:sql-language-server@latest npm:@vtsls/language-server@latest stylua@latest npm:@fsouza/prettierd@latest aqua:Enter-tainer/typstyle@latest taplo@latest pipx:sqlfluff@latest npm:@biomejs/biome@latest npm:eslint_d@latest pipx:debugpy@latest npm:live-server@latest npm:typescript@latest pipx:ipython@latest
echo "==> Pruning old Neovim tool versions via mise..."
mise prune --yes
{{else}}
echo "==> Skipping Neovim tool prerequisites: mise not found."
{{/if}}
{{/if}}

{{#if dotter.packages.tmux}}
if ! command -v tmux &>/dev/null; then
  echo "==> WARNING: tmux not found."
fi
{{#if (is_executable "mise")}}
echo "==> Installing tpack via mise..."
mise use -g github:tmuxpack/tpack@latest
echo "==> Pruning old tpack versions via mise..."
mise prune --yes
if command -v tpack &>/dev/null; then
  echo "==> Installing tmux plugins via tpack..."
  # swallow tmux-powerkit download errors (vibe-coded stuff...), it works anyways
  tmux start-server \; \
    source-file "$HOME/.config/tmux/tmux.conf" \; \
    run-shell "tpack install" \; \
    kill-server || true
else
  echo "==> Skipping tmux plugin install: tpack not available (will install on first tmux launch)."
fi
{{else}}
echo "==> Skipping tmux setup: mise not found."
{{/if}}
{{/if}}

{{#if dotter.packages.ghostty}}
if ! command -v ghostty &>/dev/null; then
  echo "==> WARNING: ghostty not found."
fi
{{/if}}
