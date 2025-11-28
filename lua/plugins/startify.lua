return {
  -- Startify splash screen
  {
    "mhinz/vim-startify",
    config = function()
      vim.g.startify_custom_header = {
        "   ██╗  ██╗██╗   ██╗ ██████╗ ██╗   ██╗    ██╗   ██╗██╗███╗   ███╗",
        "   ██║  ██║██║   ██║██╔════╝ ██║   ██║    ██║   ██║██║████╗ ████║",
        "   ███████║██║   ██║██║  ███╗██║   ██║    ██║   ██║██║██╔████╔██║",
        "   ██╔══██║██║   ██║██║   ██║██║   ██║    ╚██╗ ██╔╝██║██║╚██╔╝██║",
        "   ██║  ██║╚██████╔╝╚██████╔╝╚██████╔╝     ╚████╔╝ ██║██║ ╚═╝ ██║",
        "   ╚═╝  ╚═╝ ╚═════╝  ╚═════╝  ╚═════╝       ╚═══╝  ╚═╝╚═╝     ╚═╝",
        "",
      }

      -- Startify lists
      vim.g.startify_lists = {
        { type = "files", header = { "   Recent Files" } },
        { type = "dir", header = { "   Current Directory: " .. vim.fn.getcwd() } },
        { type = "sessions", header = { "   Sessions" } },
        { type = "bookmarks", header = { "   Bookmarks" } },
      }

      -- Bookmarks
      vim.g.startify_bookmarks = {
        { c = "~/.config/nvim/init.lua" },
        { p = "~/.config/nvim/lua/plugins/" },
      }

      -- Session options
      vim.g.startify_session_dir = "~/.config/nvim/session"
      vim.g.startify_session_autoload = 1
      vim.g.startify_session_persistence = 1
      vim.g.startify_change_to_vcs_root = 1

      -- File number limit
      vim.g.startify_files_number = 10

      -- Update automatically
      vim.g.startify_update_oldfiles = 1

      -- Custom footer
      vim.g.startify_custom_footer = {
        "",
        "   Neovim loaded in " .. vim.fn.printf("%.3f", vim.fn.reltimefloat(vim.fn.reltime(vim.g.startuptime))) .. "s",
      }

      -- Padding
      vim.g.startify_padding_left = 3
    end,
  },
}
