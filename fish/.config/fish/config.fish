# =============================================================================
# LANGUAGE AND LOCALE SETTINGS
# =============================================================================

set -gx LANG en_US.UTF-8

# =============================================================================
# INTERACTIVE SESSION SETUP
# =============================================================================

if status is-interactive
    # Commands to run in interactive sessions can go here

    # Disable fish greeting message
    set -g fish_greeting
end

# =============================================================================
# TOOL INITIALIZATION HOOKS
# =============================================================================

# Initialize zoxide
if type -q zoxide
    zoxide init fish | source
end

# Initialize direnv
if type -q direnv
    direnv hook fish | source
end

# Initialize starship
if type -q starship
    starship init fish --print-full-init >~/.cache/starship_init.fish
    source ~/.cache/starship_init.fish
end

# Initialize fzf
if type -q fzf
    fzf --fish | source
end

# Initialize mise
if type -q mise
    mise activate fish | source
end

# =============================================================================
# PACKAGE MANAGER SETUP
# =============================================================================

# Bootstrap fisher (fish plugin manager) if not installed
if not type -q fisher; and type -q curl
    echo "Installing fisher plugin manager..."
    curl -sL https://git.io/fisher | source
    if status is-interactive
        echo "Updating fisher plugins..."
        fisher update
    end
else if not type -q fisher
    echo "Warning: fisher not available and curl not found for installation"
end

# =============================================================================
# FZF CONFIGURATION
# =============================================================================

# Configure file preview with syntax highlighting (CTRL-T)
if type -q bat
    export FZF_CTRL_T_OPTS="
      --walker-skip .git,node_modules,target
      --preview 'bat -n --color=always {}'
      --bind 'ctrl-/:change-preview-window(down|hidden|)'"
else
    export FZF_CTRL_T_OPTS="
      --walker-skip .git,node_modules,target
      --preview 'cat {}'
      --bind 'ctrl-/:change-preview-window(down|hidden|)'"
end

# Configure directory preview with tree structure (ALT-C)
if type -q eza
    export FZF_ALT_C_OPTS="
      --preview 'eza --tree --color --icons --git {}'
      --bind 'ctrl-/:reload(eza --tree --color --icons --git --all)'
      --color header:italic
      --header 'CTRL-/: toggle hidden'"
else if type -q tree
    export FZF_ALT_C_OPTS="
      --preview 'tree -C {}'
      --bind 'ctrl-/:reload(tree -C -a)'
      --color header:italic
      --header 'CTRL-/: toggle hidden'"
else
    export FZF_ALT_C_OPTS="
      --preview 'ls -la {}'
      --color header:italic"
end

# =============================================================================
# PATH CONFIGURATION
# =============================================================================

# Homebrew paths (Apple Silicon macOS)
if test -d /opt/homebrew/bin
    fish_add_path /opt/homebrew/bin
end

if test -d /opt/homebrew/opt/fzf/bin
    fish_add_path /opt/homebrew/opt/fzf/bin
end

# Homebrew paths (Intel macOS)
if test -d /usr/local/bin
    fish_add_path /usr/local/bin
end

if test -d /usr/local/opt/fzf/bin
    fish_add_path /usr/local/opt/fzf/bin
end

# Linuxbrew paths (system-wide installation)
if test -d /home/linuxbrew/.linuxbrew/bin
    fish_add_path /home/linuxbrew/.linuxbrew/bin
end

if test -d /home/linuxbrew/.linuxbrew/opt/fzf/bin
    fish_add_path /home/linuxbrew/.linuxbrew/opt/fzf/bin
end

# Linuxbrew paths (user-specific installation)
if test -d $HOME/.linuxbrew/bin
    fish_add_path $HOME/.linuxbrew/bin
end

if test -d $HOME/.linuxbrew/opt/fzf/bin
    fish_add_path $HOME/.linuxbrew/opt/fzf/bin
end

# Local user binaries
if test -d $HOME/.local/bin
    fish_add_path $HOME/.local/bin
end

# =============================================================================
# ENVIRONMENT VARIABLES
# =============================================================================

# XDG Base Directory Specification
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_CACHE_HOME "$HOME/.cache"

# Hatch Python project manager configuration
set -gx HATCH_CONFIG "$XDG_CONFIG_HOME/hatch/config.toml"

# =============================================================================
# PYTHON VERSION MANAGEMENT
# =============================================================================

# pyenv (Python version manager)
if type -q pyenv
    set -gx PYENV_ROOT $HOME/.pyenv
    fish_add_path $PYENV_ROOT/bin

    if status --is-interactive
        pyenv init --path | source
        pyenv init - | source
    end
end

# =============================================================================
# MACOS-SPECIFIC FIXES
# =============================================================================

# Fix libgit2 dynamic library loading issues on macOS
if test -d /usr/local/opt/libgit2/lib
    set -x DYLD_LIBRARY_PATH /usr/local/opt/libgit2/lib $DYLD_LIBRARY_PATH
else if test -d /opt/homebrew/opt/libgit2/lib
    set -x DYLD_LIBRARY_PATH /opt/homebrew/opt/libgit2/lib $DYLD_LIBRARY_PATH
end

# =============================================================================
# THEME CONFIGURATION
# =============================================================================

# Set fish shell theme
fish_config theme choose "TokyoNight Moon"
