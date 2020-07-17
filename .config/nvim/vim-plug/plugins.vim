" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  "autocmd VimEnter * PlugInstall
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/autoload/plugged')
    " Git Status
    Plug 'tpope/vim-fugitive'

    " Format
    Plug 'andrejlevkovitch/vim-lua-format'

    " --------- adding the following three plugins for Latex ---------
    Plug 'lervag/vimtex'
    Plug 'Konfekt/FastFold'
    Plug 'matze/vim-tex-fold'    

    Plug 'xolox/vim-notes'
    Plug 'xolox/vim-misc'
    Plug 'VundleVim/Vundle.vim'
    "Plug 'itchyny/lightline.vim'
    "Plug 'vim-airline/vim-airline'
    "Plug 'vim-airline/vim-airline-themes'
    "Plug 'ryanoasis/vim-devicons'
    Plug 'preservim/nerdtree'
    Plug 'mhinz/vim-startify'
    "    Plug 'sprockmonty/wal.vim'
    Plug 'dylanaraps/wal.vim'
    Plug 'artur-shaik/vim-javacomplete2'
    Plug 'sainnhe/gruvbox-material'
if has('nvim')
   Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
    Plug 'Shougo/deoplete.nvim'
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
endif
    Plug 'christoomey/vim-tmux-navigator'
call plug#end()

" Automatically install missing plugins on startup
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif
