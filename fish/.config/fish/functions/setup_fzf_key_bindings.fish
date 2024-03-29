function fzf_key_bindings --description 'Set the correct path for fzf key bindings based on architecture'
    set -l arch (uname -m)

    switch $arch
        case 'x86_64'
            set fzf_path /usr/local/opt/fzf/shell/key-bindings.fish
        case 'arm64'
            set fzf_path /opt/homebrew/opt/fzf/shell/key-bindings.fish
        case '*'
            echo "Unsupported architecture: $arch"
            return 1
    end

    if test -f $fzf_path
        source $fzf_path
    else
        echo "fzf key bindings file not found at $fzf_path"
    end
end

# Call the function to ensure the key bindings are set
fzf_key_bindings

