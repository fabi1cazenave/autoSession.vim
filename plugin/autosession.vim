"|
"| File          : ~/.vim/plugin/autosession.vim
"| Last modified : 2012-02-24
"| Author        : Fabien Cazenave <fabien@cazenave.cc>
"| Licence       : WTFPL
"|
"| Automatic session management:
"|   - if Vim is started without any command-line argument,
"|       the local .vimSession file is sourced on load;
"|   - ZZ now saves all files, creates a session and exits.
"|
"| To use from ranger, append this line to ~/.config/ranger/rc.conf:
"|   map e shell vim
"|

if has('autocmd')

  " debug mode
  autocmd! BufWritePost autosession.vim source ~/.vim/plugin/autosession.vim

  " source the local .vimSession file on load
  function! AutostartSession()
    let g:SessionLoaded = 0
    let g:SessionPath = getcwd() . '/.vimSession'
    if ((argc() == 0) && filereadable(g:SessionPath))
      "source .vimSession
      exec 'source ' . g:SessionPath
      let g:SessionLoaded = 1
    endif
  endfunction
  autocmd! VimEnter * call AutostartSession()

  " ZZ now saves all files, creates a session and exits
  function! AutocloseSession()
    if g:SessionLoaded || !filereadable(g:SessionPath)
      exec 'mksession! ' . g:SessionPath
    endif
    wqall
  endfunction
  noremap <silent> ZZ :call AutocloseSession()<CR>

  " experimental
  noremap <silent> ZC :set sessionoptions="folds,tabpages,winsize"<CR> :call AutocloseSession()<CR>
  noremap <silent> ZV :exec 'source ' . getcwd() . '/.vimSession'<CR>

endif

