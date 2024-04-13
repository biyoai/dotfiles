-- 参考: https://dev.to/slydragonn/how-to-set-up-neovim-for-windows-and-linux-with-lua-and-packer-2391

local status, toggleterm = pcall(require, "toggleterm")

if not status then
    return
end

toggleterm.setup({
    size = 10,
    open_mapping = [[<F7>]],
    shading_factor = 2,
    direction = "float",
    float_opts = {
        border = "curved",
        highlights = {
            border = "Normal",
            background = "Normal",
        },
    },
})

-- https://zenn.dev/stafes_blog/articles/524e4c8c80db24
local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new({
	cmd = "lazygit",
	direction = "float",
	hidden = true
})

-- dotfilesはgitディレクトリが違うので
local lazygitForDotfiles = Terminal:new({
	cmd = "lazygit --git-dir=$HOME/.cfg/ --work-tree=$HOME",
	direction = "float",
	hidden = true
})

function _lazygit_toggle()
  local path = vim.fn.getcwd()
  -- これ以外にdotfiles判定できる方法ねえかな
  -- これLinux限定やんけ！
  if path == '/home/temasaguru' then
    lazygitForDotfiles:toggle()
  else
	  lazygit:toggle()
  end
end
