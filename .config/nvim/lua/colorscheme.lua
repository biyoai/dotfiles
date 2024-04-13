-- https://zenn.dev/hisasann/articles/neovim-settings-to-lua
vim.cmd [[
try
  colorscheme tokyonight
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme default
  set background=dark
endtry
]]
