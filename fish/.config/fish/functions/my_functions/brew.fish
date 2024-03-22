# Upgrade casks and cleanup
alias bcubc='brew upgrade --cask && brew cleanup'

# Update Homebrew and list outdated casks
alias bcubo='brew update && brew outdated --cask'

# Pin a formula
alias brewp='brew pin'

# List pinned formulas
alias brewsp='brew list --pinned'

# Upgrade all packages and cleanup
alias bubc='brew upgrade && brew cleanup'

# Upgrade all packages greedily and cleanup
alias bugbc='brew upgrade --greedy && brew cleanup'

# Update Homebrew and list outdated packages
alias bubo='brew update && brew outdated'

# Update, list outdated, upgrade all packages, and cleanup
alias bubu='bubo && bubc'

# Update, list outdated, upgrade all packages greedily, and cleanup
alias bubug='bubo && bugbc'

# Upgrade formulae
alias bfu='brew upgrade --formula'

# Uninstall a package and remove all its associated data
alias buz='brew uninstall --zap'

