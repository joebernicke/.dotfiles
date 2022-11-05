" Setup {{{1



set nocompatible

colorscheme eldar
syntax enable
"hi Normal ctermbg=none
"highlight NonText ctermbg=none
"highlight LineNr ctermbg=none
let g:slime_target="tmux"
let g:slime_default_config = {"socket_name": get(split($TMUX, ","), 0), "target_pane": ":0.1"}
let g:ycm_path_to_python_interpreter = '/usr/bin/python'
let g:slime_python_ipython = 1
let g:slime_cell_delimiter = "```"
nmap <leader>s <Plug>SlimeSendCell
autocmd FileType md normal zM
set background=dark
let vim_markdown_preview_hotkey='<C-l>'
let vim_markdown_preview_pandoc=1


let g:markdown_fenced_languages = ['python']
set runtimepath^=~/.fzf
set runtimepath^=~/.
set runtimepath+=.
set packpath+=.
set autoread
set backspace=2
set backup
set backupskip=/tmp/*,/private/tmp/*",*.gpg
set backupdir=~/.vim/tmp,/tmp
set browsedir=buffer
set directory=~/.vim/tmp,/tmp
set encoding=utf-8
set dictionary=~/.vim/spell/eng.utf-8
set expandtab
set fileencodings=utf-8
set fileformats=unix,dos,mac
set foldmethod=marker
set formatprg=par
set hidden
set history=1000
set ignorecase
set incsearch
set laststatus=1
set list
set listchars=tab:▸\ ,eol:¬
set mouse=a
set noequalalways
set nohlsearch
set nojoinspaces
set number
set omnifunc=syntaxcomplete#Complete
set path+=**
set shiftround
set shiftwidth=4
set showcmd
set shortmess=filnxtToOI
set splitbelow
set splitright
set smartcase
set smartindent
set spelllang=eng
set tabstop=4
set timeoutlen=600
set ttyfast
set visualbell t_vb=".
" set wildcharm=<C-z>
" set wildignorecase
" set wildmenu
" set wildmode=longest,list
" set wrapmargin=0
" set wrap
" Necessary order
set linebreak
set textwidth=0
set display=lastline
" GUI options {{{2
" if has("gui_running")
"     set guioptions-=T
"     set guioptions-=r
"     set guioptions-=R
"     set guioptions-=m
"     set guioptions-=l
"     set guioptions-=L
"     set guitablabel=%t
" endif
" Variables {{{2
let g:python_host_prog  = '/usr/bin/python2'
let g:python3_host_prog = '/usr/bin/python3'
let vim_markdown_preview_hotkey='<C-q>'

" Plugin Options {{{1

" vimtex {{{2
" }}}1

call plug#begin('~/.vim/plugged') "Vim plug

Plug 'lervag/vimtex'

call plug#end()

let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
set conceallevel=1
let g:tex_conceal='abdmg'


" vim-surround {{{2
let g:surround_42 = "**\r**"
nnoremap ** :exe "norm v$hS*"<cr>
nnoremap __ :exe "norm v$hS_"<cr>
vmap * S*
vmap _ S_
vmap <leader>l <Plug>VSurround]%a(<C-r><C-p>+)<Esc>
" syntastic {{{2
let g:syntastic_javascript_checkers = ['jshint']
let g:syntastic_enable_highlighting = 0
let g:syntastic_java_javac_config_file_enabled = 1
" YouCompleteMe {{{2
"let g:ycm_global_ycm_extra_conf = '$HOME/.vim/bundle/YouCompleteMe/cpp/ycm/.ycm_extra_conf.py'
"let g:ycm_filetype_blacklist = {
"\ 'pdf' : 1,
"\}

" Tagbar {{{2
let g:tagbar_width = 80
let g:tagbar_sort = 0
" vim-pandoc {{{2
let g:pandoc#filetypes#handled = ["pandoc", "markdown", "textile"]
let g:pandoc#biblio#use_bibtool = 1
let g:pandoc#completion#bib#mode = 'citeproc'
let g:pandoc#biblio#bibs = ["articles/bib.bib"]
let g:pandoc#syntax#conceal#use = 0
let g:pandoc#folding#fdc = 0
let g:pandoc#folding#level = 999
" netrw {{{2
let g:netrw_http_cmd = "qutebrowser"
let g:netrw_browsex_viewer = "xdg-open"
" Pandoc and Notes {{{2
set cc=84
hi ColorColumn ctermbg=darkgrey guibg=darkgrey
command! -nargs=1 Ngrep lvimgrep "<args>" $NOTES_DIR/**/*.txt
nnoremap <leader>[ :Ngrep 

command! -range=% Rst :'<,'>!pandoc -f markdown -t rst

nnoremap 'ms :w!<cr>:exe "!pandoc -t beamer -o " . fnameescape(expand('%:p:r')) . ".pdf " . fnameescape(expand('%:p'))<cr>
nnoremap 'mh :w!<cr>:exe "!pandoc --pdf-engine=lualatex -H ~/.config/pandoc/fonts.tex -o " . fnameescape(expand('%:p:r')) . ".pdf " . fnameescape(expand('%:p'))<cr>
nnoremap 'md :w!<cr>:exe "!pandoc --pdf-engine=lualatex -H ~/.config/pandoc/fonts.tex -o $HOME/" . fnameescape(expand('%:t:r')) . ".pdf " . fnameescape(expand('%:p'))<cr>
" nnoremap 'mp :w!<cr>:exe "!pandoc -s --highlight-style=tango --toc --pdf-engine=lualatex --template=template.tex -V colorlinks=true -H ~/.config/pandoc/fonts.tex -o " . fnameescape(expand('%:t:r')) . ".pdf " . fnameescape(expand('%:p')) . " && xdg-open " . fnameescape(expand('%:t:r')) . ".pdf"<cr>

nnoremap 'mp :w!<cr>:exe "!pandoc --toc --pdf-engine=lualatex --filter pandoc-latex-environment -V colorlinks=true -H ~/.config/pandoc/fonts.tex -o " . fnameescape(expand('%:t:r')) . ".pdf " . fnameescape(expand('%:p')) . " && xdg-open " . fnameescape(expand('%:t:r')) . ".pdf"<cr>

" "#nnoremap 'mp :w!<cr>:exe "!pandoc -s --toc --pdf-engine=lualatex -V colorlinks=true -H ~/.config/pandoc/fonts.tex -o /tmp/" . fnameescape(expand('%:t:r')) . ".pdf " . fnameescape(expand('%:p')) . " && xdg-open /tmp/" . fnameescape(expand('%:t:r')) . ".pdf"<cr>

"nnoremap 'mp :w!<cr>:exe "!wslview " . fnameescape(expand('%:t:r')) . ".pdf " . fnameescape(expand('%:p')) . " && xdg-open /tmp/" . fnameescape(expand('%:t:r')) . ".pdf"<cr>

" Extended Text Objects {{{2
let s:items = [ "<bar>", "\\", "/", ":", ".", "*", "_" ]
for item in s:items
    exe "nnoremap yi".item." T".item."yt".item
    exe "nnoremap ya".item." F".item."yf".item
    exe "nnoremap ci".item." T".item."ct".item
    exe "nnoremap ca".item." F".item."cf".item
    exe "nnoremap di".item." T".item."dt".item
    exe "nnoremap da".item." F".item."df".item
    exe "nnoremap vi".item." T".item."vt".item
    exe "nnoremap va".item." F".item."vf".item
endfor
" Select within fold
nnoremap viz v[zo]z$
nnoremap <space> za
" Mappings {{{3
" File navigation {{{2
" . = location of current file
nnoremap '.  :exe ":FZF " . expand("%:h")<CR>
" / = /
nnoremap '/  :e /<C-d>
" b = buffers
nnoremap 'b  :Buffers<cr>
" c = config
nnoremap 'c  :FZF ~/.config/<cr>
" d = documents
nnoremap 'd  :FZF ~/Documents/<cr>
" f = fzf
nnoremap 'f  :FZF<cr>
" g = grep (ripgrep)
nnoremap 'g  :Rg
" h = home
nnoremap 'h  :FZF ~/<cr>
" n = notes
nnoremap 'n  :FZF $NOTES_DIR/<cr>
" t = tags
nnoremap 't  :Tags<cr>
" r = bashrc
nnoremap 'r  :e ~/.bashrc<cr>
" v = vimrc
nnoremap 'v  :e $MYVIMRC<cr>
" toggle last buffer
nnoremap ''  :b#<cr>

" Leaders {{{2
nnoremap <leader>\ :!chmod +x %<cr>:!%:p<cr>
nnoremap <leader>. :cd %:h<cr>
nnoremap <leader>a :Archive<cr>
inoremap <leader>d <C-r>=strftime('%D %l:%M%P')<cr>
inoremap <leader>D <C-r>=strftime('%D')<cr>
"nnoremap <leader>d :delete the current file
"inoremap <leader>i import code; code.interact(local=dict(globals(), **locals()))<esc>
nnoremap <leader>n :exe "e $NOTES_DIR/Scratch/stash/".strftime("%F-%H%M%S").".md"<cr>
nnoremap <leader>q :q!<cr>
"nnoremap <leader>s :set spell!<cr>
nnoremap <leader>w :w<cr>
nnoremap <leader>x :sign unplace *<cr>
nnoremap <leader>z :wq!<cr>
vnoremap <leader>d "_d
vnoremap <leader>q <esc>:q!<cr>


" Commands and Functions {{{1
" Notes {{{2
command! Archive  cd $NOTES_DIR | exe "sav Scratch/stash/" . strftime("%s") . ".md"
" Pack {{{2
command! PackUpdate echo system('find ~/.vim/pack/bundle/start/*/. -maxdepth 0 -execdir pwd \; -execdir git pull \;')
command! PackList echo system('ls ~/.vim/pack/bundle/start')
command! -nargs=1 PackInstall echo system('cd ~/.vim/pack/bundle/start && git clone git@github.com:<args>.git')
command! -nargs=1 PackUninstall echo system('rm -rf ~/.vim/pack/bundle/start/<args>')
" Ix {{{2
command! -range=% Ix :<line1>,<line2>call Ix()
fun! Ix() range
    call setreg("+", system('ix', join(getline(a:firstline, a:lastline), "\n")))
endfun
" Tabularize {{{2
vnoremap <leader>t j:call <SID>table()<cr>
inoremap <silent> <Bar>   <Bar><Esc>:call <SID>align()<CR>a
fun! s:align()
    let p = '^\s*|\s.*\s|\s*$'
    if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
        let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
        let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
        Tabularize/|/l1
        normal! 0
        call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
    endif
endfun
fun! s:table() range
    exe "'<,'>Tab /|"
    let hsepline= substitute(getline("."),'[^|]','-','g')
    exe "norm! o" .  hsepline
    exe "'<,'>s/-|/ |/g"
    exe "'<,'>s/|-/| /g"
    exe "'<,'>s/^| \\|\\s*|$\\||//g"
endfun
" Symbol Shortcuts {{{1
" Greek {{{2
map! <C-v>GA Γ
map! <C-v>DE Δ
map! <C-v>TH Θ
map! <C-v>LA Λ
map! <C-v>XI Ξ
map! <C-v>PI Π
map! <C-v>SI Σ
map! <C-v>PH Φ
map! <C-v>PS Ψ
map! <C-v>OM Ω
map! <C-v>al α
map! <C-v>be β
map! <C-v>ga γ
map! <C-v>de δ
map! <C-v>ep ε
map! <C-v>ze ζ
map! <C-v>et η
map! <C-v>th θ
map! <C-v>io ι
map! <C-v>ka κ
map! <C-v>la λ
map! <C-v>mu μ
map! <C-v>xi ξ
map! <C-v>pi π
map! <C-v>rh ρ
map! <C-v>si σ
map! <C-v>sis σ²
map! <C-v>ta τ
map! <C-v>ps ψ
map! <C-v>om ω
map! <C-v>ph ϕ
" Math {{{2
map! <C-v>ll →
map! <C-v>hh ⇌
map! <C-v>kk ↑
map! <C-v>jj ↓
map! <C-v>= ∝
map! <C-v>~ ≈
map! <C-v>!= ≠
map! <C-v>!> ⇸
map! <C-v>~> ↝
map! <C-v>>= ≥
map! <C-v><= ≤
map! <C-v>0  °
map! <C-v>ce ¢
map! <C-v>*  •
map! <C-v>co ⌘

" Bracket Completer {{{2 
inoremap { {}<Esc>ha
inoremap ( ()<Esc>ha
inoremap [ []<Esc>ha
inoremap $ $$<Esc>ha
inoremap ][  <C-o>l
inoremap oj <Esc>
nnoremap 'ip :!ipython<cr>
inoremap bc because

" Subscript and Superscript {{{2
inoremap <leader>1 ~1~
inoremap <leader>2 ~2~
inoremap <leader>3 ~3~
inoremap <leader>4 ~4~
inoremap <leader>5 ~5~
inoremap <leader>6 ~6~
inoremap <leader>7 ~7~
inoremap <leader>8 ~8~
inoremap <leader>9 ~9~
inoremap <leader>== ^+^
inoremap <leader>=2 ^2+^
inoremap <leader>=3 ^3+^
inoremap <leader>-- ^-^
inoremap <leader>-2 ^2-^
inoremap <leader>-3 ^3-^

" Subscript and Superscript {{{2
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
" }}} vim: fdm=marker



