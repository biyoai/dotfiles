vim.scriptencoding = "utf-8"

-- 全体の設定
-- 参考: https://zenn.dev/hisasann/articles/neovim-settings-to-lua
local options = {
  encoding = "utf-8",
  fileencoding = "utf-8",
  title = true,
  clipboard = "unnamedplus",
  showtabline = 2,
  smartcase = true,
  smartindent = true,
  termguicolors = true, -- true color
  shell = "fish",
  expandtab = true,
  shiftwidth = 2,
  tabstop = 2,
  cursorline = true,
  number = true,
  relativenumber = false,
  numberwidth = 4, -- 行番号表示の桁数
  wrap = true,
  background = "dark",
  guifont = "Source Code Pro for Powerline:h17",
}

vim.opt.shortmess:append("c")

for k, v in pairs(options) do
  vim.opt[k] = v
end

