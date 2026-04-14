return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("neo-tree").setup({
      close_if_last_window = true,
      popup_border_style = "rounded",
      enable_git_status = true,
      enable_diagnostics = true,
      default_component_configs = {
        git_status = {
          symbols = {
            -- Change type
            added     = "A",  -- 新規追加 (staged)
            modified  = "M",  -- 変更
            deleted   = "D",  -- 削除
            renamed   = "R",  -- リネーム
            -- Status
            untracked = "?",  -- git 管理外 (new)
            ignored   = "!",
            unstaged  = "U",
            staged    = "S",
            conflict  = "C",
          },
        },
      },
      filesystem = {
        follow_current_file = {
          enabled = true,
        },
        use_libuv_file_watcher = true,
      },
      window = {
        position = "left",
        width = 30,
        mappings = {
          ["<space>"] = "toggle_node",
          ["<cr>"] = "open",
          ["<2-LeftMouse>"] = "open",
          ["<LeftRelease>"] = "open",
          ["S"] = "open_split",
          ["s"] = "open_vsplit",
          ["t"] = "open_tabnew",
          ["C"] = "close_node",
          ["z"] = "close_all_nodes",
          ["R"] = "refresh",
          ["a"] = "add",
          ["d"] = "delete",
          ["r"] = "rename",
          ["y"] = "copy_to_clipboard",
          ["x"] = "cut_to_clipboard",
          ["p"] = "paste_from_clipboard",
          ["q"] = "close_window",
        },
      },
    })

    -- Keybinding to toggle file explorer
    vim.keymap.set('n', '<C-x><C-d>', ':Neotree toggle<CR>', { desc = 'Toggle file explorer (Emacs dired風)' })
    vim.keymap.set('n', '<leader>e', ':Neotree toggle<CR>', { desc = 'Toggle file explorer' })

    -- neo-tree バッファ内で <C-x> 単独が走ると nomodifiable で E21 が出るため、
    -- 該当バッファに限定して <C-x> を無効化し、<C-x><C-d> は明示的に buffer-local 登録する。
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("NeoTreeCxFix", { clear = true }),
      pattern = "neo-tree",
      callback = function(ev)
        vim.keymap.set('n', '<C-x>', '<Nop>', { buffer = ev.buf, silent = true })
        vim.keymap.set('n', '<C-x><C-d>', ':Neotree toggle<CR>', { buffer = ev.buf, silent = true, desc = 'Toggle file explorer' })
      end,
    })

    -- Git status symbol colors (re-apply on ColorScheme change so themes don't wipe them)
    local function apply_git_hl()
      vim.api.nvim_set_hl(0, "NeoTreeGitAdded",     { fg = "#a6e3a1", bold = true })  -- A: 緑
      vim.api.nvim_set_hl(0, "NeoTreeGitModified",  { fg = "#f9e2af", bold = true })  -- M: 黄
      vim.api.nvim_set_hl(0, "NeoTreeGitDeleted",   { fg = "#f38ba8", bold = true })  -- D: 赤
      vim.api.nvim_set_hl(0, "NeoTreeGitRenamed",   { fg = "#cba6f7" })               -- R: 紫
      vim.api.nvim_set_hl(0, "NeoTreeGitUntracked", { fg = "#89b4fa", bold = true })  -- ?: 青
      vim.api.nvim_set_hl(0, "NeoTreeGitIgnored",   { fg = "#6c7086" })               -- !: 灰
      vim.api.nvim_set_hl(0, "NeoTreeGitStaged",    { fg = "#94e2d5" })               -- S: シアン
      vim.api.nvim_set_hl(0, "NeoTreeGitUnstaged",  { fg = "#fab387" })               -- U: 橙
      vim.api.nvim_set_hl(0, "NeoTreeGitConflict",  { fg = "#f38ba8", bold = true, underline = true }) -- C
    end
    apply_git_hl()
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("NeoTreeGitColors", { clear = true }),
      callback = apply_git_hl,
    })
  end,
}
