if status is-interactive
    # Commands to run in interactive sessions can go here
end
set -gx LANG "en_US.UTF-8"
starship init fish | source
direnv hook fish | source
fzf_configure_bindings --directory=\cf
zoxide init fish | source

if test -e /Users/tony/getml/google-cloud-sdk/path.fish.inc
  source /Users/tony/getml/google-cloud-sdk/path.fish.inc
end

test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish

