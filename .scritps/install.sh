#!/usr/bin/env bash
set -euo pipefail

# -----------------------------
# Utility Functions
# -----------------------------
log_info() {
  echo -e "\033[1;34m[INFO]\033[0m $1"
}

log_warn() {
  echo -e "\033[1;33m[WARN]\033[0m $1"
}

log_error() {
  echo -e "\033[1;31m[ERROR]\033[0m $1" >&2
}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# -----------------------------
# APT Package Installation
# -----------------------------
install_apt_packages() {
  log_info "Updating APT repositories..."
  sudo apt update -y
  sudo apt upgrade -y

  PACKAGES=(fish btop neovim alacritty curl tar lazygit eza)
  for pkg in "${PACKAGES[@]}"; do
    if command_exists "$pkg"; then
      log_info "$pkg is already installed."
    else
      log_info "Installing $pkg via APT..."
      if sudo apt install -y "$pkg"; then
        log_info "$pkg installed successfully via APT."
      else
        log_warn "$pkg failed to install via APT."
      fi
    fi
  done
}

# -----------------------------
# Lazygit Fallback Installation
# -----------------------------
install_lazygit_fallback() {
  if command_exists lazygit; then
    log_info "Lazygit is already installed."
    return
  fi

  log_info "Attempting fallback installation for Lazygit..."
  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" |
    grep -Po '"tag_name": *"v\K[^"]*')

  curl -Lo lazygit.tar.gz \
    "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"

  tar xf lazygit.tar.gz lazygit
  sudo install lazygit -D -t /usr/local/bin/
  rm lazygit lazygit.tar.gz

  log_info "Lazygit installed successfully via binary fallback."
}

# -----------------------------
# OpenCode Installation
# -----------------------------
install_opencode() {
  if command_exists opencode; then
    log_info "OpenCode is already installed."
  else
    log_info "Installing OpenCode..."
    curl -fsSL https://opencode.ai/install | bash
  fi
}

# -----------------------------
# Zellij Installation
# -----------------------------
install_zellij() {
  if command_exists zellij; then
    log_info "Zellij is already installed."
  else
    log_info "Downloading Zellij latest release..."
    curl -LO https://github.com/zellij-org/zellij/releases/latest/download/zellij-x86_64-unknown-linux-gnu.tar.gz
    tar -xzf zellij-x86_64-unknown-linux-gnu.tar.gz
    sudo mv zellij /usr/local/bin/
    rm zellij-x86_64-unknown-linux-gnu.tar.gz
    log_info "Zellij installed successfully at /usr/local/bin/zellij"
  fi
}

# -----------------------------
# Mise Installation
# -----------------------------
install_mise() {
  if command_exists mise; then
    log_info "Mise is already installed."
  else
    log_info "Installing Mise..."
    curl https://mise.run | sh
    export PATH="$HOME/.local/bin:$PATH"
    log_info "Make sure to add $HOME/.local/bin to your shell PATH for future sessions."
  fi
}

# -----------------------------
# Docker Installation
# -----------------------------
install_docker() {
  if command_exists docker; then
    log_info "Docker is already installed."
  else
    log_info "Installing Docker..."
    
    log_info "Installing prerequisites..."
    sudo apt install -y ca-certificates curl
    
    log_info "Setting up Docker GPG key..."
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    
    log_info "Adding Docker repository..."
    sudo tee /etc/apt/sources.list.d/docker.sources > /dev/null <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF
    
    log_info "Updating APT and installing Docker..."
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    
    log_info "Adding current user to docker group..."
    sudo usermod -aG docker "$USER"
    
    log_info "Docker installed successfully. You may need to log out and back in for group changes to take effect."
  fi
}

# -----------------------------
# Fisher + Tide Installation (for fish shell)
# -----------------------------
install_fisher_and_tide() {
  if ! command_exists fish; then
    log_error "Fish shell is not installed. Cannot install Fisher or Tide."
    return
  fi

  # Fisher installation
  if fish -c 'type fisher >/dev/null 2>&1'; then
    log_info "Fisher is already installed."
  else
    log_info "Installing Fisher..."
    fish -c 'curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher'
  fi

  # Tide installation
  if fish -c 'fisher list | grep -q IlanCosman/tide'; then
    log_info "Tide is already installed."
  else
    log_info "Installing Tide prompt..."
    fish -c 'fisher install IlanCosman/tide@v6'
  fi
}

# -----------------------------
# Set fish as default shell
# -----------------------------
set_fish_default_shell() {
  if [ "$SHELL" != "$(command -v fish)" ]; then
    log_info "Setting fish as the default shell..."
    chsh -s "$(command -v fish)"
    log_info "Fish shell set as default. You may need to log out and back in for changes to take effect."
  else
    log_info "Fish is already the default shell."
  fi
}

# -----------------------------
# Main Execution
# -----------------------------
main() {
  log_info "=== Starting developer environment setup ==="
  install_apt_packages
  install_lazygit_fallback
  install_opencode
  install_zellij
  install_mise
  install_docker
  install_fisher_and_tide
  set_fish_default_shell
  log_info "=== Setup complete! ==="
  log_info "Installed tools: fish, btop, nvim, alacritty, lazygit, opencode, zellij, mise, docker, fisher, tide"
}

main "$@"
