-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>dq', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', '<leader>dn', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic' })
vim.keymap.set('n', '<leader>dN', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- [[Plugin - Specific Keymaps]] --

vim.keymap.set({ 'n' }, '<localleader>mp', '<esc>i```python<cr>```<esc>O', { desc = 'Add [m]olten [p]ython code cell' })
-- CodeCompanion Chat --
vim.keymap.set('n', '<leader>ac', '<cmd>CodeCompanionChat<CR>', { desc = 'Open CodeCompanion Chat' })

-- CodeCompanion Inline Chat --
vim.keymap.set('n', '<leader>ai', '<cmd>CodeCompanionInlineChat<CR>', { desc = 'Open CodeCompanion Inline Chat' })

-- CodeCompanion Actions --
vim.keymap.set('n', '<leader>aa', '<cmd>CodeCompanionActions<CR>', { desc = 'Run CodeCompanion Actions' })

vim.keymap.set({ 'n', 'v' }, '<localleader>mj', ':MoltenNext<cr>', { desc = 'Go to next [m]olten cell' })

vim.keymap.set({ 'n', 'v' }, '<localleader>mk', ':MoltenPrev<cr>', { desc = 'Go to previous [m]olten cell' })

vim.keymap.set({ 'n' }, '<localleader>mv', ':MoltenPrev<cr>:MoltenNext<cr>v/```<cr>k$', { desc = 'Match [m]olten cell in [v]isual mode' })

vim.keymap.set({ 'n' }, '<C-w>t', '<cmd>tabnew<CR>', { desc = 'Open empty tab' })

vim.keymap.set({ 'n' }, '<leader>t', '<cmd>terminal<CR>', { desc = 'Open terminal' })

-- Autocommand to show diagnostics in a floating window after delay
vim.api.nvim_create_autocmd('CursorHold', {
  callback = function()
    local diagnostics = vim.diagnostic.get(0, { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 })
    if diagnostics and #diagnostics > 0 then
      vim.diagnostic.open_float(nil, { focus = false })
    end
  end,
})
