# Powerlevel10k configuration for BLUX10K (lean variant)
# Generated for MesloLGS NF Nerd Font

local -a POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs command_execution_time newline virtualenv prompt_char)
local -a POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status node_version aws)

typeset -g POWERLEVEL9K_MODE=nerdfont-complete

typeset -g POWERLEVEL9K_BACKGROUND=transparent
typeset -g POWERLEVEL9K_ICON_PADDING=moderate
typeset -g POWERLEVEL9K_ICON_BEFORE_CONTENT=true
typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

# Directory styling
typeset -g POWERLEVEL9K_DIR_FOREGROUND=39
typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=81
typeset -g POWERLEVEL9K_DIR_ANCHOR_BOLD=true
typeset -g POWERLEVEL9K_DIR_MAX_LENGTH=80
typeset -g POWERLEVEL9K_DIR_MIN_COMMAND_COLUMNS=40
typeset -g POWERLEVEL9K_DIR_MIN_COMMAND_COLUMNS_PCT=50

# Git styling
typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=$'\uF126 '
typeset -g POWERLEVEL9K_VCS_UNTRACKED_ICON='?'

# Prompt characters
typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_FOREGROUND=201
typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_FOREGROUND=160

# Command execution time
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=0

# Status segment
typeset -g POWERLEVEL9K_STATUS_OK_FOREGROUND=70
typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND=160

# Virtualenv styling
typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND=245
typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_PYTHON_VERSION=false

# Transient prompt
typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=always

# Instant prompt disabled to avoid conflicts with startup output
typeset -g POWERLEVEL9K_INSTANT_PROMPT=off
