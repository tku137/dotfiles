if status is-interactive
    # Commands to run in interactive sessions can go here
end
starship init fish | source
direnv hook fish | source
fzf_configure_bindings --directory=\cf
zoxide init fish | source

