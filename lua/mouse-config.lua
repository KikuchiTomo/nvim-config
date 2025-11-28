-- Mouse support configuration
vim.opt.mouse = "a"
vim.opt.mousemodel = "extend"

-- Cmd+Click to go to definition (macOS)
-- In most terminals, Cmd+Click is mapped to Ctrl+Click
vim.keymap.set('n', '<C-LeftMouse>', '<LeftMouse><cmd>lua vim.lsp.buf.definition()<CR>', { desc = 'Go to definition with Cmd+Click' })

-- Alternative: use Option (Alt) + Click
vim.keymap.set('n', '<M-LeftMouse>', '<LeftMouse><cmd>lua vim.lsp.buf.definition()<CR>', { desc = 'Go to definition with Option+Click' })

-- Right-click context menu simulation
vim.keymap.set('n', '<RightMouse>', '<LeftMouse><cmd>lua vim.lsp.buf.hover()<CR>', { desc = 'Show hover info on right-click' })

-- Scroll with mouse
vim.keymap.set('n', '<ScrollWheelUp>', '<C-Y>', { desc = 'Scroll up' })
vim.keymap.set('n', '<ScrollWheelDown>', '<C-E>', { desc = 'Scroll down' })
