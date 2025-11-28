-- Basic settings
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.mouse = "a"

-- Japanese language settings
vim.opt.helplang = "ja,en"  -- Prefer Japanese help, fallback to English
vim.opt.encoding = "utf-8"

-- Clipboard settings for iTerm2
-- Use OSC 52 for clipboard integration
vim.g.clipboard = {
  name = 'OSC 52',
  copy = {
    ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
    ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
  },
  paste = {
    ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
    ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
  },
}
vim.opt.clipboard = "unnamedplus"

-- Suppress lspconfig deprecation warnings globally
vim.deprecate = function() end

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load plugins
require("lazy").setup("plugins")

-- Emacs-style keybindings
require("emacs-bindings")

-- LSP and diagnostics configuration
require("lsp-config")

-- Mouse configuration for Cmd+Click navigation
require("mouse-config")

-- Command aliases for easier access
vim.cmd([[
  command! F Telescope find_files
  command! Rg Telescope live_grep
  command! B Telescope buffers
  command! H Telescope help_tags
  command! R Telescope oldfiles
  command! C Telescope commands
  command! K Telescope keymaps
]])

-- Even shorter aliases
vim.api.nvim_create_user_command('Ff', 'Telescope find_files', {})
vim.api.nvim_create_user_command('Fg', 'Telescope live_grep', {})
vim.api.nvim_create_user_command('Fb', 'Telescope buffers', {})

-- LSP debugging commands
vim.api.nvim_create_user_command('LspStatus', function()
  local clients = vim.lsp.get_clients({bufnr = 0})
  if #clients == 0 then
    print("No LSP clients attached to this buffer")
  else
    print("LSP clients attached:")
    for _, client in ipairs(clients) do
      print("  - " .. client.name)
    end
  end
end, {})

vim.api.nvim_create_user_command('LspRestart', 'LspStop | sleep 100m | LspStart', {})
