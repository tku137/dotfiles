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
function config_fzf_bindings --on-event fish_prompt
    fzf_configure_bindings --directory=\cf --variables=\e\cv
end
