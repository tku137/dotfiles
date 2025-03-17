if status is-interactive
    # Commands to run in interactive sessions can go here
end

# init hooks
if type -q zoxide
    zoxide init fish | source
end

if type -q direnv
    direnv hook fish | source
end

if type -q starship
    starship init fish | source
end

if type -q fzf
    fzf --fish | source
end

# Bootstrap Fisher if not installed
if not type -q fisher
    curl -sL https://git.io/fisher | source
end

# set default fzf command options

# Preview file content using bat (https://github.com/sharkdp/bat)
export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

# Print tree structure in the preview window
export FZF_ALT_C_OPTS="
  --preview 'eza --tree --color --icons --git {}'
  --bind 'ctrl-/:reload(eza --tree --color --icons --git --all)'
  --color header:italic
  --header 'CTRL-/: toggle hidden'"

# set homebrew paths
if test -d /opt/homebrew/bin
    fish_add_path /opt/homebrew/bin
end

if test -d /opt/homebrew/opt/fzf/bin
    fish_add_path /opt/homebrew/opt/fzf/bin
end

# fix libgit2 dyld path on intel macs
set -x DYLD_LIBRARY_PATH /usr/local/opt/libgit2/lib $DYLD_LIBRARY_PATH

# set XDG home directories
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_CACHE_HOME "$HOME/.cache"

# set hatch config path
set -gx HATCH_CONFIG "$XDG_CONFIG_HOME/hatch/config.toml"

# set pyenv paths
set -gx PYENV_ROOT $HOME/.pyenv
set -gx PATH $PYENV_ROOT/bin $PATH

status --is-interactive; and . (pyenv init --path | psub)
status --is-interactive; and . (pyenv init - | psub)

# Created by `pipx` on 2024-06-19 15:38:03
set PATH $PATH /Users/tku137/.local/bin

# Created by `userpath` on 2024-09-19 16:09:46
set PATH $PATH /Users/tku137/.local/share/hatch/pythons/3.11/python/bin

# Set theme
fish_config theme choose "TokyoNight Moon"
