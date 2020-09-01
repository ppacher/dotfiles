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
alias c="clear"
alias systemctl="systemctl --user"

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

#clear ; lastlogin ; fetch
