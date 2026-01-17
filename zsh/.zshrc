# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd beep extendedglob nomatch notify
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/diego/.zshrc'

# Enhanced autocompletion
autoload -Uz compinit
# Check if .zcompdump is older than 24 hours, or if it doesn't exist
if [[ -n ${HOME}/.zcompdump(#qN.mh+24) ]]; then
	compinit -d "${HOME}/.zcompdump"
else
	compinit -C -d "${HOME}/.zcompdump"
fi

# Enhanced completion options
setopt AUTO_LIST
setopt AUTO_MENU
setopt COMPLETE_IN_WORD
setopt ALWAYS_TO_END

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'

eval "$(starship init zsh)"
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
