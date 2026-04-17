-- Leader keys (プラグイン読み込み前に設定する必要がある。
-- プラグインが <leader> を使った map を定義する時点の値が固定されるため)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

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

-- Clipboard: ローカルは pbcopy/pbpaste 自動検出、SSH 越しのみ OSC 52 にフォールバック。
-- OSC 52 の paste は iTerm2 が応答を返さず固まるため、内部レジスタから読む。
if vim.env.SSH_TTY then
  vim.g.clipboard = {
    name = 'OSC 52',
    copy = {
      ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
      ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
    },
    paste = {
      ['+'] = function()
        return vim.split(vim.fn.getreg('"'), '\n'), vim.fn.getregtype('"')
      end,
      ['*'] = function()
        return vim.split(vim.fn.getreg('"'), '\n'), vim.fn.getregtype('"')
      end,
    },
  }
end
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

-- Emacs 風キーバインドを使うかのフラグ。
-- true にして再起動すると emacs-bindings.lua と各プラグインの <C-x> 系 map が復活する。
vim.g.use_emacs_bindings = false

-- Load plugins
require("lazy").setup("plugins")

-- Emacs-style keybindings
if vim.g.use_emacs_bindings then
  require("emacs-bindings")
end

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

-- Tab navigation
vim.keymap.set('n', '<leader>tn', ':tabnew<CR>',      { desc = 'New tab' })
vim.keymap.set('n', '<leader>tc', ':tabclose<CR>',    { desc = 'Close tab' })
vim.keymap.set('n', '<leader>to', ':tabonly<CR>',     { desc = 'Close other tabs' })
vim.keymap.set('n', '[t',         ':tabprevious<CR>', { desc = 'Prev tab' })
vim.keymap.set('n', ']t',         ':tabnext<CR>',     { desc = 'Next tab' })
