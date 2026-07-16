-- Set leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Disable the spacebar key's default behavior in Normal and Visual modes
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
-- More ergonomic command key
vim.keymap.set('n', ';', ':', { noremap = true })
-- For conciseness
local opts = { noremap = true, silent = true }

-- save file
-- vim.keymap.set('n', '<C-s>', '<cmd> w <CR>', opts)

-- save file without auto-formatting
vim.keymap.set('n', '<leader>sq', '<cmd>noautocmd w <CR>', opts)

-- Open explorer
vim.keymap.set('n', '<leader>e', ':Ex<Cr>', opts)

-- quit file
-- vim.keymap.set('n', '<C-q>', '<cmd> q <CR>', opts)

-- delete single character without copying into register
-- vim.keymap.set('n', 'x', '"_x', opts)

-- Vertical scroll and center
vim.keymap.set('n', '<C-d>', '<C-d>zz', opts)
vim.keymap.set('n', '<C-u>', '<C-u>zz', opts)

-- Find and center
-- vim.keymap.set('n', 'n', 'nzzzv', opts)
-- vim.keymap.set('n', 'N', 'Nzzzv', opts)

-- Resize with arrows
vim.keymap.set('n', '<Up>', ':resize -2<CR>', opts)
vim.keymap.set('n', '<Down>', ':resize +2<CR>', opts)
vim.keymap.set('n', '<Left>', ':vertical resize -2<CR>', opts)
vim.keymap.set('n', '<Right>', ':vertical resize +2<CR>', opts)

-- Buffers
vim.keymap.set('n', '<Tab>', ':bnext<CR>', opts)
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>', opts)
vim.keymap.set('n', '<leader>x', ':bdelete!<CR>', opts) -- close buffer
vim.keymap.set('n', '<leader>b', '<cmd> enew <CR>', opts) -- new buffer

-- Window management
vim.keymap.set('n', '<leader>pv', '<C-w>v', opts) -- split window vertically
vim.keymap.set('n', '<leader>ph', '<C-w>s', opts) -- split window horizontally
vim.keymap.set('n', '<leader>pse', '<C-w>=', opts) -- make split windows equal width & height
vim.keymap.set('n', '<leader>wxs', ':close<CR>', opts) -- close current split window

-- Navigate between splits
-- vim.keymap.set('n', '<C-k>', ':wincmd k<CR>', opts)
-- vim.keymap.set('n', '<C-j>', ':wincmd j<CR>', opts)
-- vim.keymap.set('n', '<C-h>', ':wincmd h<CR>', opts)
-- vim.keymap.set('n', '<C-l>', ':wincmd l<CR>', opts)

-- Tabs
vim.keymap.set('n', '<leader>to', ':tabnew<CR>', opts) -- open new tab
vim.keymap.set('n', '<leader>tx', ':tabclose<CR>', opts) -- close current tab
vim.keymap.set('n', '<leader>tn', ':tabn<CR>', opts) --  go to next tab
vim.keymap.set('n', '<leader>tp', ':tabp<CR>', opts) --  go to previous tab

-- TODO: Toggle line wrapping
vim.keymap.set('n', '<leader>lw', '<cmd>set wrap!<CR>', opts)

-- Stay in indent mode
vim.keymap.set('v', '<', '<gv', opts)
vim.keymap.set('v', '>', '>gv', opts)

-- Keep last yanked when pasting
vim.keymap.set('v', 'p', '"_dP', opts)

-- Diagnostic keymaps
vim.keymap.set('n', '[d', function()
  vim.diagnostic.jump { count = -1, float = true }
end, { desc = 'Go to previous diagnostic message' })

vim.keymap.set('n', ']d', function()
  vim.diagnostic.jump { count = 1, float = true }
end, { desc = 'Go to next diagnostic message' })

-- Shortcut for searching your Neovim configuration files
vim.keymap.set('n', '<leader>sn', function()
  require('telescope.builtin').find_files { cwd = vim.fn.stdpath 'config' }
end, { desc = '[S]earch [N]eovim files' })

vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
-- TODO: add quickfix options

-- Leave insert before handling a mouse press: nvim-cmp queues `<Cmd>...<CR>`
-- keys into typeahead, and a mode flip mid-flush types them into the buffer
-- as literal `require"cmp.utils.feedkeys".run(N)` text. <Esc> fires InsertLeave
-- so cmp drains first; the drag then starts Visual natively from normal mode.
vim.keymap.set('i', '<LeftMouse>', '<Esc><LeftMouse>', { silent = true, desc = 'Mouse press exits insert first' })
