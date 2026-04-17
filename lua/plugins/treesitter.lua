return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").setup({
      install_dir = vim.fn.stdpath("data") .. "/site",
    })

    local parsers = {
      "lua", "vim", "vimdoc",
      "javascript", "typescript", "tsx",
      "python", "rust", "c", "cpp",
      "html", "css", "json", "yaml", "toml",
      "bash", "markdown", "markdown_inline",
      "gitcommit", "diff",
    }

    require("nvim-treesitter").install(parsers)

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("TreesitterStart", { clear = true }),
      callback = function(args)
        local buf = args.buf
        local filetype = args.match
        local lang = vim.treesitter.language.get_lang(filetype)
        if not lang then return end
        if not pcall(vim.treesitter.start, buf, lang) then return end
        pcall(function()
          vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end)
      end,
    })
  end,
}
