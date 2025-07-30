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
# PATH CONFIGURATION
# =============================================================================

# fish_add_path ignores missing dirs and removes duplicates automatically
for p in /opt/homebrew/bin \
    /opt/homebrew/opt/fzf/bin \
    /usr/local/bin \
    /usr/local/opt/fzf/bin \
    /home/linuxbrew/.linuxbrew/bin \
    /home/linuxbrew/.linuxbrew/opt/fzf/bin \
    $HOME/.linuxbrew/bin \
    $HOME/.linuxbrew/opt/fzf/bin \
    $HOME/.local/bin
    fish_add_path $p
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
# MACOS-SPECIFIC FIXES
# =============================================================================

# Fix libgit2 dynamic library loading issues on macOS
# Only apply tweaks when running on macOS
switch (uname)
    case Darwin
        if test -d /usr/local/opt/libgit2/lib
            set -x DYLD_LIBRARY_PATH /usr/local/opt/libgit2/lib $DYLD_LIBRARY_PATH
        else if test -d /opt/homebrew/opt/libgit2/lib
            set -x DYLD_LIBRARY_PATH /opt/homebrew/opt/libgit2/lib $DYLD_LIBRARY_PATH
        end
end

# =============================================================================
# THEME CONFIGURATION
# =============================================================================

# Set fish shell theme
fish_config theme choose "TokyoNight Moon"
