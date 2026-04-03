# 35‑pyenv.fish — Python version manager
# docs: https://github.com/pyenv/pyenv
if type -q pyenv
    set -gx PYENV_ROOT $HOME/.pyenv
    fish_add_path $PYENV_ROOT/bin

    # Only run heavier init code for interactive sessions
    if status --is-interactive
        pyenv init --path | source
        pyenv init - | source # sets up shims & completions
    end
end
