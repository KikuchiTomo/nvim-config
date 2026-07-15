return {
  -- Mason (LSP installer) - must be loaded first
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUpdate", "MasonLog" },
    config = function()
      require("mason").setup()
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    lazy = true,
    dependencies = { "williamboman/mason.nvim" },
  },

  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Common on_attach function for all LSP servers
      local on_attach = function(client, bufnr)
        local opts = { buffer = bufnr }

        -- Go to definition (Cmd+Click equivalent)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', '<C-]>', vim.lsp.buf.definition, opts)

        -- Find references (callers)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)

        -- Other useful LSP keybindings
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', '<leader>f', function()
          vim.lsp.buf.format({ async = true })
        end, opts)
      end

      -- Setup mason-lspconfig
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "ts_ls",
          "pyright",
          "rust_analyzer",
          "clangd",  -- C/C++ LSP
          "html",
          "cssls",
          "jsonls",
        },
        automatic_installation = true,
      })

      -- Setup each LSP server
      local servers = { "ts_ls", "pyright", "rust_analyzer", "html", "cssls", "jsonls" }

      for _, server in ipairs(servers) do
        lspconfig[server].setup({
          on_attach = on_attach,
          capabilities = capabilities,
        })
      end

      -- C/C++ specific setup
      -- 注意: mason-lspconfig は nvim 0.11+ のネイティブ vim.lsp.config/vim.lsp.enable 経由で
      -- clangd を有効化するため、lspconfig.clangd.setup() は丸ごと無視される（cmd が既定の
      -- { "clangd" } になり ssh 化も引数も効かない）。そのため clangd はネイティブ API で設定する。
      --
      -- agv1 配下で nvim を起動している場合のみ、VM 上の clangd を ssh + path-mappings で使う。
      -- （macOS ではビルドできず、compile_commands.json も /media/psf の Linux パスで生成されるため）
      --   local (nvim/mac):  /Users/tomokikuchi/repos/agv1
      --   remote(clangd/vm): /media/psf/repos/agv1   （Parallels 共有フォルダの実体マウント）
      -- 判定は nvim の起動 cwd で行う（worktree ごとに nvim を起動する運用のため）。
      local REMOTE_CLANGD_ROOT = "/Users/tomokikuchi/repos/agv1"
      local clangd_args = {
        "--background-index",
        "--header-insertion=iwyu",
        "--completion-style=detailed",
        "--function-arg-placeholders",
        "--fallback-style=llvm",
      }
      local function under_agv1(dir)
        dir = vim.fs.normalize(dir or "")
        return dir == REMOTE_CLANGD_ROOT or vim.startswith(dir, REMOTE_CLANGD_ROOT .. "/")
      end
      local clangd_cmd
      if under_agv1(vim.fn.getcwd()) then
        clangd_cmd = vim.list_extend(
          { "ssh", "parallels", "clangd",
            "--path-mappings=" .. REMOTE_CLANGD_ROOT .. "=/media/psf/repos/agv1" },
          vim.deepcopy(clangd_args))
      else
        clangd_cmd = vim.list_extend({ "clangd" }, vim.deepcopy(clangd_args))
      end
      vim.lsp.config("clangd", {
        cmd = clangd_cmd,
        capabilities = capabilities,
        on_attach = on_attach,
      })

      -- Lua-specific setup
      lspconfig.lua_ls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = {
              enable = false,
            },
          },
        },
      })
    end,
  },

  -- Telescope for fuzzy finding (used for references, etc.)
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>",  desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>",    desc = "Find buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>",  desc = "Help tags" },
    },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup()

      -- Emacs 風 <C-x><C-f> は init.lua の vim.g.use_emacs_bindings フラグで制御。
      if vim.g.use_emacs_bindings then
        vim.keymap.set('n', '<C-x><C-f>', ':Telescope find_files<CR>', { desc = 'Find files (Emacs-style)' })
      end
    end,
  },
}
