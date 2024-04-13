-- https://github.com/craftzdog/dotfiles-public/blob/master/.config/nvim/after/plugin/autopairs.rc.lua
local status, autopairs = pcall(require, "nvim-autopairs")
if (not status) then return end

autopairs.setup({
  disable_filetype = { "TelescopePrompt" , "vim" },
  -- 補完系プラグインないので
  map_cr = true,
})

