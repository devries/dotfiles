" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" allow hidden buffers
set hidden

" Set listchars for UTF-8 terminals
set listchars=tab:→‣,trail:·,precedes:«,extends:»,eol:⏎

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" This is an alternative that also works in block mode, but the deleted
" text is lost and it only works for putting the current register.
"vnoremap p "_dp

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Let's get used to using hjkl
" nnoremap <Down> <Nop>
" nnoremap <Left> <Nop>
" nnoremap <Right> <Nop>
" nnoremap <Up> <Nop>

" Indentation Options
set tabstop=2
set shiftwidth=2
set smarttab
set expandtab
set softtabstop=2

" Turn on line numbering
set number

" Use escape to escape from terminal mode
tnoremap <Esc> <C-\><C-n>

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Set arduino sketches to use C mode
  augroup filetype_c
    au!
    autocmd BufRead,BufNewFile *.ino set filetype=c
    autocmd BufRead,BufNewFile *.pde set filetype=c
  augroup END

  " For all text files set 'textwidth' to 78 characters.
  augroup filetype_text
    au!
    autocmd BufRead,BufNewFile *.txt set filetype=text
    autocmd BufRead,BufNewFile *.md set filetype=text
    autocmd FileType text setlocal cc=80
    autocmd FileType text setlocal spell spelllang=en_us
    autocmd FileType text setlocal tabstop=4
    autocmd FileType text setlocal shiftwidth=4
    autocmd FileType text setlocal softtabstop=4
  augroup END

  " LaTeX file settings
  let g:tex_flavor = "latex"
  augroup filetype_latex
    au!
    autocmd FileType tex setlocal spell spelllang=en_us
    autocmd FileType tex setlocal cc=78
    autocmd FileType tex setlocal textwidth=78
    autocmd FileType tex imap " ``''<Left><Left>
  augroup END

  " Python Indentation
  augroup filetype_python
    au!
    autocmd FileType python setlocal shiftwidth=4 softtabstop=4 tabstop=8
    autocmd FileType python setlocal cc=72,99
  augroup END

  " YAML
  augroup filetype_yaml
    au!
    autocmd FileType yaml setlocal cursorcolumn
  augroup END

  " Go Indentation and formatting
  function! s:GoPreSave()
    let s:save_pos=getpos(".")
    execute "'[,']!gofmt 2> /dev/null"
    if v:shell_error
      execute "u"
    endif
  endfunction

  " Run program through go pls checker
  function! s:GoPostSave()
    let s:gopls_output = system('gopls check ' . shellescape(expand('%:p')) . " 2>/dev/null")
    if len(s:gopls_output) != 0
      cexpr s:gopls_output
      copen
    else
      cclose
    endif
  endfunction

  " Manually check Program
  command GoCheck cexpr system('gopls check ' . shellescape(expand('%:p')) . " 2>/dev/null")

  augroup filetype_go
    au!
    autocmd BufRead,BufNewFile *.go set filetype=go
    autocmd FileType go setlocal noexpandtab shiftwidth=2 softtabstop=2 tabstop=2
    autocmd BufWritePre,FileWritePre      *.go call s:GoPreSave()
    autocmd BufWritePost,FileWritePost    *.go call setpos(".", s:save_pos)
    autocmd BufWritePost,FileWritePost    *.go call s:GoPostSave()
    " autocmd BufWritePost,FileWritePost    *.go execute ":Neomake go"
  augroup END

  augroup encrypted
      au!
      " First make sure nothing is written to ~/.viminfo while editing
    " an encrypted file.
    autocmd BufReadPre,FileReadPre      *.gpg set viminfo=
    " We don't want a swap file, as it writes unencrypted data to disk
    autocmd BufReadPre,FileReadPre      *.gpg set noswapfile
    " Switch to binary mode to read the encrypted file
    autocmd BufReadPre,FileReadPre      *.gpg set bin
    autocmd BufReadPre,FileReadPre      *.gpg let ch_save = &ch|set ch=2
    autocmd BufReadPost,FileReadPost    *.gpg '[,']!gpg --decrypt 2> /dev/null
    " Switch to normal mode for editing
    autocmd BufReadPost,FileReadPost    *.gpg set nobin
    autocmd BufReadPost,FileReadPost    *.gpg let &ch = ch_save|unlet ch_save
    autocmd BufReadPost,FileReadPost    *.gpg execute ":doautocmd BufReadPost " . expand("%:r")

    " Convert all text to encrypted text before writing
    autocmd BufWritePre,FileWritePre    *.gpg   '[,']!gpg --default-recipient-self -ae 2>/dev/null
    " Undo the encryption so we are back in the normal text, directly
    " after the file has been written.
    autocmd BufWritePost,FileWritePost    *.gpg   u
  augroup END

  augroup kmsencrypted
    au!
    "First make sure nothing is written to ~/.viminfo while editing
    autocmd BufReadPre,FileReadPre      *.crypt set viminfo=
    " We don't want a swap file, as it writes unencrypted data to disk
    autocmd BufReadPre,FileReadPre      *.crypt set noswapfile
    " Decrypt after reading
    autocmd BufReadPost,FileReadPost    *.crypt '[,']!pdecrypt
    " Switch to normal mode for editing
    autocmd BufReadPost,FileReadPost    *.crypt execute ":doautocmd BufReadPost " . expand("%:r")
    " Encrypt all text before writing
    autocmd BufWritePre,FileWritePre    *.crypt let s:save_pos=getpos(".")
    autocmd BufWritePre,FileWritePre    *.crypt '[,']!pencrypt
    " Undo encryption after writing file
    autocmd BufWritePost,FileWritePost  *.crypt u
    autocmd BufWritePost,FileWritePost  *.crypt call setpos(".", s:save_pos)
  augroup END 

  augroup gkmsencrypted
    au!
    "First make sure nothing is written to ~/.viminfo while editing
    autocmd BufReadPre,FileReadPre      *.gcrypt set viminfo=
    " We don't want a swap file, as it writes unencrypted data to disk
    autocmd BufReadPre,FileReadPre      *.gcrypt set noswapfile
    " Decrypt after reading
    autocmd BufReadPost,FileReadPost    *.gcrypt '[,']!pgdecrypt
    " Switch to normal mode for editing
    autocmd BufReadPost,FileReadPost    *.gcrypt execute ":doautocmd BufReadPost " . expand("%:r")
    " Encrypt all text before writing
    autocmd BufWritePre,FileWritePre    *.gcrypt let s:save_pos=getpos(".")
    autocmd BufWritePre,FileWritePre    *.gcrypt '[,']!pgencrypt
    " Undo encryption after writing file
    autocmd BufWritePost,FileWritePost  *.gcrypt u
    autocmd BufWritePost,FileWritePost  *.gcrypt call setpos(".", s:save_pos)
  augroup END 

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Set scp command to be silend
let g:netrw_scp_cmd= "scp -q"
let g:netrw_sftp_cmd= "sftp -q"
let g:netrw_list_cmd= "ssh -q HOSTNAME ls -FLa"

colorscheme cdevries

if exists("backupcopy")
    set backupcopy=yes,breakhardlink
endif
