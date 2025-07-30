# 40‑fisher‑bootstrap.fish — install Fisher if it’s missing and keep plugins fresh
# docs: https://github.com/jorgebucaran/fisher

# Bootstrap Fisher once — we only attempt this if the fisher command is unavailable 
# and we have curl. The curl line is the official single‑liner from the README.
if not type -q fisher
    if type -q curl
        echo "Bootstrapping Fisher plugin manager…"
        curl -sL https://git.io/fisher | source
    else
        echo "Warning: Fisher is not installed and `curl` is missing; skipping bootstrap."
    end
end

# Lightweight auto‑update once per day (interactive shells only). Use a universal sentinel 
# variable so every shell agrees on the last update date.
if type -q fisher; and status --is-interactive
    set -l today (date +%Y-%m-%d)
    if not set -q __fisher_last_update; or test $__fisher_last_update != $today
        echo "Checking for Fisher plugin updates…" &>/dev/null
        fisher update &>/dev/null &
        set -U __fisher_last_update $today
    end
end
