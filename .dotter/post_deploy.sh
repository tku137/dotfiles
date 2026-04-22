#!/bin/bash
# post_deploy.sh is rendered as a Handlebars template by dotter.
# Sections are conditionally included based on which packages are selected
# in local.toml, using the dotter.packages built-in variable.
# Section headers and warnings are always shown. Tool stdout is suppressed; errors are not.

# Make mise-installed tools (shims) available without shell activation.
# Dotter runs hooks via sh/bash without sourcing user shell configs.
export PATH="$HOME/.local/share/mise/shims:$HOME/.local/bin:$PATH"

{{#if dotter.packages.fish}}
echo "[fish]"
if ! command -v fish &>/dev/null; then
  echo "  WARNING: fish not found."
else
  if fish -c "type -q fisher"; then
    echo "  Updating plugins via fisher..."
    fish -c "fisher update" 2>&1 >/dev/null
  else
    echo "  fisher not available, skipping plugin update."
  fi
fi
{{/if}}

{{#if dotter.packages.starship}}
echo "[starship]"
{{#if (is_executable "mise")}}
echo "  Installing starship via mise..."
mise --quiet use -g starship@latest 2>&1 >/dev/null
{{else}}
echo "  WARNING: mise not found, starship not installed. See https://starship.rs/"
{{/if}}
{{/if}}

{{#if dotter.packages.tools}}
echo "[tools]"
{{#if (is_executable "mise")}}
echo "  Installing tools via mise..."
mise --quiet use -g bat@latest btop@latest eza@latest fd@latest fzf@latest ripgrep@latest zoxide@latest 2>&1 >/dev/null
echo "  Rebuilding bat cache..."
bat cache --build 2>&1 >/dev/null
{{else}}
echo "  WARNING: mise not found, skipping tool installation."
{{/if}}
{{/if}}

# WARNING: this mise tool list is mirrored in nvim/README.md, update both!
{{#if dotter.packages.nvim}}
echo "[nvim]"
{{#if (is_executable "mise")}}
echo "  Installing neovim via mise..."
mise --quiet use -g neovim@latest 2>&1 >/dev/null
echo "  Installing node and python runtimes via mise..."
mise --quiet use -g node@latest python@latest 2>&1 >/dev/null
echo "  Installing tool prerequisites via mise..."
mise --quiet use -g ruff@latest pipx:basedpyright@latest lua-language-server@latest marksman@latest npm:vscode-langservers-extracted@latest npm:emmet-ls@latest npm:@tailwindcss/language-server@latest npm:@angular/language-server@latest npm:jsonlint@latest npm:yaml-language-server@latest aqua:Myriad-Dreamin/tinymist@latest github:latex-lsp/texlab@latest npm:fish-lsp@latest npm:@postgrestools/postgrestools@latest npm:sql-language-server@latest npm:@vtsls/language-server@latest stylua@latest npm:@fsouza/prettierd@latest aqua:Enter-tainer/typstyle@latest taplo@latest pipx:sqlfluff@latest npm:@biomejs/biome@latest npm:eslint_d@latest pipx:debugpy@latest npm:live-server@latest npm:typescript@latest pipx:ipython@latest 2>&1 >/dev/null
{{else}}
echo "  mise not found, skipping tool prerequisites."
{{/if}}
{{/if}}

{{#if dotter.packages.tmux}}
echo "[tmux]"
{{#if (is_executable "mise")}}
echo "  Installing tmux via mise..."
mise --quiet use -g tmux@latest 2>&1 >/dev/null
echo "  Installing tpack..."
mise --quiet use -g github:tmuxpack/tpack@latest 2>&1 >/dev/null
if command -v tpack &>/dev/null; then
  echo "  Installing plugins via tpack..."
  # swallow tmux-powerkit download errors (vibe-coded stuff...), it works anyways
  tmux start-server \; \
    source-file "$HOME/.config/tmux/tmux.conf" \; \
    run-shell "tpack install" \; \
    kill-server 2>&1 >/dev/null || true
else
  echo "  tpack not available, skipping plugin install (will run on first tmux launch)."
fi
{{else}}
echo "  mise not found, skipping tmux setup."
{{/if}}
{{/if}}

{{#if dotter.packages.ghostty}}
echo "[ghostty]"
if ! command -v ghostty &>/dev/null; then
  echo "  WARNING: ghostty not found."
fi
{{/if}}

{{#if dotter.packages.zellij}}
echo "[zellij]"
{{#if (is_executable "mise")}}
echo "  Installing zellij via mise..."
mise --quiet use -g zellij@latest 2>&1 >/dev/null
{{else}}
echo "  WARNING: mise not found, skipping zellij installation."
{{/if}}
{{/if}}

{{#if (is_executable "mise")}}
echo "[mise] Pruning old versions..."
mise --quiet prune --yes 2>&1 >/dev/null
{{/if}}
