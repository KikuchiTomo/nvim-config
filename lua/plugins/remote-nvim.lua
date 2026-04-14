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
    require("remote-nvim").setup()
  end,
}
