return {
  -- Mason (LSP installer) - must be loaded first
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
  },

  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
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

        -- Print message when LSP attaches
        print(string.format("LSP attached: %s", client.name))

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

      -- Setup mason-lspconfig with automatic server setup
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

      -- Automatically setup all installed servers
      require("mason-lspconfig").setup_handlers({
        -- Default handler for all servers
        function(server_name)
          lspconfig[server_name].setup({
            on_attach = on_attach,
            capabilities = capabilities,
          })
        end,

        -- Custom handler for lua_ls
        ["lua_ls"] = function()
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
      })
    end,
  },

  -- Telescope for fuzzy finding (used for references, etc.)
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup()

      -- Keybindings
      vim.keymap.set('n', '<leader>ff', ':Telescope find_files<CR>', { desc = 'Find files' })
      vim.keymap.set('n', '<leader>fg', ':Telescope live_grep<CR>', { desc = 'Live grep' })
      vim.keymap.set('n', '<leader>fb', ':Telescope buffers<CR>', { desc = 'Find buffers' })
      vim.keymap.set('n', '<leader>fh', ':Telescope help_tags<CR>', { desc = 'Help tags' })
      vim.keymap.set('n', '<C-x><C-f>', ':Telescope find_files<CR>', { desc = 'Find files (Emacs-style)' })
    end,
  },
}
