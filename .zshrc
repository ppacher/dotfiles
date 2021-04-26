export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="ys"
#ZSH_THEME="paz"
plugins=(git forgit dotbare fzf-zsh-completions)

source $ZSH/oh-my-zsh.sh

#----------------------------------------------------------------------------
# User configuration
#----------------------------------------------------------------------------

#
# Profile support
#
source ${HOME}/.profile

# Dotbare
export DOTBARE_DIR="$HOME/.cfg"
export DOTBARE_TREE="$HOME"

export PAGER="less"

#
# FZF
#
source /usr/share/fzf/completion.zsh
source /usr/share/fzf/key-bindings.zsh

#
# Emoji-cli
#
source /usr/share/zsh/plugins/emoji-cli/emoji-cli.zsh

#
# Colorize manpages
#
man() {
    LESS_TERMCAP_md=$'\e[01;31m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[01;44;33m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[01;32m' \
    command man "$@"
}


set -k                     # Allow comments in shell
setopt auto_cd             # cd by just typing the directory name

#
# Prompts
#

command_not_found_handler() {
    printf 'Command not found ->\033[32;05;16m %s\033[0m \n' "$0" >&2
    return 127
}

setopt prompt_subst
#PROMPT='%F{5}%F{%(?.6.1)} > %f% '
#PROMPT='%F{5}%F{%(?.6.1)} > %f%F{8}|%f '

export SUDO_PROMPT=$'Password for ->\033[32;05;16m %u\033[0m:  '


#
#  History
#

HISTSIZE=999999
SAVEHIST=999999
HISTFILE="${ZDOTDIR:-$HOME}/zsh_history"
setopt extended_history   # Record timestamp of command in HISTFILE
setopt hist_ignore_dups   # Ignore duplicated commands history list
setopt share_history      # Save command history before exiting

#
#  Autocompletion
#

setopt NO_NOMATCH   # disable some globbing
setopt complete_in_word
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' matcher-list \
    'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
    autoload -U compinit && compinit -C



# Useful aliases
alias c='clear'
alias ..='cd ..'
alias v="nvim"
alias ls='exa --color=auto'
alias vim=nvim
alias icat="kitty +kitten icat"
alias l='exa -l'
alias la='exa -a'
alias lla='exa -la'
alias lt='exa --tree'
alias cat='bat --color always --plain'
alias xwin='Xephyr -br -ac -noreset -screen 1400x800 :1'
alias xdisp='DISPLAY=:1 '
alias fetish="info='n os wm sh cpu mem kern term pkgs col n' accent=4 separator='  ' fet.sh"
alias grep='grep --color=auto'

alias firefox='MOZ_X11_EGL=1 firefox'

alias fonty='fontpreview-ueberzug -b "#1a2026" -f "#ffffff"'

alias yt="YTFZF_EXTMENU=' rofi -dmenu -fuzzy' ytfzf -D"

alias ssh-klinik-router="ssh admin@192.168.0.1 -oKexAlgorithms=+diffie-hellman-group1-sha1 -oHostKeyAlgorithms=ssh-dss -c aes256-cbc"


# window titles
precmd() {
    printf '\033]0;%s\007' "$(dirs)"
}

source ~/.zsh-plugins/fzf-tab/fzf-tab.plugin.zsh

# Solarized colors
export FZF_DEFAULT_OPTS='
--color fg:#ffffff,bg:#1a2026,hl:#A3BE8C,fg+:#D8DEE9,bg+:#1a2026,hl+:#A3BE8C,border:#3b4b58
--color pointer:#f9929b,info:#4C566A,spinner:#4C566A,header:#4C566A,prompt:#9ce5c0,marker:#EBCB8B
'

FZF_TAB_COMMAND=(
    fzf
    --ansi
    --expect='$continuous_trigger' # For continuous completion
    --nth=2,3 --delimiter='\x00'  # Don't search prefix
    --layout=reverse --height="''${FZF_TMUX_HEIGHT:=50%}"
    --tiebreak=begin -m --bind=tab:down,btab:up,change:top,ctrl-space:toggle --cycle
    '--query=$query'   # $query will be expanded to query string at runtime.
    '--header-lines=$#headers' # $#headers will be expanded to lines of headers at runtime
)
zstyle ':fzf-tab:*' command $FZF_TAB_COMMAND

zstyle ':completion:complete:*:options' sort false
zstyle ':fzf-tab:complete:_zlua:*' query-string input

zstyle ':fzf-tab:complete:*:*' fzf-preview '$HOME/.bin/preview.sh $realpath'

# Set PATH so it includes user's private bin directories
export PATH="${HOME}/.bin:${HOME}/.local/bin:${HOME}/go/bin:${HOME}/.emacs.d/bin/:${PATH}"

clear ; lastlogin ; fetch

#alias luamake=/home/javacafe01/git-stuff/lua-language-server/3rd/luamake/luamake
