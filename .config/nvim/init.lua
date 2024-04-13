local has = vim.fn.has
local is_wsl = has "wsl"

require("options")
require("keymap")
require("plugins")
require("colorscheme")

-- クリップボード文字化け対策
-- https://zenn.dev/kumavale/scraps/2271c61cbd19ef
if is_wsl then
  vim.cmd [[
    augroup Yank
      au!
      autocmd TextYankPost * :call system('iconv -t utf16 | clip.exe ',@")
    augroup END
  ]]
end

-- 無理やりFern開く https://github.com/nvim-tree/nvim-tree.lua/discussions/1517
vim.schedule(function()
  vim.cmd "Fern . -reveal=% -drawer -stay"
end)
