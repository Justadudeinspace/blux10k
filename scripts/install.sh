#!/usr/bin/env bash
set -euo pipefail

BLUX_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
CONFIG_ROOT="$BLUX_ROOT/configs"
ZSHRC_DEST="$HOME/.zshrc"
P10K_DEST="$HOME/.p10k.zsh"
NEOFETCH_DEST="$HOME/.config/neofetch/config.conf"
PRIVATE_ENV_DEST="$HOME/.config/private/env.zsh"
FONT_URL_BASE="https://github.com/romkatv/powerlevel10k-media/raw/master"
FONTS=(
  "MesloLGS NF Regular.ttf"
  "MesloLGS NF Bold.ttf"
  "MesloLGS NF Italic.ttf"
  "MesloLGS NF Bold Italic.ttf"
)

OS_TYPE="unknown"
DISTRO="unknown"
PACKAGE_MANAGER=""
IS_WSL=0
IS_TERMUX=0
ARCH=$(uname -m)

log() {
  local level=$1
  local message=$2
  local color_reset="\033[0m"
  local color_info="\033[34m"
  local color_success="\033[32m"
  local color_warn="\033[33m"
  local color_error="\033[31m"
  case "$level" in
    info) printf "%b[INFO]%b %s\n" "$color_info" "$color_reset" "$message" ;;
    success) printf "%b[ OK ]%b %s\n" "$color_success" "$color_reset" "$message" ;;
    warn) printf "%b[WARN]%b %s\n" "$color_warn" "$color_reset" "$message" ;;
    error) printf "%b[ERR ]%b %s\n" "$color_error" "$color_reset" "$message" >&2 ;;
  esac
}

print_banner() {
  cat <<'BANNER'
 ____  _      _   _  __  __  _  __  _  __
|  _ \| | __ | \ | ||  \/  |(_)/ _|(_)/ _|
| |_) | |/ / |  \| || |\/| | _| |_  _| |_ 
|  _ <|   <  | . ` || |  | || |  _|| |  _|
| |_) | |\ \ | |\  || |  | || | |   | | |  
|____/|_| \_\|_| \_||_|  |_||_|_|   |_|_|  
BANNER
  log info "BLUX10K Installer v1.0.0"
}

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    log error "Missing required command: $1"
    return 1
  fi
}

check_dependencies() {
  log info "Checking bootstrap dependencies"
  local missing=0
  for cmd in git curl zsh; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
      log warn "Command '$cmd' not found"
      missing=1
    fi
  done
  [[ $missing -eq 0 ]] || log warn "Some dependencies are missing. The installer will attempt to install them."
}

detect_platform() {
  OS_TYPE=$(uname -s)
  if [[ -r /proc/version ]] && grep -qi microsoft /proc/version; then
    IS_WSL=1
  fi
  if [[ -d /data/data/com.termux ]]; then
    IS_TERMUX=1
    DISTRO="termux"
    PACKAGE_MANAGER="pkg"
    return
  fi

  case "$OS_TYPE" in
    Linux)
      if [[ -f /etc/os-release ]]; then
        # shellcheck disable=SC1091
        source /etc/os-release
        DISTRO=${ID:-linux}
      fi
      case "$DISTRO" in
        ubuntu|debian|pop|neon) PACKAGE_MANAGER="apt" ;;
        arch|manjaro|endeavouros) PACKAGE_MANAGER="pacman" ;;
        fedora|rhel|centos) PACKAGE_MANAGER="dnf" ;;
        opensuse*|suse) PACKAGE_MANAGER="zypper" ;;
        alpine) PACKAGE_MANAGER="apk" ;;
        gentoo) PACKAGE_MANAGER="emerge" ;;
        *) PACKAGE_MANAGER="" ;;
      esac
      ;;
    Darwin)
      DISTRO="macos"
      PACKAGE_MANAGER="brew"
      ;;
    *)
      DISTRO="unknown"
      PACKAGE_MANAGER=""
      ;;
  esac

  log info "Detected OS: $OS_TYPE ($DISTRO)"
  [[ $IS_WSL -eq 1 ]] && log info "Running inside Windows Subsystem for Linux"
  [[ $IS_TERMUX -eq 1 ]] && log info "Running inside Termux"
}

confirm_installation() {
  log warn "This script will modify your shell configuration and install packages."
  read -r -p "Continue? [y/N] " reply
  [[ $reply =~ ^[Yy]$ ]] || { log error "Installation aborted"; exit 1; }
}

install_base_packages() {
  log info "Installing base packages"
  case "$PACKAGE_MANAGER" in
    apt)
      sudo apt update
      sudo apt install -y zsh git gnupg2 openssh-client curl wget ca-certificates \
        unzip zip tar gzip bzip2 xz-utils p7zip-full unrar lsof iproute2 net-tools file procps \
        neovim fzf fd-find ripgrep jq bat
      if ! command -v eza >/dev/null 2>&1; then
        sudo apt install -y cargo
        cargo install eza --locked || true
      fi
      if ! command -v zoxide >/dev/null 2>&1; then
        curl -sSf https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
      fi
      mkdir -p "$HOME/.local/bin"
      if command -v batcat >/dev/null 2>&1; then
        ln -sf "$(command -v batcat)" "$HOME/.local/bin/bat"
      fi
      if command -v fdfind >/dev/null 2>&1; then
        ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
      fi
      ;;
    pacman)
      sudo pacman -Syu --noconfirm \
        zsh git gnupg openssh curl wget ca-certificates unzip zip tar gzip bzip2 xz p7zip unrar \
        lsof iproute2 net-tools file neovim fzf fd ripgrep jq bat eza zoxide neofetch fastfetch
      ;;
    dnf)
      sudo dnf upgrade -y
      sudo dnf install -y zsh git gnupg2 openssh-clients curl wget ca-certificates unzip zip tar \
        gzip bzip2 xz p7zip p7zip-plugins unrar lsof iproute net-tools file neovim fzf fd-find \
        ripgrep jq bat eza zoxide neofetch fastfetch
      ;;
    brew)
      brew update
      brew install zsh git gnupg openssh curl wget coreutils findutils unzip p7zip unrar gnu-tar \
        gnu-sed lsof iproute2mac neovim fzf fd ripgrep jq bat eza zoxide neofetch fastfetch python \
        node pnpm yarn go rustup-init php composer
      brew tap homebrew/cask-fonts
      brew install --cask font-meslo-lg-nerd-font || true
      ;;
    pkg)
      pkg update
      pkg install -y zsh git gnupg openssh curl wget coreutils unzip zip tar gzip bzip2 xz p7zip \
        unrar lsof procps neovim fzf fd ripgrep jq bat eza zoxide neofetch
      ;;
    *)
      log warn "Automatic package installation is not supported for $DISTRO. Install dependencies manually."
      ;;
  esac
}

install_oh_my_zsh() {
  if [[ -d ${ZSH:-$HOME/.oh-my-zsh} ]]; then
    log info "Oh My Zsh already installed"
    return
  fi
  log info "Installing Oh My Zsh"
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

install_zplug() {
  if [[ -d ${ZPLUG_HOME:-$HOME/.zplug} ]]; then
    log info "zplug already installed"
    return
  fi
  log info "Installing zplug"
  curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
}

install_fonts() {
  local font_dir
  case "$OS_TYPE" in
    Darwin) font_dir="$HOME/Library/Fonts" ;;
    *) font_dir="$HOME/.local/share/fonts" ;;
  esac
  mkdir -p "$font_dir"
  for font in "${FONTS[@]}"; do
    local url="$FONT_URL_BASE/${font// /%20}"
    local dest="$font_dir/$font"
    if [[ -f $dest ]]; then
      log info "Font $font already present"
      continue
    fi
    log info "Downloading $font"
    curl -fsSL "$url" -o "$dest"
  done
  if command -v fc-cache >/dev/null 2>&1; then
    fc-cache -f "$font_dir"
  fi
}

deploy_configs() {
  log info "Deploying configuration files"
  mkdir -p "$(dirname "$NEOFETCH_DEST")" "$(dirname "$PRIVATE_ENV_DEST")"

  if [[ -f $ZSHRC_DEST ]]; then
    cp "$ZSHRC_DEST" "$ZSHRC_DEST.pre-blux"
  fi
  cp "$CONFIG_ROOT/.zshrc" "$ZSHRC_DEST"
  cp "$CONFIG_ROOT/.p10k.zsh" "$P10K_DEST"
  if [[ -f $PRIVATE_ENV_DEST ]]; then
    log warn "Private env file already exists; leaving in place"
  else
    cp "$CONFIG_ROOT/env.zsh.example" "$PRIVATE_ENV_DEST"
    chmod 600 "$PRIVATE_ENV_DEST"
  fi
  cp "$CONFIG_ROOT/neofetch/config.conf" "$NEOFETCH_DEST"
}

setup_zsh_default() {
  if [[ ${SHELL} == *zsh ]]; then
    log info "Zsh already default shell"
    return
  fi
  if command -v chsh >/dev/null 2>&1; then
    log info "Setting zsh as default shell"
    local zsh_path
    zsh_path=$(command -v zsh)
    if [[ -n $zsh_path ]]; then
      chsh -s "$zsh_path" "$USER"
    fi
  else
    log warn "chsh not available. Set zsh manually."
  fi
}

initialize_plugins() {
  log info "Initializing zplug plugins"
  zsh -ic 'zplug install' || log warn "zplug install reported an issue"
  log info "Skip automatic powerlevel10k wizard; run 'p10k configure' later if desired"
}

install_language_toolchains() {
  log info "Installing optional language toolchains"
  case "$PACKAGE_MANAGER" in
    apt)
      sudo apt install -y python3 python3-pip python3-venv pipx nodejs npm golang
      sudo corepack enable || true
      curl https://sh.rustup.rs -sSf | sh -s -- -y
      ;;
    pacman)
      sudo pacman -S --noconfirm python python-pip nodejs npm golang rustup
      ;;
    dnf)
      sudo dnf install -y python3 python3-pip nodejs npm golang rust cargo
      ;;
    brew)
      ;;
    pkg)
      pkg install -y python python-pip nodejs golang rust
      ;;
    *)
      log warn "Skipping language toolchains for $DISTRO"
      ;;
  esac
}

initialize_update_function() {
  log info "Testing update command (dry-run)"
  zsh -ic 'update -n' || log warn "Update command dry-run failed; investigate manually"
}

final_message() {
  cat <<'MSG'

BLUX10K installation complete!

Next steps:
  1. Set your terminal font to "MesloLGS NF".
  2. Restart the terminal session or run "rz" to reload zsh.
  3. Edit ~/.config/private/env.zsh to add API keys and secrets.
  4. Run "p10k configure" to customize your prompt.
  5. Configure git with your name/email if needed.
  6. Test "update" to verify package manager operations.
MSG
}

main() {
  print_banner
  check_dependencies
  detect_platform
  confirm_installation
  install_base_packages
  install_oh_my_zsh
  install_zplug
  install_fonts
  deploy_configs
  setup_zsh_default
  initialize_plugins
  install_language_toolchains || true
  initialize_update_function || true
  final_message
}

if [[ ${BASH_SOURCE[0]} == "$0" ]]; then
  main "$@"
fi
