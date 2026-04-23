# Dotfiles

Dotter-managed dotfiles for macOS and Linux.

Each top-level directory is a dotter package. Packages define file mappings and template variables in `.dotter/global.toml`. Machine-specific package selection and variable overrides live in `.dotter/local.toml` (gitignored).

## Requirements

Install these manually per machine, methods vary by OS, so there's no bootstrap script (impossible to capture all platforms/archs and lots of hen-egg-problems). Use your system package manager (`apt`, `dnf`, `pacman`, `brew`, …) unless a link below says otherwise.

- `git` — to clone this repo
- `curl` — used by tool installers and deploy hooks
- [fish](https://fishshell.com/) — the shell this config targets
- [mise](https://mise.jdx.dev/) — runtime manager; installs node, python, neovim, LSPs, and many CLI tools via the post-deploy hook
- [dotter](https://github.com/SuperCuber/dotter) — the deploy tool itself (see below)

### Installing dotter

Pick whichever is easiest on your machine:

- **Homebrew** (macOS, Linuxbrew):

  ```bash
  brew install dotter
  ```

- **mise** (once mise is installed _and activated!_):

  ```bash
  mise use -g github:SuperCuber/dotter@latest
  ```

- **Prebuilt binary** — pick the right asset for your OS/arch from [dotter releases](https://github.com/SuperCuber/dotter/releases):

  ```bash
  curl -L https://github.com/SuperCuber/dotter/releases/latest/download/dotter-linux-x64-musl \
    -o ~/.local/bin/dotter && chmod +x ~/.local/bin/dotter
  ```

> [!TIP]
> Some packages have their own README with additional per-machine notes. For example, `nvim/README.md` lists additional requirements and also all the LSP servers, formatters, and linters that get installed via mise on first deploy.

## Quick start

Install the [requirements](#requirements) first, then:

```bash
git clone git@github.com:tku137/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

Create `.dotter/local.toml` and pick your machine profile:

```toml
# Select your machine profile. Common setups:
#   headless — shell + tmux + nvim (server/remote machines)
#   desktop  — headless + ghostty (personal workstation)
#
# Add optional packages after the profile, e.g. ["desktop", "zellij"]

packages = ["headless"]
# packages = ["desktop", "zellij"]

# Override default variables defined in .dotter/global.toml:
#
# [git.variables]
# git_name  = "Your Name"
# git_email = "you@work.com"
#
# [terminal.variables]
# font_size = 14
```

Preview and deploy:

```bash
dotter deploy --dry-run -v   # preview
dotter deploy                # apply
dotter deploy --force        # overwrite conflicting existing files
```

## Packages

| Package  | Description                                               | Dependencies               |
| -------- | --------------------------------------------------------- | -------------------------- |
| shell    | Meta-package for the terminal shell environment           | fish, git, starship, tools |
| tools    | CLI & utility tools (bat, btop, eza, fd, fzf, rg, zoxide) | —                          |
| fish     | Fish shell config                                         | —                          |
| git      | Git config                                                | —                          |
| starship | Starship prompt                                           | —                          |
| terminal | Shared font variables (no files)                          | —                          |
| nvim     | Neovim configuration                                      | tools                      |
| zed      | Zed editor configuration                                  | —                          |
| mcphub   | MCP Hub config                                            | —                          |
| ghostty  | Ghostty terminal emulator                                 | terminal                   |
| wezterm  | WezTerm terminal emulator                                 | terminal                   |
| tmux     | tmux multiplexer                                          | —                          |
| zellij   | Zellij multiplexer                                        | —                          |
| amethyst | Amethyst tiling window manager                            | —                          |
| headless | Meta-package for headless/server machines                 | shell, tmux, nvim          |
| desktop  | Meta-package for personal desktop                         | headless, ghostty          |

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

| Package  | What runs                                                                                                                                                                                                           |
| -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| tools    | Installs `bat`, `btop`, `eza`, `fd`, `fzf`, `ripgrep`, `zoxide` via `mise use -g`, then runs `bat cache --build`. Warns if `mise` is not on PATH.                                                                   |
| nvim     | Installs `neovim`, `node`, `python` and all Neovim tool prerequisites (LSP servers, formatters, linters, DAP adapters) via `mise use -g`. Skipped if `mise` is not on PATH. See `nvim/README.md` for the full list. |
| fish     | Warns if `fish` binary missing. Runs `fisher update` to install/sync fish plugins from `fish_plugins`. Skipped if `fisher` is not available.                                                                        |
| tmux     | Installs `tmux` and `tpack` via mise, runs `tpack install` inside a headless tmux server. Skipped if `mise` is not on PATH.                                                                                         |
| starship | Installs `starship` via mise. Warns if `mise` is not on PATH.                                                                                                                                                       |
| zellij   | Installs `zellij` via mise. Warns if `mise` is not on PATH.                                                                                                                                                         |
| ghostty  | Warns if `ghostty` binary missing (with install link).                                                                                                                                                              |

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
