return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local config = require("nvim-treesitter.configs")
      config.setup({
        auto_install = true,
        highlight = {
          enable = true,
          -- Disable highlighting for specific file types using the 'disable' option
          disable = function(lang, bufnr)
            local filename = vim.api.nvim_buf_get_name(bufnr)
            -- Disable for .html.erb files
            if filename:match("%.html.erb$") then
              return true
            end
            return false
          end,
        },
        indent = { enable = true },
      })
    end
  }
}
