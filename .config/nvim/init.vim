if exists("g:vscode")
    " this is vscode, return
    exit
endif

"
"--- Plugins ---"
source $HOME/.config/nvim/vim-plug/plugins.vim

"--- Settings ---"
source $HOME/.config/nvim/general/settings.vim

"--- Key Bindings ---"
source $HOME/.config/nvim/keys/mappings.vim

"--- Theme ---"
source $HOME/.config/nvim/themes/airline.vim
source $HOME/.config/nvim/statusline.vim
source $HOME/.config/nvim/tabbar.vim

set viminfo='100,n$HOME/.vim/files/info/viminfo
