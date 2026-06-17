vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'


-- ** REMAP ** --
--
-- Disable <Space>
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Keep last yanked when pasting
vim.keymap.set('v', 'p', '"_dP', { noremap = true, silent = false })

-- delete single character without copying into register
vim.keymap.set('n', 'x', '"_x', { noremap = true, silent = false })

-- in Visual Mode delete without copying into register
vim.keymap.set('v', 'x', '"_d', { noremap = true, silent = true })

-- Stay in visual mode then change indent
vim.keymap.set('v', '<', '<gv', { noremap = true, silent = false, desc = 'Increase indent' })
vim.keymap.set('v', '>', '>gv', { noremap = true, silent = false, desc = 'Decrease indent' })

-- Down & Up in wrap-aware insted
vim.keymap.set("n", "j", function()
  return vim.v.count == 0 and "gj" or "j"
end, { expr = true, silent = true, desc = "Down (wrap-aware)" })
vim.keymap.set("n", "k", function()
  return vim.v.count == 0 and "gk" or "k"
end, { expr = true, silent = true, desc = "Up (wrap-aware)" })

-- Move to first/last entry
vim.keymap.set('n', 'gf', function()
  local char = vim.fn.getcharstr()
  vim.cmd('normal! $F' .. char)
end, { noremap = true, silent = false, desc = 'Go to last entry' })
vim.keymap.set('n', 'gt', function()
  local char = vim.fn.getcharstr()
  vim.cmd('normal! $T' .. char)
end, { noremap = true, silent = false, desc = 'Go to next of last entry' })
vim.keymap.set('n', 'gF', function()
  local char = vim.fn.getcharstr()
  vim.cmd('normal! ^f' .. char)
end, { noremap = true, silent = false, desc = 'Go to first entry' })
vim.keymap.set('n', 'gT', function()
  local char = vim.fn.getcharstr()
  vim.cmd('normal! ^t' .. char)
end, { noremap = true, silent = false, desc = 'Go to prev of first entry' })


-- ** MAIN KEYBINDINGS FOR UK LAYOUT ** --
--
vim.keymap.set('n', 'щ', 'o', { silent = true })
vim.keymap.set('n', 'к', 'r', { silent = true })
vim.keymap.set('n', 'ш', 'i', { silent = true })
vim.keymap.set('n', 'ф', 'a', { silent = true })
vim.keymap.set('n', 'Ш', 'I', { silent = true })
vim.keymap.set('n', 'Ф', 'A', { silent = true })
vim.keymap.set('n', 'Щ', 'O', { silent = true })
vim.keymap.set('i', 'оо', '<Esc>', { silent = false })


-- ** GLOBAL NAVIGATE ** --
--
vim.keymap.set('n', '<leader>,', '<C-^>', { noremap = true, silent = true, desc = '[,] Go to prev buffer' })
vim.keymap.set('n', '<leader>x', ':bdelete!<CR>', { noremap = true, silent = false, desc = 'Delete current Buffer' }) -- close buffer
vim.keymap.set('n', "<leader>'", ':marks<CR>', { noremap = true, silent = true, desc = 'Marks' })

-- Grpple (Harpoon)
vim.keymap.set('n', '<leader>hh', ':Grapple toggle<CR>', { noremap = true, silent = true, desc = 'Add to tag list' })
vim.keymap.set('n', '<leader>hm', ':Grapple toggle_tags<CR>',
  { noremap = true, silent = true, desc = 'Toggle tags menu' })
vim.keymap.set('n', '<leader>hc', ':Grapple reset<CR>', { noremap = true, silent = true, desc = 'Clear tags' })
vim.keymap.set('n', '<leader>/', ':Grapple cycle_tags next<CR>',
  { noremap = true, silent = true, desc = 'Go to next tag' })
vim.keymap.set('n', '<leader>.', ':Grapple cycle_tags prev<CR>',
  { noremap = true, silent = true, desc = 'Go to previous tag' })
vim.keymap.set('n', '<leader>h1', ':Grapple select index=1<CR>', { noremap = true, silent = true, desc = 'Select tag 1' })
vim.keymap.set('n', '<leader>h2', ':Grapple select index=2<CR>', { noremap = true, silent = true, desc = 'Select tag 2' })
vim.keymap.set('n', '<leader>h3', ':Grapple select index=3<CR>', { noremap = true, silent = true, desc = 'Select tag 3' })
vim.keymap.set('n', '<leader>h4', ':Grapple select index=4<CR>', { noremap = true, silent = true, desc = 'Select tag 4' })
vim.keymap.set('n', '<leader>h5', ':Grapple select index=5<CR>', { noremap = true, silent = true, desc = 'Select tag 5' })


-- ** NAVIGATE IN BUFFER ** --
--
-- Vertical scroll and center
vim.keymap.set('n', '<C-d>', '<C-d>zz', { noremap = true, silent = false, desc = '[D]own scroll and center' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { noremap = true, silent = false, desc = '[U]p scroll and center' })

-- Find and center
vim.keymap.set('n', 'n', 'nzzzv', { noremap = true, silent = false, desc = 'Find [N]ext and center' })
vim.keymap.set('n', 'N', 'Nzzzv', { noremap = true, silent = false, desc = 'Find Previous and center' })

-- Go to Region
vim.keymap.set('n', ']r', function()
    require("plugins.custom.functions").go_to_region(1)
  end,
  { noremap = true, silent = true, desc = 'Next [R]egion' }
)

vim.keymap.set('n', '[r', function()
    require("plugins.custom.functions").go_to_region(-1)
  end,
  { noremap = true, silent = true, desc = 'Prev [R]egion' }
)


-- ** NAVIGATE IN INSER MODE ** --
--
vim.keymap.set('i', '<C-h>', '<Left>', { silent = true })
vim.keymap.set('i', '<C-j>', '<Down>', { silent = true })
vim.keymap.set('i', '<C-k>', '<Up>', { silent = true })
vim.keymap.set('i', '<C-l>', '<Right>', { silent = true })
vim.keymap.set('i', 'jj', '<Esc>', { silent = false })
vim.keymap.set('i', 'jk', '<Esc>:write<CR>', { silent = false })


-- ** MINI PICKER ** --
--
vim.keymap.set('n', '<leader>ff', ':Pick files<CR>', { noremap = true, silent = true, desc = 'Pick [F]iles' })
vim.keymap.set('n', '<leader>fh', ':Pick help<CR>', { noremap = true, silent = true, desc = 'Pick [H]elp' })
vim.keymap.set('n', '<leader>fg', ':Pick grep_live<CR>', { noremap = true, silent = true, desc = 'Pick [G]rep' })
vim.keymap.set('n', '<leader>fr', ':Pick resume<CR>', { noremap = true, silent = true, desc = 'Pick [G]rep' })
vim.keymap.set('n', '<leader>fw', function()
  local word = vim.fn.expand('<cWORD>')
  require('mini.pick').builtin.grep({ pattern = word })
end)
vim.keymap.set('v', '<leader>fg', function()
  local text = require('plugins.custom.functions').get_visual_selection()
  require('mini.pick').builtin.grep({ pattern = text })
end)
vim.keymap.set('n', '<leader><leader>', ':Pick buffers<CR>', { noremap = true, silent = true, desc = 'Pick buffers' })


-- ** CODE ACTIONS ** --
--
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { noremap = true, silent = true, desc = '[C]ode [A]ctions' })
vim.keymap.set('n', '<leader>cd', ':Trouble diagnostics toggle<CR>',
  { noremap = true, silent = true, desc = '[C]ode [D]iagnostics' })
vim.keymap.set('n', '<leader>cf', vim.lsp.buf.format, { noremap = true, silent = true, desc = '[C]ode [F]ormat' })

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>df', vim.diagnostic.open_float,
  { noremap = true, silent = false, desc = '[F]loating [D]iagnostic' })

vim.keymap.set('n', '<leader>di', ':TinyInlineDiag toggle<CR>',
  { noremap = true, silent = false, desc = '[D]iagnostic [I]nline toggle' })

-- Quick Fix autoimport for Python
vim.keymap.set('n', '<leader>cq', function()
    require("plugins.custom.functions").show_auto_imports()
  end,
  { noremap = true, silent = true, desc = '[Q]uickFix autoimport' }
)

-- QuickFix buffer
vim.keymap.set('n', '<leader>qo', ':copen<CR>', { noremap = true, silent = true, desc = '[Q]uickFix buffer [O]pen' })
vim.keymap.set('n', '<leader>qn', ':cnext<CR>', { noremap = true, silent = true, desc = '[Q]uickFix go [N]ext' })
vim.keymap.set('n', '<leader>qp', ':cprev<CR>', { noremap = true, silent = true, desc = '[Q]uickFix go [P]rev' })
vim.keymap.set('n', '<leader>qx', ':cclose<CR>', { noremap = true, silent = true, desc = '[Q]uickFix buffer close' })

-- Add Pyright ignore diagnostics
vim.keymap.set('n', '<leader>cx', '<cmd> PyrightIgnore <CR>',
  { noremap = true, silent = true, desc = 'Add Pyright ignore diagnostics' })


-- ** YANK & PASTE ** --
--
-- Open registers
vim.keymap.set('n', '<leader>"', ':registers<CR>', { noremap = true, silent = true, desc = 'Registers' })

-- Copy % register (current file path) to the + register (system clipboard)
vim.keymap.set('n', '<leader>yp', '<cmd> let @+=@% <CR>',
  { noremap = true, silent = false, desc = '[Y]ank file [P]ath' })

-- Copy current file name to the + register (system clipboard)
vim.keymap.set('n', '<leader>yn', '<cmd> let @+=expand("%:t") <CR>',
  { noremap = true, silent = false, desc = '[Y]ank file [N]ame' })

-- Yank all
vim.keymap.set('n', '<leader>yy', '<cmd> %y <CR>', { noremap = true, silent = false, desc = '[Y]ank all' })

-- Past to new line
vim.keymap.set('n', '<Leader>po', 'o<Esc>p', { noremap = true, silent = true, desc = '[P]ast on new line under' })
vim.keymap.set('n', '<Leader>pO', 'O<Esc>p', { noremap = true, silent = true, desc = '[P]ast on new line above' })

-- Swap line & fragment
vim.keymap.set("n", "<M-j>", ":m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<M-k>", ":m .-2<CR>==", { desc = "Move line up" })
vim.keymap.set("v", "<M-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<M-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Substitute
vim.keymap.set('n', 's', function()
  require('substitute').operator()
end, { noremap = true, desc = 'Substitute with motion' })

vim.keymap.set('n', 'ss', function()
  require('substitute').line()
end, { noremap = true, desc = 'Substitute line' })

vim.keymap.set('n', 'S', function()
  require('substitute').eol()
end, { noremap = true, desc = 'Substitute to end of line' })

vim.keymap.set('x', 's', function()
  require('substitute').visual()
end, { noremap = true, desc = 'Substitute in visual mode' })

-- Grug-Far refactor
vim.keymap.set('n', '<leader>cr', ':GrugFar<CR>', { noremap = true, desc = 'Search & [R]eplace' })
vim.keymap.set('v', '<leader>cr', ':GrugFarWithin<CR>', { noremap = true, desc = 'Search & [R]eplace' })


-- ** SPLIT WINDOW MANAGEMENT ** --
--
vim.keymap.set('n', '<leader>ss', '<C-w>w', { noremap = true, silent = false, desc = '[S]witch [S]plit window' })          -- split window vertically
vim.keymap.set('n', '<leader>sv', '<C-w>v', { noremap = true, silent = false, desc = '[S]plit window [V]ertically' })      -- split window vertically
vim.keymap.set('n', '<leader>sh', '<C-w>s', { noremap = true, silent = false, desc = '[S]plit window [H]orizontally' })    -- split window horizontally
vim.keymap.set('n', '<leader>se', '<C-w>=', { noremap = true, silent = false, desc = 'Make [S]plit windows [E]qual' })     -- make split windows equal width & height
vim.keymap.set('n', '<leader>sx', ':close<CR>', { noremap = true, silent = false, desc = 'Close current [S]plit window' }) -- close current split window
vim.keymap.set('n', '<leader>sw', ':Minimize<CR>',
  { noremap = true, silent = false, desc = 'Minimize current [S]plit [W]indow' })                                          -- minimize current split window
vim.keymap.set('n', '<leader>sz', ':Maximize<CR>', { noremap = true, silent = true, desc = '[S]plit maximi[Z]e toggle' })
vim.keymap.set('n', '<leader>sr', function() require('maximize').restore() end,
  { noremap = true, silent = true, desc = '[S]plit [R]estore' })

-- Navigate between splits
vim.keymap.set('n', '<C-k>', ':wincmd k<CR>', { noremap = true, silent = false, desc = 'Go to split Up' })
vim.keymap.set('n', '<C-j>', ':wincmd j<CR>', { noremap = true, silent = false, desc = 'Go to split Down' })
vim.keymap.set('n', '<C-h>', ':wincmd h<CR>', { noremap = true, silent = false, desc = 'Go to split Left' })
vim.keymap.set('n', '<C-l>', ':wincmd l<CR>', { noremap = true, silent = false, desc = 'Go to split Right' })

-- Resize with arrows
vim.keymap.set('n', '<M-Up>', ':resize -2<CR>',
  { noremap = true, silent = false, desc = 'Decrease current window vertical' })
vim.keymap.set('n', '<M-Down>', ':resize +2<CR>',
  { noremap = true, silent = false, desc = 'Increase current window vertical' })
vim.keymap.set('n', '<M-Left>', ':vertical resize -2<CR>',
  { noremap = true, silent = false, desc = 'Decrease current window horizontally' })
vim.keymap.set('n', '<M-Right>', ':vertical resize +2<CR>',
  { noremap = true, silent = false, desc = 'Increase current window horizontally' })


-- ** LINE FORMAT & VIEW ** --
--
-- Toggle line wrapping
vim.keymap.set('n', '<leader>L', '<cmd>set wrap!<CR>',
  { noremap = true, silent = false, desc = 'Toggle [L]ine wrapping' })


-- ** WRITE OPTIONS ** --
--
-- save file without auto-formatting
vim.keymap.set('n', '<leader>wa', '<cmd>noautocmd w <CR>',
  { noremap = true, silent = false, desc = '[W]rite file without [A]uto-formatting' })

-- Run instance
vim.keymap.set('n', '<leader>wr', ':write<CR>:source<CR>', { noremap = true, silent = false, desc = '[W]rite and [R]un' })

-- Sass autocompiler
vim.keymap.set('n', '<leader>wss', ':SassStatus<CR>', {
  noremap = true,
  silent = true,
  desc =
  '[S]ass autocompiler [S]tatus'
})
vim.keymap.set('n', '<leader>wst', ':SassToggle<CR>', {
  noremap = true,
  silent = true,
  desc =
  '[S]ass autocompiler [T]oggle'
})

-- ** OIL ** --
--
vim.keymap.set('n', '-', ':Oil<CR>')


-- ** UNDOTREE ** --
--
vim.keymap.set('n', '<leader>U', ':Undotree<CR>', { noremap = true, silent = true, desc = 'Open Undotree' })


-- ** GITSIGNS ** --
--
vim.keymap.set('n', '<leader>gp', ':Gitsigns preview_hunk<CR>', { desc = 'Open [G]it diff line [P]review' })
vim.keymap.set('n', '<leader>gd', function()
  require('gitsigns').diffthis(nil, { split = 'rightbelow', vertical = true })
end, { desc = 'Open [G]it [D]iff in split window' })
vim.keymap.set('n', '<leader>gs', ':Gitsigns show<CR>', { desc = '[G]it [S]how revision {base} of the current file' })
vim.keymap.set('n', '<leader>gb', ':Gitsigns blame<CR>', { desc = 'Open [G]it [B]lame' })
vim.keymap.set('n', '<leader>gi', ':Gitsigns toggle_current_line_blame<CR>',
  { desc = 'Toggle [G]it current line blame [I]nfo' })


-- ** EMMET ** --
vim.keymap.set({ 'n', 'v' }, '<leader>e', function() require('nvim-emmet').wrap_with_abbreviation() end,
  { desc = '[E]mmet abbreviation' })


-- ** DAP ** --
--
vim.keymap.set('n', '<leader>b', function()
    require('dap').toggle_breakpoint()
  end,
  { noremap = true, silent = true, desc = 'Debag toggle [B]reakpointk' })
vim.keymap.set('n', '<leader>dB', function()
    require('dap').clear_breakpoints()
  end,
  { noremap = true, silent = true, desc = 'Debag toggle [B]reakpointk' })
vim.keymap.set('n', '<leader>dc', function()
    require('dap').continue()
  end,
  { noremap = true, silent = true, desc = '[D]ebag [C]ontinue' })
vim.keymap.set('n', '<leader>dq', function()
    require('dap').terminate()
  end,
  { noremap = true, silent = true, desc = '[D]ebag [Q]uit' })
vim.keymap.set('n', '<leader>dr', function()
    require('dap').repl.toggle()
  end,
  { noremap = true, silent = true, desc = '[D]ebag open [R]EPL' })
vim.keymap.set('n', '<leader>dl', function()
    require('dap').restart()
  end,
  { noremap = true, silent = true, desc = '[D]ebag run [L]ast' })
vim.keymap.set('n', '<leader>du', function()
    require('dapui').toggle()
  end,
  { noremap = true, silent = true, desc = '[D]ebag [U]i toggle' })
vim.keymap.set({ 'n', 'v' }, '<leader>dw', function()
    require('dapui').eval(nil, { enter = true })
  end,
  { noremap = true, silent = true, desc = 'Add [W]ord to waches' })
vim.keymap.set({ 'n', 'v' }, '<leader>Q', function()
    require('dapui').eval()
  end,
  { noremap = true, silent = true, desc = 'Hover eval' })


-- ** ??? ** __

vim.keymap.set('n', 'gcr', function()
    require("plugins.custom.functions").comment_reg_block()
  end,
  { noremap = true, silent = true, desc = 'Toggle region comment' }
)
