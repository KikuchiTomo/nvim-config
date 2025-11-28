-- Emacs-style keybindings for insert and command mode
local map = vim.keymap.set

-- Insert mode keybindings
map('i', '<C-a>', '<Home>', { desc = 'Move to beginning of line' })
map('i', '<C-e>', '<End>', { desc = 'Move to end of line' })
map('i', '<C-f>', '<Right>', { desc = 'Move forward one character' })
map('i', '<C-b>', '<Left>', { desc = 'Move backward one character' })
map('i', '<C-n>', '<Down>', { desc = 'Move to next line' })
map('i', '<C-p>', '<Up>', { desc = 'Move to previous line' })
map('i', '<C-d>', '<Delete>', { desc = 'Delete character' })
map('i', '<C-h>', '<BS>', { desc = 'Backspace' })
map('i', '<C-k>', '<C-o>D', { desc = 'Kill to end of line' })
map('i', '<M-f>', '<C-o>w', { desc = 'Move forward one word' })
map('i', '<M-b>', '<C-o>b', { desc = 'Move backward one word' })

-- Normal mode keybindings
map('n', '<C-a>', '^', { desc = 'Move to beginning of line' })
map('n', '<C-e>', '$', { desc = 'Move to end of line' })
map('n', '<C-f>', 'l', { desc = 'Move forward one character' })
map('n', '<C-b>', 'h', { desc = 'Move backward one character' })
map('n', '<C-n>', 'j', { desc = 'Move to next line' })
map('n', '<C-p>', 'k', { desc = 'Move to previous line' })
map('n', '<C-d>', 'x', { desc = 'Delete character' })
map('n', '<C-h>', 'X', { desc = 'Backspace (delete previous character)' })
map('n', '<C-k>', 'D', { desc = 'Kill to end of line' })
map('n', '<M-f>', 'w', { desc = 'Move forward one word' })
map('n', '<M-b>', 'b', { desc = 'Move backward one word' })

-- Search
map('n', '<C-s>', '/', { desc = 'Search forward' })

-- Command mode keybindings
map('c', '<C-a>', '<Home>', { desc = 'Move to beginning of command line' })
map('c', '<C-e>', '<End>', { desc = 'Move to end of command line' })
map('c', '<C-f>', '<Right>', { desc = 'Move forward one character' })
map('c', '<C-b>', '<Left>', { desc = 'Move backward one character' })
map('c', '<C-d>', '<Delete>', { desc = 'Delete character' })
map('c', '<C-k>', '<C-\\>estrpart(getcmdline(), 0, getcmdpos()-1)<CR>', { desc = 'Kill to end of line' })

-- Visual mode keybindings
map('v', '<C-a>', '^', { desc = 'Move to beginning of line' })
map('v', '<C-e>', '$', { desc = 'Move to end of line' })
map('v', '<C-f>', 'l', { desc = 'Move forward one character' })
map('v', '<C-b>', 'h', { desc = 'Move backward one character' })
map('v', '<C-n>', 'j', { desc = 'Move to next line' })
map('v', '<C-p>', 'k', { desc = 'Move to previous line' })

-- Buffer navigation (Emacs-style)
-- Smart save: if no filename, prompt for one
map('n', '<C-x><C-s>', function()
  if vim.fn.expand('%') == '' then
    vim.ui.input({ prompt = 'Save as: ' }, function(filename)
      if filename and filename ~= '' then
        vim.cmd('write ' .. filename)
      end
    end)
  else
    vim.cmd('write')
  end
end, { desc = 'Save file' })

map('n', '<C-x><C-c>', ':qa<CR>', { desc = 'Quit all' })
map('n', '<C-x>b', ':Telescope buffers<CR>', { desc = 'Switch buffer' })
map('n', '<C-x>k', ':bd<CR>', { desc = 'Kill buffer' })
