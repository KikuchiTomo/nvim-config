return {
  "amitds1997/remote-nvim.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
    "stevearc/dressing.nvim",
  },
  config = function()
    require("remote-nvim").setup({
      remote = {
        copy_dirs = {
          -- 明示的にコピー対象を列挙して .git/ を除外。
          -- `.git/objects/*` が read-only (0444) でリモート再試行時に
          -- scp の上書きが Permission denied で失敗する問題を回避。
          config = {
            base = vim.fn.stdpath("config"),
            dirs = { "lua", "init.lua", "lazy-lock.json" },
            compression = { enabled = false },
          },
        },
      },
    })
  end,
}
