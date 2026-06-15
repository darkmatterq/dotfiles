
-- =============================================================================
-- FINAL STABILITY CONFIGURATION (Isolation Mode)
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

-- 3. CẤU HÌNH THỤT LỀ & FORMAT (Sạch sẽ & Thông minh)
opt.smartindent = true -- Bật lại tính năng thụt lề thông minh (ví dụ: tự thụt dòng sau dấu ngoặc nhọn)
opt.autoindent = true
opt.cindent = true
opt.formatoptions = "qj" -- Xóa r, o (tự chèn comment khi Enter) để tránh lỗi

-- 4. PLUGIN (Quản lý bằng Lazy.nvim)
require("lazy").setup({
  -- Everforest Theme
  { 
    "neanias/everforest-nvim",
    config = function()
      require("everforest").setup({ background = "soft", ui_contrast = "low" })
      vim.cmd([[colorscheme everforest]])
    end,
  },
  
  -- Các công cụ thiết yếu (Đã được khôi phục)
  { "tpope/vim-surround" },
  { "tpope/vim-commentary" },
  { "airblade/vim-gitgutter" },
  { "mbbill/undotree" },
  { "junegunn/fzf.vim", dependencies = { "junegunn/fzf" } },
})

-- 5. PHÍM TẮT CƠ BẢN
local map = vim.keymap.set
map("n", "<Leader>w", ":w<CR>", { silent = true })
map("n", "<Leader>q", ":q<CR>", { silent = true })
map("n", "<Leader>u", ":UndotreeToggle<CR>", { silent = true })

-- 6. KHÓA CHẶT TÍN HIỆU PHÍM ENTER CHO ALACRITTY
-- Chúng ta map Enter về mã ASCII chuẩn nhất
vim.cmd([[inoremap <CR> <CR>]])

-- =============================================================================
-- THE ULTIMATE FIX: DISABLE KITTY KEYBOARD PROTOCOL
-- Neovim 0.12+ tự động bật "Kitty Keyboard Protocol" nếu phát hiện Alacritty.
-- Giao thức này đang bị lỗi và gửi phím Enter 2 lần. 
-- Lệnh dưới đây sẽ ép Neovim "tắt" giao thức này ngay khi khởi động.
-- =============================================================================
vim.api.nvim_create_autocmd("UIEnter", {
  callback = function()
    io.stdout:write("\27[<u") -- Mã Escape để vô hiệu hóa Kitty Protocol
  end,
})

