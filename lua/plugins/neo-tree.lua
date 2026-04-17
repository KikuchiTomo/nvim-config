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
          ["P"] = {
            "toggle_preview",
            config = {
              use_float = false,
              use_image_nvim = false,
            },
          },
          ["gg"] = function(state)
            local node = state.tree:get_node()
            local path = node and node:get_id() or vim.loop.cwd()
            require("lazygit").lazygit(path)
          end,
          ["fg"] = function(state)
            local node = state.tree:get_node()
            local path = node and node:get_id() or vim.loop.cwd()
            if node and node.type == "file" then
              path = vim.fn.fnamemodify(path, ":h")
            end
            require("telescope.builtin").live_grep({
              search_dirs = { path },
              prompt_title = "Live Grep: " .. vim.fn.fnamemodify(path, ":~:."),
            })
          end,
          ["ff"] = function(state)
            local node = state.tree:get_node()
            local path = node and node:get_id() or vim.loop.cwd()
            if node and node.type == "file" then
              path = vim.fn.fnamemodify(path, ":h")
            end
            require("telescope.builtin").find_files({
              search_dirs = { path },
              prompt_title = "Find Files: " .. vim.fn.fnamemodify(path, ":~:."),
            })
          end,
        },
      },
    })

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("NeoTreeAutoPreview", { clear = true }),
      pattern = "neo-tree",
      callback = function()
        local function try_preview(attempts)
          if attempts <= 0 then return end
          vim.defer_fn(function()
            local ok = pcall(vim.api.nvim_feedkeys, "P", "m", false)
            if not ok then
              try_preview(attempts - 1)
            end
          end, 200)
        end
        try_preview(3)
      end,
    })

    -- プレビューバッファでは LSP・gitsigns・conform を無効化して高速化
    vim.api.nvim_create_autocmd("BufEnter", {
      group = vim.api.nvim_create_augroup("NeoTreePreviewOptimize", { clear = true }),
      callback = function(ev)
        local buf = ev.buf
        if not vim.b[buf].neo_tree_preview then return end
        -- LSP をアタッチさせない
        vim.b[buf].lsp_disabled = true
        vim.defer_fn(function()
          for _, client in ipairs(vim.lsp.get_clients({ bufnr = buf })) do
            vim.lsp.buf_detach_client(buf, client.id)
          end
        end, 10)
        -- gitsigns をスキップ
        vim.b[buf].gitsigns_head = nil
        pcall(function() require("gitsigns").detach(buf) end)
      end,
    })

    -- Keybinding to toggle file explorer
    vim.keymap.set('n', '<leader>e', ':Neotree toggle<CR>', { desc = 'Toggle file explorer' })

    -- Emacs 風 <C-x><C-d> は init.lua の vim.g.use_emacs_bindings フラグで制御。
    if vim.g.use_emacs_bindings then
      vim.keymap.set('n', '<C-x><C-d>', ':Neotree toggle<CR>', { desc = 'Toggle file explorer (Emacs dired風)' })

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
    end

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
