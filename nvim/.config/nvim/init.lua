-- /home/ateebamateen/.config/nvim/init.lua

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim", lazypath })
end
vim.opt.rtp:prepend(lazypath)
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.clipboard = "unnamedplus"
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.cursorline = true


-- autostart QML server
vim.lsp.config("qmlls", {
  cmd = { "qmlls" },
  filetypes = { "qml" },
  root_markers = { ".git" },
})
vim.lsp.enable("qmlls")


-- for current scope highlight
vim.api.nvim_set_hl(0, "@scope", {
  bg = "#2a2b3c",
})

-- Keymaps
vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>")
-- vim.keymap.set("n", "<C-S-i>", function() require("conform").format() end)
-- vim.keymap.set("n", "<leader>f", function() require("conform").format() end)
vim.keymap.set({ "n", "i", "v" }, "<F3>", function()
  local ft = vim.bo.filetype
  if ft == "qml" then
    vim.lsp.buf.format()
  else
    require("conform").format()
  end
end)


vim.keymap.set({ "n", "i", "v" }, "<C-_>", function()
  require("Comment.api").toggle.linewise.current()
end)

-- Copy Paste Shortcuts Hijacked from terminal
vim.keymap.set({ "n", "v", "i" }, "<C-S-c>", '"+y')
vim.keymap.set({ "n", "v", "i" }, "<C-S-v>", '"+p')
vim.keymap.set({ "n", "v", "i" }, "<C-a>", "<Esc>ggVG")
vim.keymap.set({ "n", "v", "i" }, "<C-s>", "<Esc>:w<CR>")
vim.keymap.set({ "n", "v", "i" }, "<C-x>", "<Esc>:q!<CR>")
vim.keymap.set({ "n", "v", "i" }, "<C-q>", "<Esc>:wq<CR>")

-- Tab switching hijacked as well (in terminal mode as well)
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')
vim.keymap.set('t', '<C-PageUp>', '<C-\\><C-n>gT')
vim.keymap.set('t', '<C-PageDown>', '<C-\\><C-n>gt')

-- keymaps for the telescope and its helper plugin
vim.keymap.set("n", "<C-p>", ":Telescope find_files<CR>", { desc = "Telescope Find Files" })
vim.keymap.set("n", "<C-f>", ":Telescope live_grep<CR>", { desc = "Telescope Live Grep" })
vim.keymap.set("n", "<C-k>", ":Telescope keymaps<CR>", { desc = "Telescope Show Set Mappings" })
vim.keymap.set("n", "<leader>b", ":Telescope buffers<CR>", { desc = "Show open buffers" })
vim.keymap.set("n", "<C-h>", ":Cheatsheet<CR>")
vim.keymap.set("n", "<C-S-h>", ":Telescope help_tags<CR>")



-- copy selection down or up
vim.keymap.set("v", "<A-C-Down>", "y'>p", { desc = "Copy selection down" })
vim.keymap.set("v", "<A-C-Up>", "y'<P", { desc = "Copy selection up" })

-- Move selection up/down
vim.keymap.set("v", "<A-Down>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<A-Up>", ":m '<-2<CR>gv=gv")

-- Move line up/down
vim.keymap.set("n", "<A-Down>", ":m .+1<CR>==")
vim.keymap.set("n", "<A-Up>", ":m .-2<CR>==")

-- Copy line up/down
vim.keymap.set("n", "<A-C-Down>", "yyp")
vim.keymap.set("n", "<A-C-Up>", "yyP")




-- Enabled Mouse Menu in All modes
vim.opt.mouse = "a"
vim.opt.mousemodel = "popup"

-- Enable code folding
-- vim.opt.foldmethod = "indent"
vim.opt.foldlevel = 0    -- start with everything unfolded
vim.opt.foldcolumn = "3" -- shows the fold gutter

-- vim.opt.foldmethod = "expr"
-- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

vim.opt.foldmethod = "marker"
vim.opt.foldmarker = "{,}"



-- Downloaded Plugins
require("lazy").setup({
  git = { filter = false },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("tokyonight-night")
    end,
  },
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    opts = {}
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "Isrothy/neominimap.nvim",
    lazy = false,
    init = function()
      vim.opt.wrap = false
      vim.opt.sidescrolloff = 36
      vim.g.neominimap = {
        auto_enable = true,
      }
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup()
    end,
  },
  {
    "sudormrfbin/cheatsheet.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    -- Only make the keybindings searchable
    config = function()
      require("cheatsheet").setup({
        bundled_cheatsheets = {
          enabled = { "default", "vim-builtin" },
        },
      })
    end,
  },
  {
    "mikavilpas/yazi.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>e", "<cmd>Yazi<cr>",     desc = "Open yazi" },
      { "<leader>E", "<cmd>Yazi cwd<cr>", desc = "Open yazi in cwd" },
    },
    opts = {
      open_for_directories = true,
    },
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "kdl", "lua", "python", "javascript", "typescript", "html", "css" },
        highlight = { enable = true },
      })
    end,
  },
  -- {
  --   "nvim-treesitter/nvim-treesitter",
  --   branch = "main", -- change from "master" to "main"
  --   lazy = false,
  --   build = ":TSUpdate",
  --   config = function()
  --     require("nvim-treesitter").setup({
  --       ensure_installed = { "kdl", "lua", "python", "javascript", "typescript", "html", "css", "qml" },
  --     })
  --   end,
  -- },
  {
    "nvim-treesitter/nvim-treesitter-context",
    opts = {},
  },
  {
    "echasnovski/mini.indentscope",
    version = false,
    opts = {
      symbol = "│",
    },
  },
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        update_focused_file = {
          enable = true,
          update_root = true,
        },
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" },
          kdl = { "kdlfmt" },
          html = { "prettier" },
          css = { "prettier" },
          json = { "prettier" },
          qml = { "qmlformat" },
        },
        formatters = {
          qmlformat = {
            exit_codes = { 0, 1 },
            args = { "-f", "$FILENAME" },
          },
        },
      })
    end,
  },

  -- { "Leon-Degel-Koehn/qmlformat.nvim" },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({})
    end,
  },
  {
    "nanozuki/tabby.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("tabby").setup({})
    end,
  },

  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },
  {
    "NvChad/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({
        filetypes = { "*" },
        user_default_options = {
          RRGGBBAA = true,
        },
      })
    end,
  },
  -- {
  --   "akinsho/bufferline.nvim",
  --   dependencies = "nvim-tree/nvim-web-devicons",

  --   config = function()
  --     require("bufferline").setup({
  --       options = {
  --         right_mouse_command = nil, -- disables right click
  --       }
  --     })
  --   end,
  -- },
  -- adding plugins for LSP language support
  { "mason-org/mason.nvim", config = true },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
    opts = {
      ensure_installed = { "pyright", "lua_ls", "ts_ls", "html", "cssls" },
    },
  },
  -- this is for my own experiment to show a checkerboard behind alpha colors in buffer in nvim
  {
    "3rd/image.nvim",
    build = false,
    config = function()
      require("image").setup({
        backend = "kitty",
        processor = "magick_cli",
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- Python
      vim.lsp.config("pyright", {})
      vim.lsp.enable("pyright")

      -- Lua (for nvim config itself)
      vim.lsp.config("lua_ls", {})
      vim.lsp.enable("lua_ls")

      -- JavaScript / TypeScript
      vim.lsp.config("ts_ls", {})
      vim.lsp.enable("ts_ls")

      -- HTML
      vim.lsp.config("html", {})
      vim.lsp.enable("html")

      -- CSS / SCSS / LESS
      vim.lsp.config("cssls", {})
      vim.lsp.enable("cssls")

      -- KDL (installed manually via: cargo install kdl-lsp)
      vim.lsp.config("kdl_ls", {
        cmd = { "kdl-lsp" },
        filetypes = { "kdl" },
        root_markers = { ".git" },
      })
      vim.lsp.enable("kdl_ls")
    end,
  },
})





-- Personal Plugins
-- require("colorswatches")



vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", { fg = "#ffff00" })
-- active block scope highlight

-- local ns = vim.api.nvim_create_namespace("active_scope")
-- vim.api.nvim_set_hl(0, "ActiveScope", { bg = "#2a2f45" })

-- local function update_scope()
--   vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)

--   local cursor_line = vim.api.nvim_win_get_cursor(0)[1] - 1
--   local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

--   -- find nearest { above cursor
--   local open_line = nil
--   for i = cursor_line, 0, -1 do
--     if lines[i + 1] and lines[i + 1]:find("{") then
--       open_line = i
--       break
--     end
--   end
--   if not open_line then return end

--   -- find matching } below
--   local depth = 0
--   local close_line = nil
--   for i = open_line, #lines - 1 do
--     local l = lines[i + 1]
--     for ch in l:gmatch(".") do
--       if ch == "{" then
--         depth = depth + 1
--       elseif ch == "}" then
--         depth = depth - 1
--         if depth == 0 then
--           close_line = i
--           break
--         end
--       end
--     end
--     if close_line then break end
--   end
--   if not close_line then return end

--   -- highlight every line in range
--   for line = open_line, close_line do
--     vim.api.nvim_buf_set_extmark(0, ns, line, 0, {
--       line_hl_group = "ActiveScope",
--       priority = 200,
--     })
--   end
-- end

-- local timer = vim.uv.new_timer()
-- vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
--   callback = function()
--     timer:stop()
--     timer:start(40, 0, vim.schedule_wrap(update_scope))
--   end,
-- })



local ns = vim.api.nvim_create_namespace("active_scope")
vim.api.nvim_set_hl(0, "ActiveScope", { bg = "#2d1a2e" })
local function update_scope()
  vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)

  local cursor_line = vim.api.nvim_win_get_cursor(0)[1] - 1
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  -- scan backwards to find the matching open {
  local depth = 0
  local open_line = nil
  for i = cursor_line, 0, -1 do
    local l = lines[i + 1]
    -- scan characters right to left
    for j = #l, 1, -1 do
      local ch = l:sub(j, j)
      if ch == "}" then
        depth = depth + 1
      elseif ch == "{" then
        if depth == 0 then
          open_line = i
          break
        end
        depth = depth - 1
      end
    end
    if open_line then break end
  end
  if not open_line then return end

  -- scan forwards to find the matching close }
  depth = 0
  local close_line = nil
  for i = open_line, #lines - 1 do
    local l = lines[i + 1]
    for j = 1, #l do
      local ch = l:sub(j, j)
      if ch == "{" then
        depth = depth + 1
      elseif ch == "}" then
        depth = depth - 1
        if depth == 0 then
          close_line = i
          break
        end
      end
    end
    if close_line then break end
  end
  if not close_line then return end

  -- vim.notify("open: " .. open_line .. " close: " .. close_line)
  for line = open_line, close_line do
    vim.api.nvim_buf_set_extmark(0, ns, line, 0, {
      line_hl_group = "ActiveScope",
      priority = 50,
    })
  end
end

local timer = vim.uv.new_timer()
vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
  callback = function()
    timer:stop()
    timer:start(40, 0, vim.schedule_wrap(update_scope))
  end,
})


-- Change colors based on mode:
vim.api.nvim_create_autocmd("ModeChanged", {
  callback = function()
    local mode = vim.fn.mode()
    if mode == "i" then
      vim.api.nvim_set_hl(0, "Normal", { bg = "#1a0a2e" })
    elseif mode == "v" or mode == "V" then
      vim.api.nvim_set_hl(0, "Normal", { bg = "#0a1a0e" })
    else
      vim.api.nvim_set_hl(0, "Normal", { bg = "#1a1b26" })
    end
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function(event)
    vim.fn.mkdir(vim.fn.fnamemodify(event.file, ":p:h"), "p")
  end,
})


-- auto-cmd for auto-generation and insertion of absolute file path a the top of a file whenever opened with nvim.

local function filepath_header()
  local path = vim.fn.expand("%:p")
  if path == "" then return end

  local ft = vim.bo.filetype
  if ft == "json" then return end

  local cs = vim.bo.commentstring
  local line
  if cs and cs:find("%%s") then
    line = cs:gsub("%%s", path)
  else
    line = "# " .. path
  end

  local first = vim.fn.getline(1)
  local second = vim.fn.getline(2)

  if first:match("^#!") then
    -- shebang on line 1, operate on line 2
    if second:match("^%s*[#/;\"%-<].*/") then
      vim.api.nvim_buf_set_lines(0, 1, 2, false, { line })
    else
      vim.api.nvim_buf_set_lines(0, 1, 1, false, { line, "" })
    end
  elseif first:match("^%s*[#/;\"%-<].*/") then
    -- existing path header, replace it
    vim.api.nvim_buf_set_lines(0, 0, 1, false, { line })
  else
    -- fresh file, insert at top
    vim.api.nvim_buf_set_lines(0, 0, 0, false, { line, "" })
  end
end

vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPost" }, {
  callback = filepath_header,
})
