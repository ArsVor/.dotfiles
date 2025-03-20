-- Set leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Disable the spacebar key's default behavior in Normal and Visual modes
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- cmd mode
vim.api.nvim_set_keymap('n', '<CR>', ':', { noremap = true, silent = false, desc = 'Command mode' })

-- Close Insert Mode
vim.keymap.set('i', 'jj', '<Esc>', { noremap = true, silent = false, desc = 'Close Insert Mode' })

-- Go to prev Buffer
vim.keymap.set('n', '<leader>,', '<C-^>', { noremap = true, silent = true, desc = '[,] Go to prev file' })

-- Copy % register (current file path) to the + register (system clipboard)
vim.keymap.set('n', '<leader>cp', '<cmd> let @+=@% <CR>', { noremap = true, silent = false, desc = '[C]opy file [P]ath to the + register' })
-- Copy current file name to the + register (system clipboard)
vim.keymap.set('n', '<leader>cn', '<cmd> let @+=expand("%:t") <CR>', { noremap = true, silent = false, desc = '[C]opy file [N]ame to the + register' })

-- -- save file
-- vim.keymap.set('n', '<C-s>', '<cmd> w <CR>', { noremap = true, silent = false, desc = '[S]ave file' })

-- save file without auto-formatting
vim.keymap.set('n', '<leader>wa', '<cmd>noautocmd w <CR>', { noremap = true, silent = false, desc = '[W]rite file without [A]uto-formatting' })

-- Run instance
vim.keymap.set('n', '<leader>wr', ':write<CR>:source<CR>', { noremap = true, silent = false, desc = '[W]rite and [R]un' })

-- -- quit file
-- vim.keymap.set('n', '<C-q>', '<cmd> q <CR>', { noremap = true, silent = false, desc = '[Q]uit file' })
-- vim.keymap.set('n', '<leader>qq', '<cmd> q! <CR>', { noremap = true, silent = false, desc = '[Q]uit file without saving' })

-- delete single character without copying into register
vim.keymap.set('n', 'x', '"_x', { noremap = true, silent = false, desc = '[x] delete single character without copying into register' })

-- in Visual Mode delete without copying into register
vim.keymap.set('v', 'd', '"_d', { noremap = true, silent = true, desc = 'In Visual Mode [D]elete without copying into register' })

-- Past to new line
vim.keymap.set('n', '<Leader>po', 'o<Esc>p', { noremap = true, silent = true, desc = '[P]ast on new line under the cursor' })
vim.keymap.set('n', '<Leader>pO', 'O<Esc>p', { noremap = true, silent = true, desc = '[P]ast on new line above the cursor' })

-- Swap line & fgagment
vim.keymap.set('n', '<M-k>', 'ddkO<Esc>Vp', { noremap = true, silent = true, desc = 'Move line Up' })
vim.keymap.set('n', '<M-j>', 'ddo<Esc>Vp', { noremap = true, silent = true, desc = 'Move line Down' })
vim.keymap.set('v', '<M-k>', 'xkO<Esc>Vp`[V`]', { noremap = true, silent = true, desc = 'Move fragment Up' })
vim.keymap.set('v', '<M-j>', 'xo<Esc>Vp`[V`]', { noremap = true, silent = true, desc = 'Move fragment Down' })

-- Vertical scroll and center
vim.keymap.set('n', '<C-d>', '<C-d>zz', { noremap = true, silent = false, desc = '[D]own scroll and center' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { noremap = true, silent = false, desc = '[U]p scroll and center' })

-- Find and center
vim.keymap.set('n', 'n', 'nzzzv', { noremap = true, silent = false, desc = 'Find [N]ext and center' })
vim.keymap.set('n', 'N', 'Nzzzv', { noremap = true, silent = false, desc = 'Find Previous and center' })

-- Resize with arrows
vim.keymap.set('n', '<M-Up>', ':resize -2<CR>', { noremap = true, silent = false, desc = 'Decrease current window vertical' })
vim.keymap.set('n', '<M-Down>', ':resize +2<CR>', { noremap = true, silent = false, desc = 'Increase current window vertical' })
vim.keymap.set('n', '<M-Left>', ':vertical resize -2<CR>', { noremap = true, silent = false, desc = 'Decrease current window horizontally' })
vim.keymap.set('n', '<M-Right>', ':vertical resize +2<CR>', { noremap = true, silent = false, desc = 'Increase current window horizontally' })

-- Buffers
vim.keymap.set('n', '<Tab>', ':bnext<CR>', { noremap = true, silent = false, desc = 'Go to next Buffer' })
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>', { noremap = true, silent = false, desc = 'Go to prev. Buffer' })
vim.keymap.set('n', '<leader>x', ':bdelete!<CR>', { noremap = true, silent = false, desc = 'Delete current Buffer' }) -- close buffer
vim.keymap.set('n', '<leader>o', '<cmd> enew <CR>', { noremap = true, silent = false, desc = '[O]pen new buffer' }) -- new buffer

-- Split window management
vim.keymap.set('n', '<leader>ss', '<C-w>w', { noremap = true, silent = false, desc = '[S]witch [S]plit window' }) -- split window vertically
vim.keymap.set('n', '<leader>sv', '<C-w>v', { noremap = true, silent = false, desc = '[S]plit window [V]ertically' }) -- split window vertically
vim.keymap.set('n', '<leader>sh', '<C-w>s', { noremap = true, silent = false, desc = '[S]plit window [H]orizontally' }) -- split window horizontally
vim.keymap.set('n', '<leader>se', '<C-w>=', { noremap = true, silent = false, desc = 'Make [S]plit windows [E]qual' }) -- make split windows equal width & height
vim.keymap.set('n', '<leader>sx', ':close<CR>', { noremap = true, silent = false, desc = 'Close current [S]plit window' }) -- close current split window
vim.keymap.set('n', '<leader>sw', ':Minimize<CR>', { noremap = true, silent = false, desc = 'Minimize current [S]plit [W]indow' }) -- minimize current split window

-- Navigate between splits
vim.keymap.set('n', '<C-k>', ':wincmd k<CR>', { noremap = true, silent = false, desc = 'Go to split Up' })
vim.keymap.set('n', '<C-j>', ':wincmd j<CR>', { noremap = true, silent = false, desc = 'Go to split Down' })
vim.keymap.set('n', '<C-h>', ':wincmd h<CR>', { noremap = true, silent = false, desc = 'Go to split Left' })
vim.keymap.set('n', '<C-l>', ':wincmd l<CR>', { noremap = true, silent = false, desc = 'Go to split Right' })

-- Tabs
vim.keymap.set('n', '<leader>to', ':tabnew<CR>', { noremap = true, silent = false, desc = 'New [T]ab [O]pen' }) -- open new tab
vim.keymap.set('n', '<leader>tx', ':tabclose<CR>', { noremap = true, silent = false, desc = 'Current [T]ab close' }) -- close current tab
vim.keymap.set('n', '<leader>tn', ':tabn<CR>', { noremap = true, silent = false, desc = 'Go to [T]ab [N]ext' }) --  go to next tab
vim.keymap.set('n', '<leader>tp', ':tabp<CR>', { noremap = true, silent = false, desc = 'Go to [T]ab [P]rev.' }) --  go to previous tab

-- Toggle line wrapping
vim.keymap.set('n', '<leader>lw', '<cmd>set wrap!<CR>', { noremap = true, silent = false, desc = 'Toggle [L]ine [W]rapping' })

-- Stay in indent mode
vim.keymap.set('v', '<', '<gv', { noremap = true, silent = false, desc = 'Increase indent' })
vim.keymap.set('v', '>', '>gv', { noremap = true, silent = false, desc = 'Decrease indent' })

-- Keep last yanked when pasting
vim.keymap.set('v', 'p', '"_dP', { noremap = true, silent = false, desc = '[P]ast last yanked' })

-- Yank all
vim.keymap.set('n', '<leader>aa', '<cmd> %y <CR>', { noremap = true, silent = false, desc = 'Yank all' })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>df', vim.diagnostic.open_float, { desc = 'Open [F]loating [D]iagnostic message' })
vim.keymap.set('n', '<leader>dl', vim.diagnostic.setloclist, { desc = 'Open [D]iagnostics [L]ist' })

-- Rest server run request under the cusror
vim.keymap.set('n', '<leader>rr', ':Rest run<CR>', { noremap = true, silent = false, desc = '[R]est [R]un under the cusror' })

-- Quick Fix autoimport for Python
vim.api.nvim_set_keymap('n', '<leader>cq', '<cmd>lua require("plugins.custom.autoimport").show_auto_imports()<CR>', { noremap = true, silent = true })
