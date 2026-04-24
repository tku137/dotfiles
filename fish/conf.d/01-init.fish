# =============================================================================
# Custom user functions
# =============================================================================

# Add custom function directory to fish_function_path so they are autoloaded
if not contains $HOME/.config/fish/functions/my_functions $fish_function_path
    set -gp fish_function_path $HOME/.config/fish/functions/my_functions
end
