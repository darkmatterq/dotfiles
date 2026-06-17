
-- =============================================================================
-- DEVOPS PROFESSIONAL NEOVIM CONFIGURATION (ULTRA-STABLE VERSION)
-- =============================================================================

-- 1. PLUGIN MANAGER (Lazy.nvim)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- 2. CẤU HÌNH HỆ THỐNG CƠ BẢN
vim.g.mapleader = " "
local opt = vim.opt

opt.termguicolors = true
opt.background = "dark"
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.clipboard = "unnamedplus"
opt.smartindent = true
opt.autoindent = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.mouse = "a"
opt.ignorecase = true
opt.smartcase = true
opt.updatetime = 50
opt.timeoutlen = 500
opt.ttimeoutlen = 10
opt.undofile = true -- Lưu lịch sử undo ngay cả khi thoát nvim

-- 3. PLUGIN (Quản lý bằng Lazy.nvim)
require("lazy").setup({
  -- Everforest Theme
  { 
    "neanias/everforest-nvim",
    priority = 1000,
    config = function()
      require("everforest").setup({ background = "soft", ui_contrast = "low" })
      vim.cmd([[colorscheme everforest]])
    end,
  },

  -- UI & Appearance
  { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" }, config = function() require('lualine').setup() end },
  { "lewis6991/gitsigns.nvim", config = function() require('gitsigns').setup() end },

  -- Search & Navigation (Telescope)
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Tìm file" })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "Tìm nội dung" })
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "Buffers" })
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = "Hướng dẫn" })
    end
  },

  -- 4. LSP CORE CONFIGURATION
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason.nvim" },
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
      local mason_lsp = require("mason-lspconfig")
      mason_lsp.setup({
        ensure_installed = { "lua_ls", "pyright", "rust_analyzer", "yamlls", "dockerls", "terraformls", "clangd" }
      })

      local lspconfig = require('lspconfig')
      local on_attach = function(_, bufnr)
        local nmap = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
        end
        nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
        nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
        nmap('<leader>rn', vim.lsp.buf.rename, '[R]e-name')
      end

      -- Cách gọi an toàn hơn để tránh lỗi nil value
      if mason_lsp.setup_handlers then
        mason_lsp.setup_handlers({
          function(server_name)
            lspconfig[server_name].setup({
              on_attach = on_attach,
            })
          end,
        })
      end
    end,
  },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      cmp.setup({
        snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
        mapping = {
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({ select = false }),
          ['<Down>'] = cmp.mapping.select_next_item(),
          ['<Up>'] = cmp.mapping.select_prev_item(),
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path' },
        }
      })
    end
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require('nvim-treesitter').setup({
        ensure_installed = { "lua", "python", "rust", "go", "yaml", "dockerfile", "hcl", "json", "markdown" },
        highlight = { enable = true },
      })
    end
  },

  -- Essentials
  { "tpope/vim-surround" },
  { "tpope/vim-commentary" },
  { 
    "mbbill/undotree", 
    config = function() 
      vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, { desc = "Undo Tree" })
    end 
  },
  { "windwp/nvim-autopairs", config = function() require("nvim-autopairs").setup {} end },
})

-- 5. PHÍM TẮT CƠ BẢN
local map = vim.keymap.set
map("n", "<Leader>w", ":w<CR>", { silent = true })
map("n", "<Leader>q", ":q<CR>", { silent = true })
map("n", "<Leader>h", ":nohlsearch<CR>", { silent = true, desc = "Tắt Highlight" })

-- 6. CẤU HÌNH THEO LOẠI FILE (Fix cho DevOps & Makefile)
vim.api.nvim_create_autocmd("Filetype", {
  pattern = { "yaml", "yml", "ansible", "docker-compose" },
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.expandtab = true
  end,
})

vim.api.nvim_create_autocmd("Filetype", {
  pattern = "make",
  callback = function()
    vim.opt_local.expandtab = false -- Bắt buộc dùng Tab cho Makefile
    vim.opt_local.shiftwidth = 4
  end,
})

-- 7. KHẮC PHỤC LỖI TERMINAL (Alacritty/Kitty Double Enter)
-- Neovim 0.10+ tự động bật giao thức CSI u khiến Alacritty bản cũ bị lặp phím.
-- Lệnh dưới đây yêu cầu terminal TẮT giao thức này.
vim.api.nvim_create_autocmd("UIEnter", {
  callback = function()
    io.stdout:write("\27[>0u")
  end,
})

-- Fix cho phím Backspace trong một số terminal
vim.keymap.set('i', '<C-h>', '<BS>', { noremap = true, silent = true })
