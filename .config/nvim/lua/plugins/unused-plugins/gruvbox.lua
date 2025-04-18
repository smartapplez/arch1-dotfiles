return {
  "ellisonleao/gruvbox.nvim",
  priority = 1000,
  config = function()
    vim.o.background = "dark" -- or "light" for Gruvbox light variant
    require("gruvbox").setup({
      contrast = "hard", -- can be "hard", "soft" or empty string
      transparent_mode = true,
    })
    vim.cmd("colorscheme gruvbox")
  end,
}
