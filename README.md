# Dotfiles

Dotter-managed dotfiles for macOS and Linux.

Each top-level directory is a dotter package. Packages define file mappings and template variables in `.dotter/global.toml`. Machine-specific package selection and variable overrides live in `.dotter/local.toml` (gitignored).

## Prerequisites

- [mise](https://mise.jdx.dev/) — runtime manager used to install dotter and all tools
- [fish](https://fishshell.com/) — install via your system package manager
- `git`, `curl`, a C compiler — install via your system package manager

## Quick start

On a fresh machine, run the bootstrap script first:

```bash
git clone git@github.com:tku137/dotfiles.git ~/dotfiles
cd ~/dotfiles
bash setup.sh
```

`setup.sh` checks system dependencies, installs mise and dotter, and creates a `.dotter/local.toml` template for you.

Edit `.dotter/local.toml` and uncomment your machine profile, then preview and deploy:

```bash
dotter deploy --dry-run -v
dotter deploy
```

If existing files conflict, force overwrite:

```bash
dotter deploy --force
```

## Packages

| Package  | Description                                             | Dependencies               |
| -------- | ------------------------------------------------------- | -------------------------- |
| shell    | Meta-package for the terminal shell environment         | fish, git, starship, tools |
| tools    | CLI & utility tools (bat, btop, eza, fd, fzf, rg, lua)  | —                          |
| fish     | Fish shell config                                       | —                          |
| git      | Git config                                              | —                          |
| starship | Starship prompt                                         | —                          |
| terminal | Shared font variables (no files)                        | —                          |
| nvim     | Neovim configuration                                    | tools                      |
| zed      | Zed editor configuration                                | —                          |
| mcphub   | MCP Hub config                                          | —                          |
| ghostty  | Ghostty terminal emulator                               | terminal                   |
| wezterm  | WezTerm terminal emulator                               | terminal                   |
| tmux     | tmux multiplexer                                        | —                          |
| zellij   | Zellij multiplexer                                      | —                          |
| amethyst | Amethyst tiling window manager                          | —                          |
| headless | Meta-package for headless/server machines               | shell, tmux, nvim          |
| desktop  | Meta-package for personal desktop                       | headless, ghostty          |

`shell` bundles your entire terminal environment (fish + git + starship + tools). `headless` and `desktop` are the two machine-type meta-packages you actually select in `local.toml` — everything else is pulled in transitively.

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
packages = ["desktop", "zellij"]
```

You don't need to list dependency packages explicitly — `desktop` pulls in `headless`, which pulls in `shell`, `tmux`, and `nvim` automatically.

### Overriding variables

To override any variable defined in `global.toml`, add a
`[<package>.variables]` section:

```toml
packages = ["desktop", "zellij"]

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

| Package  | What runs                                                                                                                                                                                                                      |
| -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| tools    | Installs `bat`, `btop`, `eza`, `fd`, `fzf`, `ripgrep`, `lua` (+ luarocks) via `mise use -g`, then runs `mise prune --yes` and `bat cache --build`. Warns if `mise` is not on PATH.                                             |
| nvim     | Warns if `nvim` binary missing (with install link). Installs all Neovim tool prerequisites via `mise use -g` (LSP servers, formatters, linters, DAP adapters), then runs `mise prune --yes`. Skipped if `mise` is not on PATH. |
| fish     | Warns if `fish` binary missing. Runs `fisher update` to install/sync fish plugins from `fish_plugins`. Skipped if `fisher` is not available.                                                                                   |
| tmux     | Warns if `tmux` binary missing. Installs `tpack` via mise (then prunes), runs `tpack install` inside a headless tmux server. Skipped if `mise` is not on PATH.                                                                 |
| starship | Warns if `starship` binary missing (with install link).                                                                                                                                                                        |
| ghostty  | Warns if `ghostty` binary missing (with install link).                                                                                                                                                                         |

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
