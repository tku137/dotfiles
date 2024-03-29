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


# set default fzf command options
# CTRL-/ to toggle small preview window to see the full command
# CTRL-Y to copy the command into clipboard using pbcopy
# export FZF_CTRL_R_OPTS="
#   --preview 'echo {}' --preview-window up:3:hidden:wrap
#   --bind 'ctrl-/:toggle-preview'
#   --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
#   --color header:italic
#   --header 'CTRL-Y: copy command to clipboard, CTRL-/: toggle preview window'"

# Preview file content using bat (https://github.com/sharkdp/bat)
# export FZF_CTRL_T_OPTS="
#   --preview 'bat --color=always --style=numbers --line-range=:500 {}'
#   --bind 'ctrl-/:change-preview-window(down|hidden|)'
#   --color header:italic
#   --header 'CTRL-/: toggle preview window'"

# Print tree structure in the preview window
# export FZF_ALT_C_OPTS="
#   --preview 'eza --tree --color --icons --git {}'
#   --bind 'ctrl-/:reload(eza --tree --color --icons --git --all)'
#   --color header:italic
#   --header 'CTRL-/: toggle hidden'"
