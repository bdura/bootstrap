# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
RESET='\033[0m'

info() { echo -e "${BLUE}${BOLD}==>${RESET} ${BOLD}$*${RESET}"; }
success() { echo -e "${GREEN}${BOLD}==>${RESET} ${BOLD}$*${RESET}"; }
warning() { echo -e "${YELLOW}${BOLD}==> Warning:${RESET} $*"; }
error() { echo -e "${RED}${BOLD}==> Error:${RESET} $*" >&2; }
dry-run() { echo -e "${YELLOW}${BOLD}==>${RESET} ${BOLD}$*${RESET}"; }

info "Logging in to Bitwarden..."
bw config server https://vault.bitwarden.eu
BW_SESSION=$(bw login --raw)
export BW_SESSION
success "Logged in successfully"

eval "$(ssh-agent)"
trap 'kill $SSH_AGENT_PID' EXIT

info "Fetching SSH key..."
bw get item "Darwin" | jq -r ".sshKey.privateKey" | ssh-add -
success "SSH key loaded into agent"

info "Cloning dotfiles..."
git clone git@github.com:bdura/dotfiles.git ~/.dotfiles
success "Dotfiles cloned"

info "Applying stow"
mkdir .config || true
cd .dotfiles
stow .
cd ~
success "Dotfiles deployed"

info "Cloning configuration..."
git clone git@github.com:bdura/nix.git ~/machines
success "Configuration cloned"

info "Building configuration..."
cd machines
nh darwin switch --flake . --hostname nix-darwin-btw
success "Done! Restart your shell to apply all changes."
