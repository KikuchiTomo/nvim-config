return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").setup({})

    -- main ブランチはハイライト等のクエリを <plugin>/runtime/queries に置くが、
    -- この runtime/ が runtimepath に入らないため highlights.scm が見つからず、
    -- yaml/json/dockerfile/make 等でシンタックスハイライトが一切効かない。
    -- （cpp 等が色付いて見えるのは treesitter ではなく LSP セマンティックトークンの効果）
    -- runtime/ を明示的に rtp へ追加してクエリを解決可能にする。
    local ts = require("lazy.core.config").plugins["nvim-treesitter"]
    if ts then
      vim.opt.runtimepath:prepend(ts.dir .. "/runtime")
    end

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("TreesitterStart", { clear = true }),
      callback = function(args)
        -- start() は明示的に対象バッファを渡す（カレントバッファとズレる経路対策）
        if not pcall(vim.treesitter.start, args.buf) then return end
        pcall(function()
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end)
      end,
    })
  end,
}
