" Tabs
set tabstop=4 softtabstop=0 expandtab shiftwidth=0 smarttab

" Set cursor blink settings.
set cursorline
highlight Cursor guifg=white guibg=black
highlight iCursor guifg=white guibg=steelblue
set guicursor=n-v-c:block-Cursor
set guicursor+=i:ver100-iCursor
set guicursor+=n-v-c:blinkon10
set guicursor+=i:blinkwait10
let mapleader=" "
nnoremap <SPACE> <Nop>

 
" Set hybrid line numbers
set number relativenumber
set nu rnu

" Plugins
call plug#begin()
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'tomasiser/vim-code-dark'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-tree/nvim-tree.lua'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'branch': '0.1.x' }
Plug 'cljoly/telescope-repo.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
Plug 'fannheyward/telescope-coc.nvim'
Plug 'airblade/vim-gitgutter'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'svermeulen/vim-cutlass'
Plug 'tpope/vim-sleuth'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
call plug#end()

" copy-pasting
set clipboard +=unnamedplus
nnoremap m d
xnoremap m d
nnoremap mm dd
nnoremap M D

" air-line
let g:airline_theme='molokai'
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" airline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''

" Settings for coc.nvim
set nobackup
set nowritebackup
set updatetime=30
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <C-j>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<C-j>" :
      \ coc#refresh()
inoremap <expr><C-k> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <silent> <leader>]g :CocDiagnostics<CR>

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nnoremap `` <C-o>
nmap <C-n> <Plug>(coc-rename)
xmap <leader>f <Plug>(coc-format-selected)
nmap <leader>f <Plug>(coc-format-selected)
nnoremap <silent> gb <Plug>(coc-diagnostic-info)

nnoremap <silent> gh :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('gh', 'in')
  endif
endfunction

" Theme
syntax on
colorscheme codedark


" telescope.nvim settings
nnoremap <leader>p <cmd>Telescope find_files<CR>
nnoremap <leader><S-f> <cmd>Telescope live_grep<CR>
nnoremap <leader><S-b> <cmd>Telescope buffers<CR>
nnoremap <leader>t <cmd>Telescope coc workspace_symbols<CR>
nnoremap <leader>r <cmd>Telescope repo list<CR>

" Nvim-tree 

nnoremap <silent> <leader>e :NvimTreeToggle<CR>
nnoremap <silent> <leader>f :NvimTreeFindFile<CR>

lua <<EOF
-- nvim tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- empty setup using defaults
require("nvim-tree").setup({
	view = {
		adaptive_size = true,
		mappings = {
			list = {
				{ key = "u", action = "dir_up" },
			},
		},
	},
	renderer = {
		group_empty = true,
	},
})

local actions = require "telescope.actions"
local telescope = require "telescope"

-- telescope
telescope.setup{
	defaults = {
		mappings = {
			i = {
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
				["<C-n>"] = actions.cycle_history_next,
				["<C-p>"] = actions.cycle_history_prev,
			},
		},
	},
    extensions = {
        coc = {
            prefer_locations = true,
        },
        fzf = {
            fuzzy = true,
            override_generic_sorter=true,
            override_file_sorter=true,
            case_mode = "smart_case",
        },
        repo = {
            list = {
                search_dirs = {
                    "~/git",
                },
            },
        },
    },
}

telescope.load_extension('coc')
telescope.load_extension('fzf')
telescope.load_extension('repo')
EOF
