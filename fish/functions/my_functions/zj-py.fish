function zj-py --description "Launch zellij with the py-ide layout in the current project"
    if not test -d .venv
        echo "zj-py: warning: no .venv/ in $(pwd)" >&2
    end

    # Session name: directory basename, truncated to 12 chars.
    set -l session (basename $PWD | string sub -l 12)

    # $argv last so user-supplied flags (e.g. --session foo) win.
    zellij --layout py-ide --session $session $argv
end
