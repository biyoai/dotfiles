local fn = vim.fn

-- 以下、参考: https://www.chiarulli.me/Neovim-2/03-plugins/
-- packer自動インストール
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system({
    'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path,
  })
  print('Neovimを再起動します')
  vim.cmd([[packadd packer.nvim]])
end

-- このファイル保存時に自動リロード
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- 初回起動でエラーにならないように
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Packerをポップアップ表示
packer.init({
  display = {
    open_fn = function()
      return require("packer.util").float({ border = "rounded" })
    end,
  },
})

return packer.startup(function(use)
  -- 以下ラインナップ参考: https://zenn.dev/hisasann/articles/neovim-settings-to-lua
  use({ "wbthomason/packer.nvim" })

  -- 便利関数
  use({ "nvim-lua/plenary.nvim" })

  -- 表示改善
  use({ "folke/tokyonight.nvim" })
  use({ "nvim-lualine/lualine.nvim" })
  use({ "kyazdani42/nvim-web-devicons" })

  -- LSP系
  use({ 'windwp/nvim-autopairs' })

  -- タブ
  use({ "akinsho/bufferline.nvim", requires = 'nvim-tree/nvim-web-devicons' })

  -- ファイル検索系
  use({ "nvim-telescope/telescope.nvim" })
  use({ "nvim-telescope/telescope-file-browser.nvim" })
  use {
    'junegunn/fzf.vim',
    requires = { 'junegunn/fzf', run = ':call fzf#install()' }
  }

  -- エクスプローラ
  use({
    'lambdalisue/fern.vim',
  })

  -- TeX
  use({ 'lervag/vimtex' })

  -- ターミナル
  use({
    'akinsho/toggleterm.nvim',
    tag = '*',
  })

  -- git
  use({ 'dinhhuy258/git.nvim' })

  -- 時間計測
  use({'wakatime/vim-wakatime'})

  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
