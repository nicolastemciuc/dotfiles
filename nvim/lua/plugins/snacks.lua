local function grep_dir(key, dir, desc)
  return {
    key,
    function()
      local path = vim.fn.fnamemodify(vim.fn.getcwd() .. "/" .. dir, ":p")
      Snacks.picker.grep({
        cwd = path,
        hidden = true,
        ignored = true,
        exclude = { ".git/", ".ruby-lsp/", "tmp/", "coverage/", "log/", "sorbet/", ".bundle/" },
      })
    end,
    desc = "Grep in " .. desc
  }
end

return {
  "folke/snacks.nvim",
  dependencies = {
    "echasnovski/mini.icons",
  },
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = { enabled = true },
    dashboard = {
      enabled = true,
      preset = {
        header = [[
                                                                     
       ████ ██████           █████      ██                     
      ███████████             █████                             
      █████████ ███████████████████ ███   ███████████   
     █████████  ███    █████████████ █████ ██████████████   
    █████████ ██████████ █████████ █████ █████ ████ █████   
  ███████████ ███    ███ █████████ █████ █████ ████ █████  
 ██████  █████████████████████ ████ █████ █████ ████ ██████ 
        ]],
      },
    }, indent = { enabled = true },
    input = { enabled = true },
    notifier = { enabled = true },
    picker = {
      enabled = true,
      win = {
        input = {
          keys = {
           ["<Esc>"] = { "close", mode = { "n", "i" } },
          }
        }
      },
    },
    quickfile = { enabled = true },
    scroll = { enabled = false },
    statuscolumn = { enabled = true },
    words = { enabled = true },
  },
  keys = {
    { "<leader>p",        function() Snacks.picker() end,             desc = "Show all pickers" },
    { "<C-p>",
      function()
        Snacks.picker.files({
          hidden = true,
          ignored = true,
          exclude = { ".git/", ".ruby-lsp/", "tmp/", "coverage/", "log/", "sorbet/", ".bundle/" },
        })
      end,
      desc = "Find Files"
    },
    { "<leader><leader>", function() Snacks.picker.recent() end,      desc = "Recent Files" },
    { "<leader>fb",       function() Snacks.picker.buffers() end,     desc = "Buffers" },
    grep_dir("<leader>fg", "", "Current Directory"),
    { "<leader>fw",
      function()
        Snacks.picker.grep({
          hidden = true,
          ignored = true,
          exclude = { ".git/", ".ruby-lsp/", "tmp/", "coverage/", "log/", "sorbet/", ".bundle/" },
          search = vim.fn.expand("<cword>"),
          cwd = vim.fn.getcwd() -- Explicitly set the cwd to the current working directory
        })
      end,
      desc = "Grep word under cursor"
    },
    { "<C-n>",            function() Snacks.explorer() end,           desc = "Explorer" },
    { "<leader>q",        function() Snacks.picker.qflist() end,      desc = "Open Quickfix list" },

    -- Rails specific keymaps
    { "<leader>rv", function() Snacks.picker.files({ cwd = "app/views" }) end, desc = "Rails Views" },
    { "<leader>rm", function() Snacks.picker.files({ cwd = "app/models" }) end, desc = "Rails Models" },
    { "<leader>rc", function() Snacks.picker.files({ cwd = "app/controllers" }) end, desc = "Rails Controllers" },
    { "<leader>rh", function() Snacks.picker.files({ cwd = "app/helpers" }) end, desc = "Rails Helpers" },
    { "<leader>rl", function() Snacks.picker.files({ cwd = "lib" }) end, desc = "Rails Lib" },
    { "<leader>rs", function() Snacks.picker.files({ cwd = "spec" }) end, desc = "Rails Spec" },
    { "<leader>rj", function() Snacks.picker.files({ cwd = "app/javascript" }) end, desc = "Rails JavaScript" },
    { "<leader>rf", function() Snacks.picker.files({ cwd = "config" }) end, desc = "Rails Config" },
    { "<leader>rd", function() Snacks.picker.files({ cwd = "db" }) end, desc = "Rails Database" },
    { "<leader>rt", function() Snacks.picker.files({ cwd = "test" }) end, desc = "Rails Tests" },
    { "<leader>ri", function() Snacks.picker.files({ cwd = "config/initializers" }) end, desc = "Rails Initializers" },
    { "<leader>og", function() vim.cmd(":e Gemfile") end, desc = "Open Gemfile" },
    { "<leader>ol", function() vim.cmd(":e Gemfile.lock") end, desc = "Open Gemfile.lock" },
    -- Rails Grep
    grep_dir("<leader>rV", "app/views", "Grep Views"),
    grep_dir("<leader>rM", "app/models", "Grep Models"),
    grep_dir("<leader>rC", "app/controllers", "Grep Controllers"),
    grep_dir("<leader>rH", "app/helpers", "Grep Helpers"),
    grep_dir("<leader>rL", "lib", "Grep Lib"),
    grep_dir("<leader>rS", "spec", "Grep Spec"),
    grep_dir("<leader>rJ", "app/javascript", "Grep JavaScript"),
    grep_dir("<leader>rF", "config", "Grep Config"),
    grep_dir("<leader>rD", "db", "Grep Database"),
    grep_dir("<leader>rT", "test", "Grep Tests"),
    grep_dir("<leader>rI", "config/initializers", "Grep Initializers"),

    -- git
    { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
    { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
    { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
    { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
    { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
    { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
    { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },

    -- LSP
    { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
    { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
    { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
    { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
    { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
    { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
    { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
  }
}
