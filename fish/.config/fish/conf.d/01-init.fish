# fix missing fzf key bindings
source $HOME/.config/fish/functions/fzf_configure_bindings.fish

# fix missing functions - DISABLED to prevent funcsave spam from fish-eza plugin
# for file in $HOME/.config/fish/functions/*.fish
#     source $file
# end

# fix missing user functions
set -gx fish_function_path $HOME/.config/fish/functions/my_functions $fish_function_path
for file in $HOME/.config/fish/functions/my_functions/*.fish
    source $file
end
