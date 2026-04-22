#!/bin/bash
# setup.sh — one-time bootstrap for a fresh machine.
# Run this before `dotter deploy`.
#
# What it does:
#   1. Checks hard system dependencies (exits with instructions if any are missing)
#   2. Installs mise (with confirmation)
#   3. Installs dotter binary directly to ~/.local/bin/dotter
#   4. Prints next steps

set -e

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BOLD='\033[1m'
RESET='\033[0m'

info()    { echo -e "${BOLD}${GREEN}==>${RESET} $*"; }
warn()    { echo -e "${BOLD}${YELLOW}  WARNING:${RESET} $*"; }
error()   { echo -e "${BOLD}${RED}  ERROR:${RESET} $*"; }
section() { echo -e "\n${BOLD}$*${RESET}"; }

# Ensure mise is on PATH regardless of shell activation state
export PATH="$HOME/.local/bin:$HOME/.local/share/mise/shims:$PATH"

# ── 0. Verify running from repo root ─────────────────────────────────────────

if [ ! -f "./setup.sh" ] || [ ! -d "./.dotter" ]; then
  echo -e "${BOLD}${RED}ERROR:${RESET} setup.sh must be run from the dotfiles repo root."
  echo -e "  cd into the repo directory first, then run: ${BOLD}bash setup.sh${RESET}"
  exit 1
fi

# ── 1. Check hard system dependencies ────────────────────────────────────────

section "Checking system dependencies..."

MISSING=0

check_dep() {
  local cmd="$1"
  local hint="$2"
  if ! command -v "$cmd" &>/dev/null; then
    error "'$cmd' not found. $hint"
    MISSING=1
  else
    info "$cmd: $(command -v "$cmd")"
  fi
}

check_dep git   "Install git via your system package manager (e.g. apt install git)."
check_dep curl  "Install curl via your system package manager (e.g. apt install curl)."

# Check for a C compiler (gcc or cc)
if command -v gcc &>/dev/null; then
  info "gcc: $(command -v gcc)"
elif command -v cc &>/dev/null; then
  info "cc: $(command -v cc)"
else
  error "No C compiler found (gcc/cc). Required by nvim-treesitter."
  error "Install via your system package manager (e.g. apt install build-essential)."
  MISSING=1
fi

# Check fish
if ! command -v fish &>/dev/null; then
  error "'fish' not found. Install via your system package manager (e.g. apt install fish)."
  MISSING=1
else
  info "fish: $(command -v fish)"
fi

if [ "$MISSING" -ne 0 ]; then
  echo ""
  error "One or more required dependencies are missing. Please install them and run setup.sh again."
  exit 1
fi

echo ""
info "All system dependencies satisfied."

# ── 2. Install mise ───────────────────────────────────────────────────────────

section "Checking mise..."

if command -v mise &>/dev/null; then
  info "mise already installed: $(command -v mise)"
else
  echo ""
  echo -e "  ${BOLD}mise${RESET} is not installed. It is required to install dotter and all other tools."
  echo -e "  Installer: ${BOLD}curl https://mise.run | sh${RESET}"
  echo ""
  read -r -p "  Install mise now? [y/N] " confirm
  case "$confirm" in
    [yY][eE][sS]|[yY])
      info "Installing mise..."
      curl -fsSL https://mise.run | sh
      # Activate mise for the remainder of this script
      export PATH="$HOME/.local/bin:$PATH"
      if ! command -v mise &>/dev/null; then
        error "mise installation completed but 'mise' is still not on PATH."
        error "Try: export PATH=\"\$HOME/.local/bin:\$PATH\" then re-run setup.sh."
        exit 1
      fi
      info "mise installed: $(command -v mise)"
      ;;
    *)
      warn "Skipping mise installation."
      warn "Install manually: https://mise.jdx.dev/"
      warn "Then re-run setup.sh or install dotter manually."
      exit 0
      ;;
  esac
fi

# ── 3. Install dotter ────────────────────────────────────────────────────────

section "Installing dotter..."

# Detect OS and arch, map to the correct GitHub release asset
OS="$(uname -s)"
ARCH="$(uname -m)"
DOTTER_ASSET=""

case "$OS" in
  Linux)
    case "$ARCH" in
      x86_64)        DOTTER_ASSET="dotter-linux-x64-musl"   ;;
      aarch64|arm64) DOTTER_ASSET="dotter-linux-arm64-musl" ;;
      *) error "Unsupported Linux arch: $ARCH. Install dotter manually from https://github.com/SuperCuber/dotter/releases"; exit 1 ;;
    esac
    ;;
  Darwin)
    case "$ARCH" in
      arm64|aarch64) DOTTER_ASSET="dotter-macos-arm64.arm"  ;;
      x86_64) error "No prebuilt dotter binary for Intel macOS. Install via: cargo install dotter"; exit 1 ;;
      *) error "Unsupported macOS arch: $ARCH. Install dotter manually from https://github.com/SuperCuber/dotter/releases"; exit 1 ;;
    esac
    ;;
  *)
    error "Unsupported OS: $OS. Install dotter manually from https://github.com/SuperCuber/dotter/releases"
    exit 1
    ;;
esac

mkdir -p "$HOME/.local/bin"
curl -fsSL "https://github.com/SuperCuber/dotter/releases/latest/download/$DOTTER_ASSET" \
  -o "$HOME/.local/bin/dotter"
chmod +x "$HOME/.local/bin/dotter"
info "dotter installed: $HOME/.local/bin/dotter"

# ── 4. Create local.toml if it doesn't exist ─────────────────────────────────

section "Setting up .dotter/local.toml..."

LOCAL_TOML="$(dirname "$0")/.dotter/local.toml"

if [ -f "$LOCAL_TOML" ]; then
  info "local.toml already exists, skipping."
else
  cat > "$LOCAL_TOML" <<'EOF'
# Select your machine profile. Common setups:
#   headless — shell + tmux + nvim (server/remote machines)
#   desktop  — headless + ghostty (personal workstation)
#
# Add optional packages after the profile, e.g. ["desktop", "zellij"]

# packages = ["headless"]
# packages = ["desktop", "zellij"]

# Override default variables defined in .dotter/global.toml:
#
# [variables]
# git_name  = "Your Name"
# git_email = "you@work.com"
#
# [terminal.variables]
# font_size = 14
EOF
  info "Created .dotter/local.toml — edit it before running dotter deploy."
fi

# ── 5. Next steps ─────────────────────────────────────────────────────────────

FISH_PATH="$(command -v fish 2>/dev/null || true)"
CURRENT_SHELL="$(getent passwd "$USER" 2>/dev/null | cut -d: -f7 || echo "$SHELL")"

echo ""
echo -e "${BOLD}${GREEN}Bootstrap complete.${RESET}"
echo ""

# Warn if ~/.local/bin is not on the current PATH (dotter may not be reachable)
case ":$PATH:" in
  *":$HOME/.local/bin:"*) ;;
  *)
    echo -e "${BOLD}${YELLOW}  NOTE:${RESET} $HOME/.local/bin is not on your current PATH."
    echo -e "  Paste this to use dotter in this session:"
    echo ""
    echo -e "       ${BOLD}export PATH=\"\$HOME/.local/bin:\$PATH\"${RESET}"
    echo ""
    ;;
esac

echo -e "${BOLD}Next steps:${RESET}"
echo ""
echo -e "  1. Edit ${BOLD}.dotter/local.toml${RESET} and uncomment your machine profile."
echo ""
echo -e "  2. Preview what will be deployed (recommended on first run):"
echo ""
echo -e "       ${BOLD}dotter deploy --dry-run -v${RESET}"
echo ""
echo -e "  3. Deploy:"
echo ""
echo -e "       ${BOLD}dotter deploy${RESET}"
echo ""
echo -e "     If existing config files conflict, force overwrite with:"
echo ""
echo -e "       ${BOLD}dotter deploy --force${RESET}"
echo ""
