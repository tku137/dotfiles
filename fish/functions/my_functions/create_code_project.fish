function create_code_project --description "Initializes a new code project with essential files and directories."
    # Initializes a new code project structure with customizable options. This function creates a basic 
    # project directory including a README.md, a LICENSE file, and an initial directory structure tailored 
    # to the user's specifications. It's designed to streamline the setup process for new projects, 
    # ensuring essential files and directories are in place from the start.

    echo "Enter a project URL (HTTP/HTTPS or Git SSH) to clone, or a project name to create a new folder:"
    read -l project_input

    # Check if the input is a URL or a Git SSH link
    if string match -qr '^(https?://|git@)' -- $project_input
        echo "Cloning repository from $project_input..."
        git clone $project_input
    else
        echo "Creating new directory named $project_input..."
        mkdir -p $project_input
    end
end

