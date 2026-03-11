set relativenumber
set clipboard=unnamedplus  " Tries native sync (limited on Wayland Vim)

" Pipe paste from Wayland
nnoremap <leader>p "+p
nnoremap <leader>P "+P
xnoremap <expr> "+y 'y:call system("wl-copy", @")<CR>'  " Visual yank to clipboard
nnoremap <expr> "+y 'y:call system("wl-copy", @")<CR>'  
nnoremap <expr> "+p ':let @+=substitute(system("wl-paste --no-newline"), "\\\n", "", "g")<CR>p'  
nnoremap <expr> "*p ':let @+=substitute(system("wl-paste --no-newline --primary"), "\\\n", "", "g")<CR>p'  

