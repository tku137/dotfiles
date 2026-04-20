# Dotfiles

Dotter-managed dotfiles for macOS and Linux.

Each top-level directory is a dotter package. Packages define file mappings and template variables in `.dotter/global.toml`. Machine-specific package selection and variable overrides live in `.dotter/local.toml` (gitignored).

## Prerequisites

- [dotter](https://github.com/SuperCuber/dotter) — install via `cargo install dotter` or your package manager
- [mise](https://mise.jdx.dev/) (optional) — runtime manager for Python, Node, Go, etc.

## Quick start

```bash
git clone git@github.com:tku137/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

Create `.dotter/local.toml` with the packages you want:

```toml
packages = ["core", "nvim", "ghostty", "tmux"]
```

Optional check:

```bash
dotter deploy --dry-run -v
```

Deploy:

```bash
dotter deploy
```

If existing files conflict with the deployment, use `--force` to overwrite them:

```bash
dotter deploy --force
```

## Packages

| Package  | Description                        | Dependencies                   |
| -------- | ---------------------------------- | ------------------------------ |
| core     | Meta-package for CLI tools         | fish, git, starship, bat, btop |
| fish     | Fish shell config                  | —                              |
| git      | Git config                         | —                              |
| starship | Starship prompt                    | —                              |
| bat      | bat config                         | —                              |
| btop     | btop config                        | —                              |
| terminal | Shared font variables (no files)   | —                              |
| nvim     | Neovim configuration               | —                              |
| zed      | Zed editor configuration           | —                              |
| mcphub   | MCP Hub config                     | —                              |
| ghostty  | Ghostty terminal emulator          | terminal                       |
| wezterm  | WezTerm terminal emulator          | terminal                       |
| tmux     | tmux multiplexer                   | —                              |
| zellij   | Zellij multiplexer                 | —                              |
| amethyst | Amethyst tiling window manager     | —                              |
| desktop  | Meta-package for personal desktop  | (fill in local.toml)           |
| headless | Meta-package for headless machines | (fill in local.toml)           |
| work     | Meta-package for work machines     | (fill in local.toml)           |

`core` is a convenience meta-package — selecting it in `local.toml` pulls in all five CLI tool packages via `depends`. You can also select them individually.

The remaining packages are kept in `global.toml` for reference but are not part of any standard setup: alacritty, kitty, hatch, ipython, iterm2, zsh.

## Template variables

Some config files contain `{{ variable }}` markers. Dotter auto-detects these and renders the file as a template during deploy. Templated files are copied to their target (not symlinked), so edits at the target location won't reflect back to the repo.

| Variable           | Default                | Defined in | Used by                             |
| ------------------ | ---------------------- | ---------- | ----------------------------------- |
| git_name           | Tony Fischer (tku137)  | git        | git/gitconfig                       |
| git_email          | tku137@mailbox.org     | git        | git/gitconfig                       |
| font_family        | AtkynsonMono Nerd Font | terminal   | ghostty/config, wezterm/wezterm.lua |
| font_size          | 16                     | terminal   | ghostty/config, wezterm/wezterm.lua |
| font_family_italic | Maple Mono NF          | terminal   | ghostty/config                      |

## local.toml setup

`.dotter/local.toml` is gitignored and must be created on each machine. At minimum it needs a `packages` field:

```toml
packages = ["core", "nvim", "ghostty", "tmux"]
```

You don't need to list dependency packages explicitly — selecting `ghostty` automatically pulls in `terminal`.

### Overriding variables

To override any variable defined in `global.toml`, add a
`[<package>.variables]` section:

```toml
packages = ["core", "nvim", "ghostty", "tmux"]

[terminal.variables]
font_size = 14

[git.variables]
git_email = "work@example.com"
```

This is useful for adjusting font sizes on high-DPI displays or using different git credentials on work machines.

## Hooks

Dotter runs `.dotter/pre_deploy.sh` before and `.dotter/post_deploy.sh` after every deploy. Both scripts are rendered as Handlebars templates, so they have access to all variables and built-ins.

`pre_deploy.sh` removes `.DS_Store` files from the repo before dotter walks directories.

`post_deploy.sh` runs package-specific setup steps using `{{#if dotter.packages.<name>}}` conditionals:

| Package  | What runs |
| -------- | --------- |
| nvim     | Warns if `nvim` binary missing (with install link). Installs all Neovim tool prerequisites via `mise use -g` (LSP servers, formatters, linters, DAP adapters), then runs `mise prune --yes`. Skipped if `mise` is not on PATH. |
| fish     | Warns if `fish` binary missing. Runs `fisher update` to install/sync fish plugins from `fish_plugins`. Skipped if `fisher` is not available. |
| tmux     | Warns if `tmux` binary missing. Installs `tpack` via mise (then prunes), runs `tpack install` inside a headless tmux server. Skipped if `mise` is not on PATH. |
| bat      | Warns if `bat` binary missing. Runs `bat cache --build` to apply the custom theme. |
| starship | Warns if `starship` binary missing (with install link). |
| btop     | Warns if `btop` binary missing (with install link). |
| ghostty  | Warns if `ghostty` binary missing (with install link). |

> [!WARNING]
> The mise tool list in `.dotter/post_deploy.sh` mirrors the one in `nvim/README.md`. If you add or remove a Neovim tool dependency, update both files.

## Common commands

```bash
dotter deploy            # deploy all packages from local.toml
dotter deploy --force    # deploy, overwriting existing files
dotter undeploy          # remove all deployed files
```

## Adding a new package

1. Create a directory for the package at the repo root.
2. Add a `[<name>]`, `[<name>.files]`, and optionally `[<name>.variables]` section in `.dotter/global.toml`.
3. Add the package name to `packages` in `.dotter/local.toml`.
4. Run `dotter deploy`.
