function create_python_project --description "Sets up a new Python project with a virtual environment and standard files."
    # Sets up a new Python project environment, including creation of a standard project 
    # structure (main.py, README.md, src/ directory) and initialization of a Python 
    # virtual environment. Users can choose between venv or hatch for environment 
    # management. Additionally, it generates a pyproject.toml with sensible defaults 
    # for tool configuration. This function is intended to automate the repetitive 
    # setup tasks involved in starting a new Python project, making it ready for 
    # development with best practices in mind.

    echo "Enter the name of the new Python project:"
    read -l project_name

    # Create project structure
    echo "Creating project structure..."
    mkdir -p $project_name/src
    touch $project_name/main.py
    echo "# $project_name" > $project_name/README.md

    # Ask about virtual environment
    echo "Do you want to create a virtual environment? (y/N)"
    read -l create_venv

    if string match -iq 'y' -- $create_venv
        echo "Which virtual environment tool do you want to use? [venv/hatch] (Default: venv):"
        read -l venv_tool
        set venv_tool (string trim $venv_tool)

        # Default to venv if no input
        if test -z "$venv_tool"
            set venv_tool "venv"
        end

        switch $venv_tool
            case venv
                echo "Creating virtual environment using venv..."
                python -m venv $project_name/venv
                echo "source $project_name/venv/bin/activate" > $project_name/.envrc

            case hatch
                echo "Creating virtual environment using hatch..."
                cd $project_name
                hatch env create
                cd ..
                echo 'source "$(hatch env find)/bin/activate"' > $project_name/.envrc

            case '*'
                echo "Invalid option. Defaulting to venv..."
                python -m venv $project_name/venv
                echo "source $project_name/venv/bin/activate" > $project_name/.envrc
        end

        echo "Remember to run 'direnv allow' in the project directory to activate automatic venv activation."
    end

    echo "Python project $project_name setup complete."
end

