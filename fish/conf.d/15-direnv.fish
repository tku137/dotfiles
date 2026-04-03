# 15‑direnv.fish — automatically load .envrc files
# docs: https://direnv.net
if type -q direnv
    direnv hook fish | source
end
