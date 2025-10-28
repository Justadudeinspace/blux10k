# BLUX10K Universal Zsh Configuration
# Version: 1.0.0
# Sections: 0-24 as documented in README

# shellcheck disable=SC2034

############################################################
# 0_header
############################################################
cat <<'BANNER'
 ____  _      _   _  __  __  _  __  _  __
|  _ \| | __ | \ | ||  \/  |(_)/ _|(_)/ _|
| |_) | |/ / |  \| || |\/| | _| |_  _| |_ 
|  _ <|   <  | . ` || |  | || |  _|| |  _|
| |_) | |\ \ | |\  || |  | || | |   | | |  
|____/|_| \_\|_| \_||_|  |_||_|_|   |_|_|  
BANNER

print -P "%F{39}System online. Welcome to BLUX10K.%f"

############################################################
# 1_performance
############################################################
ZSH_DISABLE_COMPFIX=true
# zmodload zsh/zprof # Enable for profiling if needed

############################################################
# 2_zplug
############################################################
export ZPLUG_HOME="${ZPLUG_HOME:-$HOME/.zplug}"
export ZPLUG_THREADS="${ZPLUG_THREADS:-16}"
export ZPLUG_PROTOCOL="${ZPLUG_PROTOCOL:-HTTPS}"
export ZPLUG_FILTER="${ZPLUG_FILTER:-fzf-tmux:fzf:peco:percol:zaw}"
export ZPLUG_LOADFILE="${ZPLUG_LOADFILE:-$ZPLUG_HOME/packages.zsh}"
export ZPLUG_USE_CACHE="${ZPLUG_USE_CACHE:-true}"
export ZPLUG_CACHE_DIR="${ZPLUG_CACHE_DIR:-$ZPLUG_HOME/.cache}"
export ZPLUG_REPOS="${ZPLUG_REPOS:-$ZPLUG_HOME/repos}"
export ZPLUG_BIN="${ZPLUG_BIN:-$ZPLUG_HOME/bin}"

if [[ -f $ZPLUG_HOME/init.zsh ]]; then
  source "$ZPLUG_HOME/init.zsh"
fi

if command -v zplug &>/dev/null; then
  zplug "romkatv/powerlevel10k", as:theme, depth:1, use:powerlevel10k.zsh-theme
  zplug "zsh-users/zsh-history-substring-search"
  zplug "zsh-users/zsh-syntax-highlighting", defer:2
  zplug "zsh-users/zsh-autosuggestions"
  zplug "zsh-users/zsh-completions"
  zplug "MichaelAquilina/zsh-autoswitch-virtualenv"
  zplug "agkozak/zsh-z"
  zplug "junegunn/fzf", as:command, use:"bin/fzf-tmux"
  zplug "ohmyzsh/ohmyzsh", use:"lib/clipboard.zsh"
  zplug "ohmyzsh/ohmyzsh", use:"lib/copyfile.zsh"
  zplug "ohmyzsh/ohmyzsh", use:"lib/web-search.zsh"
  zplug "ohmyzsh/ohmyzsh", use:"plugins/git/git.plugin.zsh"
  zplug "ohmyzsh/ohmyzsh", use:"plugins/command-not-found/command-not-found.plugin.zsh"
  zplug "ohmyzsh/ohmyzsh", use:"plugins/colored-man-pages/colored-man-pages.plugin.zsh"

  if ! zplug check; then
    zplug install
  fi
  zplug load
fi

############################################################
# 3_private_env
############################################################
if [[ -r $HOME/.config/private/env.zsh ]]; then
  source $HOME/.config/private/env.zsh
fi

############################################################
# 4_xdg
############################################################
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

mkdir -p "$XDG_CACHE_HOME/zsh" "$XDG_STATE_HOME/zsh"

############################################################
# 5_history
############################################################
export HISTFILE="$XDG_STATE_HOME/zsh/history-$(date +%Y-%m)"
export HISTSIZE=100000
export SAVEHIST=100000
setopt INC_APPEND_HISTORY_TIME SHARE_HISTORY HIST_IGNORE_ALL_DUPS \
  HIST_REDUCE_BLANKS HIST_IGNORE_SPACE

############################################################
# 6_shell_behavior
############################################################
setopt PROMPT_SUBST INTERACTIVE_COMMENTS AUTO_CD EXTENDED_GLOB NO_BEEP NOTIFY
if [[ -t 0 || -t 1 ]]; then
  setopt CORRECT CORRECT_ALL
fi
bindkey -e
SPROMPT='zsh: %R → %r ? [Nyae]'

############################################################
# 7_path
############################################################
typeset -U path PATH

append_path() {
  local dir=$1
  [[ -n $dir && -d $dir ]] || return 0
  path+=$dir
}

append_path "$HOME/.local/bin"
append_path "$HOME/bin"
append_path "$HOME/.cargo/bin"
append_path "$HOME/.npm-global/bin"
append_path "${PNPM_HOME:-$HOME/.local/share/pnpm}"
append_path "${VOLTA_HOME:-$HOME/.volta}/bin"
append_path "$HOME/.local/share/gem/ruby/3.3.0/bin"
append_path "$HOME/Scripts"
append_path "$HOME/dev/tools/flutter/bin"
append_path "$HOME/.turso"
append_path /usr/local/sbin
append_path /usr/sbin
append_path /sbin

if [[ $OSTYPE == msys* || $OSTYPE == cygwin* ]]; then
  append_path /mingw64/bin
  append_path "/c/Program Files/Docker/Docker/resources/bin"
fi

export PATH

############################################################
# 8_colors
############################################################
autoload -Uz colors && colors

############################################################
# 9_platform_detection
############################################################
if [[ -z ${WSL+x} && -r /proc/version ]]; then
  if grep -qi microsoft /proc/version; then
    export WSL=1
  fi
fi

if [[ -d /data/data/com.termux ]]; then
  export TERMUX=1
fi

if [[ $(uname) == Darwin ]]; then
  export BLUX_IS_DARWIN=1
fi

############################################################
# 10_truecolor
############################################################
if [[ $COLORTERM = truecolor || $TERM == *256* ]]; then
  export TERM=xterm-256color
fi
export BAT_THEME="${BAT_THEME:-TwoDark}"

############################################################
# 11_plugin_configs
############################################################
[[ -f $HOME/.p10k.zsh ]] && source $HOME/.p10k.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE=${ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE:-'fg=8'}
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_USE_ASYNC=1
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
export AUTOSWITCH_VIRTUAL_ENV_DIR="${AUTOSWITCH_VIRTUAL_ENV_DIR:-venv}"
export AUTOSWITCH_VIRTUAL_ENV_DIR_EXTRA="${AUTOSWITCH_VIRTUAL_ENV_DIR_EXTRA:-.venv}"
export AUTOSWITCH_SILENT=1
export ZSHZ_CMD="${ZSHZ_CMD:-z}"
export ZSHZ_CASE="${ZSHZ_CASE:-smart}"
export ZSHZ_UNCOMMON=1

############################################################
# 12_fzf_fd
############################################################
export FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS:---height 40% --layout=reverse --border}"
if command -v fd &>/dev/null; then
  export FZF_DEFAULT_COMMAND="fd --hidden --follow --exclude .git"
elif command -v fdfind &>/dev/null; then
  alias fd=fdfind
  export FZF_DEFAULT_COMMAND="fdfind --hidden --follow --exclude .git"
fi

############################################################
# 13_aliases
############################################################
if command -v eza &>/dev/null; then
  alias ls='eza --group-directories-first --icons'
else
  alias ls='ls --color=auto -F'
fi
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias cp='cp -iv --reflink=auto'
alias mv='mv -iv'
alias rm='rm -Iv'
alias grep='grep --color=auto'
alias df='df -h'
alias du='du -h'
alias ports='ss -tulpn 2>/dev/null || netstat -tulpn'
alias serve='python3 -m http.server 8080'
alias json='python3 -m json.tool'
alias vi='nvim'
alias svi='sudo nvim'
if command -v bat &>/dev/null; then
  alias cat='bat --paging=never'
elif command -v batcat &>/dev/null; then
  alias bat='batcat'
  alias cat='batcat --paging=never'
fi
alias google='web_search google'
alias ddg='web_search duckduckgo'
alias github='web_search github'
alias stackoverflow='web_search stackoverflow'
if command -v apt &>/dev/null; then
  alias fix-install='sudo apt --fix-broken install'
  alias autoremove='sudo apt autoremove -y'
  alias system-upgrade='sudo apt update && sudo apt full-upgrade -y'
fi

############################################################
# 14_functions
############################################################
mkcd() { mkdir -p "$1" && cd "$1" || return }
bk() { [[ -n $1 ]] && cp -f "$1" "$1.bak" }
ff() { find . -type f -iname "*$1*" 2>/dev/null }
hist() { history | grep -- "$*" }

extract() {
  local file=$1
  [[ -f $file ]] || { echo "extract: file not found: $file" >&2; return 1; }
  case $file in
    *.tar.bz2|*.tbz2) tar xjf "$file" ;;
    *.tar.gz|*.tgz) tar xzf "$file" ;;
    *.tar.xz) tar xJf "$file" ;;
    *.tar) tar xf "$file" ;;
    *.bz2) bunzip2 "$file" ;;
    *.gz) gunzip "$file" ;;
    *.zip) unzip "$file" ;;
    *.rar) unrar x "$file" ;;
    *.7z) 7z x "$file" ;;
    *.xz) unxz "$file" ;;
    *.lzma) unlzma "$file" ;;
    *) echo "extract: unsupported file: $file" >&2; return 1 ;;
  esac
}

killport() {
  local port=$1
  [[ -n $port ]] || { echo "Usage: killport <port>" >&2; return 1; }
  if command -v lsof &>/dev/null; then
    lsof -ti :"$port" | xargs -r kill -9
  else
    netstat -tulpn 2>/dev/null | awk -v port=":$port" '$4 ~ port { split($7, a, "/"); print a[1]; }' | xargs -r kill -9
  fi
}

gcom() { git add . && git commit -m "$1" }
lazyg() { git add . && git commit -m "$1" && git push }

############################################################
# 15_keybindings
############################################################
if [[ -t 0 || -t 1 ]]; then
  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down
  bindkey -M menuselect '^M' .accept-line
  if typeset -f zoxide &>/dev/null || command -v zoxide &>/dev/null; then
    bindkey '^f' zoxide_i
  fi
fi

############################################################
# 16_ssh_agent
############################################################
if [[ -z $SSH_AUTH_SOCK && -r $HOME/.ssh ]]; then
  if command -v ssh-agent &>/dev/null; then
    eval "$(ssh-agent -s -t 12h)" >/dev/null
    for key in id_ed25519 id_rsa id_github_sign_and_auth; do
      [[ -f $HOME/.ssh/$key ]] && ssh-add "$HOME/.ssh/$key" &>/dev/null
    done
  fi
fi

############################################################
# 17_gpg
############################################################
[[ -n $TTY ]] && export GPG_TTY=$TTY

############################################################
# 18_docker_podman
############################################################
export DOCKER_BUILDKIT=1
export BUILDKIT_PROGRESS=plain
export PODMAN_USERNS=keep-id

############################################################
# 19_update_function
############################################################
SYSUPDATE_LOG_KEEP=${SYSUPDATE_LOG_KEEP:-10}
SYSUPDATE_KERNELS_KEEP=${SYSUPDATE_KERNELS_KEEP:-2}
SYSUPDATE_MAX_RETRIES=${SYSUPDATE_MAX_RETRIES:-3}
SYSUPDATE_TIMEOUT=${SYSUPDATE_TIMEOUT:-300}
SYSUPDATE_SKIP_PIP=${SYSUPDATE_SKIP_PIP:-1}

_update_log_dir="$XDG_STATE_HOME/sysupdate/logs"
mkdir -p "$_update_log_dir" "$XDG_STATE_HOME/sysupdate" "$XDG_CACHE_HOME/sysupdate"

typeset -g _update_log_file="$_update_log_dir/sysupdate-$(date +%Y%m%d-%H%M%S).log"

tput_reset() { tput sgr0 2>/dev/null || true }

typeset -ga _BLUX_UPDATE_ONLY=()
typeset -ga _BLUX_UPDATE_EXCLUDE=()
typeset -gA _BLUX_UPDATE_CTX=()

_update_spinner=(⠋ ⠙ ⠹ ⠸ ⠼ ⠴ ⠦ ⠧ ⠇ ⠏)
_update_symbol_info=$'\u25BA'
_update_symbol_warn=$'\u26A0'
_update_symbol_error=$'\u2718'
_update_symbol_ok=$'\u2713'

update() {
  emulate -L zsh
  setopt pipefail

  local dry_run_flag yes_flag verbose_flag quiet_flag force_flag cleanup_flag security_only_flag low_data_flag only_flag exclude_flag
  zparseopts -D -K -- n=dry_run_flag y=yes_flag v=verbose_flag q=quiet_flag f=force_flag \
    -cleanup=cleanup_flag -security-only=security_only_flag -low-data=low_data_flag \
    -only:=only_flag -exclude:=exclude_flag || return 1

  local dry_run=$([[ -n $dry_run_flag ]] && echo true || echo false)
  local quiet=$([[ -n $quiet_flag ]] && echo true || echo false)
  local verbose=$([[ -n $verbose_flag ]] && echo true || echo false)

  _BLUX_UPDATE_CTX=(
    dry_run $dry_run
    quiet $quiet
    verbose $verbose
  )

  _update_log_file="$_update_log_dir/sysupdate-$(date +%Y%m%d-%H%M%S).log"

  _BLUX_UPDATE_ONLY=()
  _BLUX_UPDATE_EXCLUDE=()

  if [[ -n $only_flag ]]; then
    local raw=${only_flag[2]}
    _BLUX_UPDATE_ONLY=(${=raw//,/ })
  fi

  if [[ -n $exclude_flag ]]; then
    local raw=${exclude_flag[2]}
    _BLUX_UPDATE_EXCLUDE=(${=raw//,/ })
  fi

  local start_time=$(date +%s)

  _update_log "${_update_symbol_info} Starting BLUX10K update sequence" info

  _update_run_manager apt "APT" _update_apt_handler
  _update_run_manager snap "Snap" _update_snap_handler
  _update_run_manager flatpak "Flatpak" _update_flatpak_handler
  _update_run_manager pip "Pip" _update_pip_handler
  _update_run_manager pipx "Pipx" _update_pipx_handler
  _update_run_manager npm "NPM" _update_npm_handler
  _update_run_manager pnpm "PNPM" _update_pnpm_handler
  _update_run_manager cargo "Cargo" _update_cargo_handler
  _update_run_manager rust "Rustup" _update_rust_handler
  _update_run_manager docker "Docker" _update_docker_handler
  _update_run_manager ohmyzsh "Oh My Zsh" _update_omz_handler
  _update_run_manager firmware "Firmware" _update_firmware_handler

  local duration=$(( $(date +%s) - start_time ))
  _update_log "${_update_symbol_ok} Update sequence completed in ${duration}s" success

  if [[ -f /var/run/reboot-required ]]; then
    _update_log "${_update_symbol_warn} Reboot required" warn
  fi

  if command -v systemctl &>/dev/null; then
    local failed=$(systemctl --failed --no-legend)
    if [[ -n $failed ]]; then
      _update_log "${_update_symbol_warn} Failed services detected:\n$failed" warn
    fi
  fi
}

_update_log() {
  local message=$1
  local level=${2:-info}
  local quiet=${_BLUX_UPDATE_CTX[quiet]:-false}
  case $level in
    info)
      [[ $quiet == true ]] && { printf '%s\n' "$message" >>"$_update_log_file"; return; }
      printf '%s\n' "$message" | tee -a "$_update_log_file"
      ;;
    success)
      [[ $quiet == true ]] && { printf '%s\n' "$message" >>"$_update_log_file"; return; }
      printf '%s\n' "$message" | tee -a "$_update_log_file"
      ;;
    warn)
      printf '%s\n' "$message" | tee -a "$_update_log_file" >&2
      ;;
    error)
      printf '%s\n' "$message" | tee -a "$_update_log_file" >&2
      ;;
  esac
}

_update_run_with_retry() {
  local command=$1
  local name=$2
  local attempt=1
  local exit_code=0
  until (( attempt > SYSUPDATE_MAX_RETRIES )); do
    eval "$command"
    exit_code=$?
    if (( exit_code == 0 )); then
      return 0
    fi
    sleep $(( 2 ** (attempt - 1) ))
    (( attempt++ ))
  done
  return $exit_code
}

_update_run_manager() {
  local key=$1
  local label=$2
  local handler=$3

  if ! typeset -f "$handler" &>/dev/null; then
    return
  fi

  if (( ${#_BLUX_UPDATE_ONLY[@]} )); then
    local found=false
    for item in "${_BLUX_UPDATE_ONLY[@]}"; do
      [[ $item == $key ]] && found=true
    done
    [[ $found == true ]] || return
  fi

  if (( ${#_BLUX_UPDATE_EXCLUDE[@]} )); then
    for item in "${_BLUX_UPDATE_EXCLUDE[@]}"; do
      [[ $item == $key ]] && return
    done
  fi

  if "$handler" --check; then
    _update_log "${_update_symbol_info} Updating ${label}" info
    if [[ ${_BLUX_UPDATE_CTX[dry_run]:-false} == true ]]; then
      _update_log "${_update_symbol_info} ${label} skipped (dry-run)" info
      return
    fi
    if "$handler" --run; then
      _update_log "${_update_symbol_ok} ${label} updated" success
    else
      _update_log "${_update_symbol_error} ${label} failed" error
    fi
  fi
}

_update_apt_handler() {
  case $1 in
    --check) command -v apt-get &>/dev/null ;;
    --run)
      local opts=(-o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confold -o Acquire::Queue-Mode=access -o Acquire::Retries=3)
      _update_run_with_retry "sudo apt-get ${opts[*]} update" apt-update || return 1
      _update_run_with_retry "sudo apt-get ${opts[*]} full-upgrade -y" apt-upgrade || return 1
      sudo apt-get autoremove --purge -y
      sudo apt-get autoclean -y
      return 0
      ;;
  esac
}

_update_snap_handler() {
  case $1 in
    --check) command -v snap &>/dev/null && [[ -d /run/systemd/system ]] ;;
    --run) snap refresh ;;
  esac
}

_update_flatpak_handler() {
  case $1 in
    --check) command -v flatpak &>/dev/null ;;
    --run)
      flatpak update -y && flatpak uninstall --unused -y
      ;;
  esac
}

_update_pip_handler() {
  case $1 in
    --check) command -v pip3 &>/dev/null && [[ ${SYSUPDATE_SKIP_PIP:-1} != 1 ]] ;;
    --run)
      pip3 install --upgrade pip
      local outdated=$(pip3 list --outdated --format=freeze | cut -d'=' -f1)
      if [[ -n $outdated ]]; then
        for package in ${(f)outdated}; do
          pip3 install --upgrade "$package"
        done
      fi
      ;;
  esac
}

_update_pipx_handler() {
  case $1 in
    --check) command -v pipx &>/dev/null ;;
    --run) pipx upgrade-all ;;
  esac
}

_update_npm_handler() {
  case $1 in
    --check) command -v npm &>/dev/null ;;
    --run) npm update -g ;;
  esac
}

_update_pnpm_handler() {
  case $1 in
    --check) command -v pnpm &>/dev/null ;;
    --run) pnpm update -g ;;
  esac
}

_update_cargo_handler() {
  case $1 in
    --check) command -v cargo &>/dev/null ;;
    --run)
      cargo install cargo-update &>/dev/null || true
      cargo install-update -a
      ;;
  esac
}

_update_rust_handler() {
  case $1 in
    --check) command -v rustup &>/dev/null ;;
    --run) rustup update ;;
  esac
}

_update_docker_handler() {
  case $1 in
    --check) command -v docker &>/dev/null ;;
    --run)
      docker image prune -af
      docker volume prune -f
      ;;
  esac
}

_update_omz_handler() {
  case $1 in
    --check) [[ -d ${ZSH:-$HOME/.oh-my-zsh} ]] ;;
    --run) "${ZSH:-$HOME/.oh-my-zsh}/tools/upgrade.sh" ;;
  esac
}

_update_firmware_handler() {
  case $1 in
    --check) command -v fwupdmgr &>/dev/null ;;
    --run)
      fwupdmgr refresh
      fwupdmgr update -y
      ;;
  esac
}

############################################################
# 20_completion
############################################################
_update_completion() {
  compadd -- update update_system up
}
compdef _update_completion update update_system up
alias update_system='update'
alias up='update'

############################################################
# 21_reload
############################################################
reload-zsh() { exec zsh }
alias rz='reload-zsh'

zsh-health() {
  print -P "%F{39}Zsh version:%f $(zsh --version)"
  if command -v zplug &>/dev/null; then
    print -P "%F{39}Plugins:%f ${(j:, :)$(zplug list 2>/dev/null)}"
  else
    print -P "%F{39}Plugins:%f zplug not detected"
  fi
  print -P "%F{39}PATH entries:%f ${(j:\n:)path}"
}

############################################################
# 22_local_overrides
############################################################
[[ -f $HOME/.zshrc.local ]] && source $HOME/.zshrc.local
[[ -f $HOME/.zsh_aliases ]] && source $HOME/.zsh_aliases

############################################################
# 23_compile
############################################################
if [[ ! -f $HOME/.zshrc.zwc || $HOME/.zshrc -nt $HOME/.zshrc.zwc ]]; then
  zcompile -R $HOME/.zshrc.zwc $HOME/.zshrc &>/dev/null || true
fi

############################################################
# 24_motd
############################################################
if command -v neofetch &>/dev/null; then
  neofetch --config "$XDG_CONFIG_HOME/neofetch/config.conf"
elif command -v fastfetch &>/dev/null; then
  fastfetch
fi
