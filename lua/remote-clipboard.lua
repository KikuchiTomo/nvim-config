-- Remote clipboard bridge for remote-nvim.
--
-- remote-nvim はリモートで headless な nvim サーバを起動し、ローカルの nvim UI が
-- --remote-ui で接続する構成。OSC 52 を remote server の stderr/stdout に吐いても
-- ターミナルに届かないため、クリップボード連携が素で動かない。
--
-- このモジュールは TextYankPost を拾い、接続中の UI チャネル（= ローカルの nvim UI）
-- に対して rpcnotify で「nvim_out_write で OSC 52 を吐いてね」と依頼する。
-- ローカル UI nvim は実際の iTerm2 ターミナルを持っているので、そこから OSC 52 が
-- 送出され、iTerm2 が macOS クリップボードに格納する。
--
-- 通常のローカル TUI nvim では UI チャネルの id が 0（built-in TUI）なので条件に
-- 引っかからず、何もしない。よって local / remote どちらでも安全。

local M = {}

local function emit_osc52_via_uis(text)
  if text == nil or text == '' then return end
  local ok, b64 = pcall(vim.base64.encode, text)
  if not ok then return end
  local osc = string.format('\027]52;c;%s\a', b64)

  for _, chan in ipairs(vim.api.nvim_list_chans()) do
    local client = chan.client
    -- chan.id > 0 で外部 UI（built-in TUI は 0）。client.type == 'ui' で UI 接続のみ対象。
    if chan.id and chan.id > 0 and client and client.type == 'ui' then
      pcall(vim.fn.rpcnotify, chan.id, 'nvim_exec_lua',
        'vim.api.nvim_out_write((...))', { osc })
    end
  end
end

function M.setup()
  vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup('RemoteClipboardBridge', { clear = true }),
    callback = function()
      local ev = vim.v.event
      -- operator 'y' の時だけ（'d' や 'c' は clipboard に送らない挙動にしたければ条件調整）
      if ev.operator ~= 'y' then return end
      local text = table.concat(ev.regcontents or {}, '\n')
      emit_osc52_via_uis(text)
    end,
  })
end

return M
