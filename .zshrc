export ZSH="$HOME/.oh-my-zsh"

#ZSH_THEME="ys"
ZSH_THEME="paz"

plugins=(git forgit dotbare fzf-zsh-completions)

source $ZSH/oh-my-zsh.sh

#----------------------------------------------------------------------------
# User configuration
#----------------------------------------------------------------------------

#
# Profile support
#
source ${HOME}/.profile

#
# Aliases
#
alias v=nvim
alias icat="kitty +kitten icat"

#
# Enable common command replacments
#
alias cat=bat 
alias ls=exa

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

clear ; lastlogin ; fetch
