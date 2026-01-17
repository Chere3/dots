# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000              # Larger history for better autosuggestions
SAVEHIST=10000              # Save more history
setopt SHARE_HISTORY        # Share history between sessions
setopt HIST_IGNORE_DUPS     # Don't save duplicate commands
setopt HIST_IGNORE_SPACE    # Don't save commands starting with space
setopt HIST_VERIFY          # Show command with history expansion before running
setopt HIST_EXPIRE_DUPS_FIRST # Expire duplicates first
setopt autocd beep extendedglob nomatch notify
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/diego/.zshrc'

# Enhanced autocompletion
# Set up fpath for completions (must be before compinit)
typeset -U fpath
fpath=($fpath /usr/share/zsh/site-functions)
[[ -d /usr/share/zsh/functions/Completion ]] && fpath=(/usr/share/zsh/functions/Completion $fpath)
[[ -d /usr/share/zsh-completions ]] && fpath=(/usr/share/zsh-completions $fpath)

# Load completion system
autoload -Uz compinit

# Initialize completion system with caching
# Rebuild if dump file doesn't exist or is older than 24 hours
if [[ ! -f "${HOME}/.zcompdump" ]] || [[ -n ${HOME}/.zcompdump(#qN.mh+24) ]]; then
	compinit -d "${HOME}/.zcompdump"
else
	compinit -C -d "${HOME}/.zcompdump"
fi

# Enhanced completion options
setopt AUTO_LIST              # Automatically list choices on ambiguous completion
setopt AUTO_MENU              # Show completion menu on successive tab presses
setopt AUTO_PARAM_SLASH       # If completed parameter is a directory, add trailing slash
setopt COMPLETE_IN_WORD       # Complete from both ends of a word
setopt ALWAYS_TO_END          # Move cursor to end of word after completion
setopt LIST_PACKED            # Use compact completion lists
setopt LIST_ROWS_FIRST        # Matches are sorted in rows
setopt COMPLETE_ALIASES       # Complete aliases

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Completion menu colors
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Menu selection
zstyle ':completion:*:*:*:*:*' menu select

# Process completion colors
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"

# Directory completion
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories

# Group completion results
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'

# Caching for faster completion
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path "${HOME}/.zsh/cache"
# Create cache directory if it doesn't exist
[[ ! -d "${HOME}/.zsh/cache" ]] && mkdir -p "${HOME}/.zsh/cache"

# Don't ignore completion functions - they all start with _

# Better completion for kill
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always

# Better completion for cd
zstyle ':completion:*:cd:*' menu yes select

# Completion for sudo
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin

# Fuzzy matching
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

eval "$(starship init zsh)"

# Fish-like autosuggestions (real-time suggestions as you type)
# Install with: sudo pacman -S zsh-autosuggestions
if [[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
	source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
	# Configure autosuggestions
	ZSH_AUTOSUGGEST_STRATEGY=(history completion)  # Try history first, then completions
	ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#6c7086,bold"  # Catppuccin overlay0 color
	ZSH_AUTOSUGGEST_USE_ASYNC=true  # Async suggestions for better performance
	# Keybindings: Accept suggestion with right arrow (like Fish)
	bindkey '^[[C' forward-char
	bindkey '→' autosuggest-accept
	# Accept partial suggestion word by word
	bindkey '^[[1;5C' forward-word
elif [[ -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
	source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
	ZSH_AUTOSUGGEST_STRATEGY=(history completion)
	ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#6c7086,bold"
	ZSH_AUTOSUGGEST_USE_ASYNC=true
	bindkey '^[[C' forward-char
	bindkey '→' autosuggest-accept
	bindkey '^[[1;5C' forward-word
fi

# Fish-like syntax highlighting (colors commands as you type)
# Install with: sudo pacman -S zsh-syntax-highlighting
# MUST be loaded LAST so it can hook into all widgets
if [[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
	source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
	# Configure syntax highlighting colors (Catppuccin Mocha theme)
	ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
	# Valid commands in green
	ZSH_HIGHLIGHT_STYLES[command]='fg=#a6e3a1'
	ZSH_HIGHLIGHT_STYLES[alias]='fg=#a6e3a1,bold'
	ZSH_HIGHLIGHT_STYLES[builtin]='fg=#a6e3a1'
	ZSH_HIGHLIGHT_STYLES[function]='fg=#a6e3a1'
	# Invalid commands in red
	ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#f38ba8'
	# Paths in cyan
	ZSH_HIGHLIGHT_STYLES[path]='fg=#94e2d5'
	ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=#94e2d5'
	# Strings in yellow
	ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#f9e2af'
	ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#f9e2af'
	# Options/flags in blue
	ZSH_HIGHLIGHT_STYLES[option]='fg=#89b4fa'
	ZSH_HIGHLIGHT_STYLES[arg0]='fg=#89b4fa'
elif [[ -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
	source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
	ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
	ZSH_HIGHLIGHT_STYLES[command]='fg=#a6e3a1'
	ZSH_HIGHLIGHT_STYLES[alias]='fg=#a6e3a1,bold'
	ZSH_HIGHLIGHT_STYLES[builtin]='fg=#a6e3a1'
	ZSH_HIGHLIGHT_STYLES[function]='fg=#a6e3a1'
	ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#f38ba8'
	ZSH_HIGHLIGHT_STYLES[path]='fg=#94e2d5'
	ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=#94e2d5'
	ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#f9e2af'
	ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#f9e2af'
	ZSH_HIGHLIGHT_STYLES[option]='fg=#89b4fa'
	ZSH_HIGHLIGHT_STYLES[arg0]='fg=#89b4fa'
fi

# End of lines added by compinstall

# bun completions
[ -s "/home/diego/.bun/_bun" ] && source "/home/diego/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# bum
export BUM_INSTALL="$HOME/.bum"
export PATH="$BUM_INSTALL/bin:$PATH"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"

# fnm
FNM_PATH="/home/diego/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "`fnm env`"
fi
