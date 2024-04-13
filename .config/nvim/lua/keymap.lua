-- 以下使いまわし設定
-- 参考: https://zenn.dev/hisasann/articles/neovim-settings-to-lua
local opts = { noremap = true, silent = true }
local term_opts = { silent = true }
local keymap = vim.api.nvim_set_keymap

-- Leaderキーはとりあえずスペース
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- 各モードに対してキーマップしていく
-- モード
--   normal = 'n',
--   insert = 'i',
--   visual = 'v',
--   visual_block = 'x',
--   term = 't',
--   command = 'c',

-- 以下、ノーマルモードのキーマップ
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)
--   タブ操作
keymap("n", "te", ":tabedit", opts)
keymap("n", "gn", ":tabnew<Return>", opts) -- タブ開く
keymap("n", "ss", ":split<Return><C-w>w", opts)
keymap("n", "sv", ":vsplit<Return><C-w>w", opts) -- 画面分割
keymap("n", "gh", "gT", opts) -- タブ移動
keymap("n", "gl", "gt", opts) -- タブ移動
--   全選択
keymap("n", "<C-a>", "gg<S-v>G", opts)
--   Fern開いてフォーカス
keymap("n", "<Leader>e", ":Fern . -reveal=% -drawer<CR>", opts)
--   Toggleterm
keymap("n", "<leader>th", "<CMD>ToggleTerm size=10 direction=horizontal<CR>", opts)
keymap("n", "<leader>tv", "<CMD>ToggleTerm size=80 direction=vertical<CR>", opts)
--   lazygit
--   https://zenn.dev/stafes_blog/articles/524e4c8c80db24
keymap("n", "lg", "<cmd>lua _lazygit_toggle()<CR>", opts)
--   ファイル検索
keymap("n", "<C-p>", "<cmd>Telescope find_files<cr>", opts)

