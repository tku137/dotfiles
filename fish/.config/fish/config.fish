if status is-interactive
    # Commands to run in interactive sessions can go here
end
starship init fish | source
direnv hook fish | source
fzf_configure_bindings --directory=\cf

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /usr/local/anaconda3/bin/conda
    eval /usr/local/anaconda3/bin/conda "shell.fish" "hook" $argv | source
end
# <<< conda initialize <<<

