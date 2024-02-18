function activate_py_env --description "Dynamically activate Python virtual environment"
    # This function searches for common virtual environment directories within the current
    # directory. It supports both standard Python virtual environments and those managed
    # by Hatch. Once a virtual environment is found, it is activated accordingly.

    # Define a list of common virtual environment directory names
    set venv_dirs "venv" ".venv" "env"

    # Attempt to find an existing virtual environment directory
    for dir in $venv_dirs
        if test -d $dir
            set venv_path $dir
            break
        end
    end

    # If a virtual environment directory was found
    if set -q venv_path
        # Check if it's a Hatch-managed environment by looking for hatch specific metadata
        if test -f $venv_path/pyvenv.cfg
            set venv_type "standard"
        else if test -d $venv_path/.venvs
            set venv_type "hatch"
        end

        switch $venv_type
            case "standard"
                echo "Activating standard Python virtual environment located in $venv_path..."
                source $venv_path/bin/activate
            case "hatch"
                # For Hatch, we assume the .venvs directory and hatch usage
                # This part could be customized based on how you manage hatch environments specifically
                echo "Activating Hatch-managed Python virtual environment..."
                hatch shell
            case '*'
                echo "Virtual environment found, but the type is unclear. Attempting standard activation..."
                source $venv_path/bin/activate
        end
    else
        echo "No Python virtual environment found."
    end
end


function ave --description "Alias for auto_activate_venv"
    auto_activate_venv
end

