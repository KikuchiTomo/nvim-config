return {
  -- Enhanced markdown rendering
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    ft = { "markdown", "Avante" },
    config = function()
      require("render-markdown").setup({
        enabled = true,
        max_file_size = 1.5,
        debounce = 100,
        render_modes = { "n", "c" },
        heading = {
          enabled = true,
          sign = true,
          icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
          backgrounds = {
            "RenderMarkdownH1Bg",
            "RenderMarkdownH2Bg",
            "RenderMarkdownH3Bg",
            "RenderMarkdownH4Bg",
            "RenderMarkdownH5Bg",
            "RenderMarkdownH6Bg",
          },
          foregrounds = {
            "RenderMarkdownH1",
            "RenderMarkdownH2",
            "RenderMarkdownH3",
            "RenderMarkdownH4",
            "RenderMarkdownH5",
            "RenderMarkdownH6",
          },
        },
        code = {
          enabled = true,
          sign = true,
          style = "full",
          left_pad = 0,
          right_pad = 0,
          width = "block",
          border = "thin",
          highlight = "RenderMarkdownCode",
        },
        bullet = {
          enabled = true,
          icons = { "●", "○", "◆", "◇" },
        },
        checkbox = {
          enabled = true,
          unchecked = {
            icon = "󰄱 ",
            highlight = "RenderMarkdownUnchecked",
          },
          checked = {
            icon = "󰱒 ",
            highlight = "RenderMarkdownChecked",
          },
        },
        quote = {
          enabled = true,
          icon = "▎",
          highlight = "RenderMarkdownQuote",
        },
        link = {
          enabled = true,
          image = "󰥶 ",
          hyperlink = "󰌹 ",
          highlight = "RenderMarkdownLink",
        },
      })

      -- Toggle markdown rendering
      vim.keymap.set("n", "<leader>mr", ":RenderMarkdown toggle<CR>", { desc = "Toggle markdown rendering" })
    end,
  },
}
