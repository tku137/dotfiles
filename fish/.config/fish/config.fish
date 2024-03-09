if status is-interactive
    # Commands to run in interactive sessions can go here
end

starship init fish | source
zoxide init fish | source
direnv hook fish | source

# fix missing user functions
set -gx fish_function_path $HOME/.config/fish/functions/my_functions $fish_function_path
for file in $HOME/.config/fish/functions/my_functions/*.fish
    source $file
end

# set up fzf
# function config_fzf_bindings --on-event fish_prompt
#     fzf_configure_bindings --directory=\cf --variables=\e\cv
# end

# CTRL-/ to toggle small preview window to see the full command
# CTRL-Y to copy the command into clipboard using pbcopy
export FZF_CTRL_R_OPTS="
  --preview 'echo {}' --preview-window up:3:hidden:wrap
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --color header:italic
  --header 'CTRL-Y: copy command to clipboard, CTRL-/: toggle preview window'"

# Preview file content using bat (https://github.com/sharkdp/bat)
export FZF_CTRL_T_OPTS="
  --preview 'bat --color=always --style=numbers --line-range=:500 {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'
  --color header:italic
  --header 'CTRL-/: toggle preview window'"

# Print tree structure in the preview window
export FZF_ALT_C_OPTS="
  --preview 'eza --tree --color --icons --git {}'
  --bind 'ctrl-/:reload(eza --tree --color --icons --git --all)'
  --color header:italic
  --header 'CTRL-/: toggle hidden'"
