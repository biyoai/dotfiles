-- 参考: https://github.com/craftzdog/dotfiles-public/blob/master/.config/nvim/after/plugin/git.rc.lua
local status, git = pcall(require, "git")
if (not status) then return end

git.setup({
  keymaps = {
    -- Blame開く
    blame = "<Leader>gb",
    -- ファイル開く
    browse = "<Leader>go",
  }
})

