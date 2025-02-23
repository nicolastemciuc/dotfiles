local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("vim-options")

require("lazy").setup("plugins")

 -- Enable persistent undo
vim.opt.undofile = true

-- use clipboard
vim.opt.clipboard = "unnamedplus"

-- Fetch the GitHub Enterprise URL from the environment variable
local ghe_url = os.getenv("GITHUB_ENTERPRISE_URL")

if ghe_url then
  vim.g.github_enterprise_urls = { ghe_url }
end

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local arg = vim.fn.argv(0)
    if arg and vim.fn.isdirectory(arg) == 1 then
      -- If a directory is opened, set it as the working directory
      vim.cmd('cd ' .. arg)
    elseif arg and vim.fn.filereadable(arg) == 1 then
      -- If a file is opened, set the working directory to its parent directory
      vim.cmd('cd ' .. vim.fn.fnamemodify(arg, ':h'))
    end
  end,
})

local app_root = nil

vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    local path = vim.fn.expand("%:p")
    if path:match("/gems/") then
      -- Save the app's root if not already saved
      if not app_root then
        app_root = vim.fn.getcwd()
      end
      -- Change directory to the gem's location
      vim.cmd("cd " .. vim.fn.fnamemodify(path, ":h"))
    elseif app_root then
      -- If leaving the gem and the app's root is saved, restore it
      vim.cmd("cd " .. app_root)
    end
  end,
})
