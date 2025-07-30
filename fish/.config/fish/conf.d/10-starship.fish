# 20‑starship.fish – prompt init (runs once per session)
if type -q starship
    # Cache the fully rendered script for speed
    if not test -f ~/.cache/starship_init.fish
        starship init fish --print-full-init >~/.cache/starship_init.fish
    end
    source ~/.cache/starship_init.fish
end
