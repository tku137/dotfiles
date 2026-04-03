# 25‑fzf.fish — fuzzy finder key‑bindings & previews
# docs: https://github.com/junegunn/fzf
if type -q fzf
    # native Fish key‑bindings/completion
    fzf --fish | source
end

# File preview tweaks (CTRL‑T) — run once
if type -q bat
    set -gx FZF_CTRL_T_OPTS \
        "--walker-skip .git,node_modules,target" \
        "--preview 'bat -n --color=always {}'" \
        "--bind 'ctrl-/:change-preview-window(down|hidden|)'"
else
    set -gx FZF_CTRL_T_OPTS \
        "--walker-skip .git,node_modules,target" \
        "--preview 'cat {}'" \
        "--bind 'ctrl-/:change-preview-window(down|hidden|)'"
end

# Directory jump (ALT‑C) preview
if type -q eza
    set -gx FZF_ALT_C_OPTS \
        "--preview 'eza --tree --color --icons --git {}'" \
        "--bind 'ctrl-/:reload(eza --tree --color --icons --git --all)'" \
        "--color header:italic" \
        "--header 'CTRL-/: toggle hidden'"
else if type -q tree
    set -gx FZF_ALT_C_OPTS \
        "--preview 'tree -C {}'" \
        "--bind 'ctrl-/:reload(tree -C -a)'" \
        "--color header:italic" \
        "--header 'CTRL-/: toggle hidden'"
else
    set -gx FZF_ALT_C_OPTS "--preview 'ls -la {}' --color header:italic"
end
