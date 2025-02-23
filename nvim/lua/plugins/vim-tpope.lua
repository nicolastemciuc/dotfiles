return {
  {
    "tpope/vim-fugitive",
    config = function()
      vim.api.nvim_set_keymap('n', 'gl', ':Git blame<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', 'gb', ':GBrowse<CR>', { noremap = true, silent = true })
    end
  },
  "tpope/vim-rhubarb",
  "tpope/vim-surround",
  "tpope/vim-repeat",
  "tpope/vim-rails",
  "tpope/vim-endwise",
  "tpope/vim-bundler",
  "tpope/vim-unimpaired",
}
