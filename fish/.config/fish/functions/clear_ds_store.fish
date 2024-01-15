function clear_ds_store --description 'Remove all .DS_Store files from the specified directory or current directory if none specified'
    set target_dir $argv[1]
    set display_dir $target_dir  # Variable for display

    if test -z "$target_dir"
        set target_dir .
        set display_dir (pwd)  # Set to the full path of the current directory
    end

    echo "Removing .DS_Store files from $display_dir..."
    find $target_dir -name .DS_Store -print0 | xargs -0 rm
    echo ".DS_Store files removed from $display_dir."
end

function cds --description 'Alias for clear_ds_store'
    clear_ds_store $argv
end

