# ------------------
# TEMASAGURU's fish cofig
# macOS aarch64/amd64 Ubuntu aarch64/amd64 動作確認済み
# 参考:
# - https://zenn.dev/sawao/articles/0b40e80d151d6a
# - https://zenn.dev/sprout2000/articles/bd1fac2f3f83bc
# - https://scribble.washo3.com/zsh-neovim-2022.html
# - https://gist.github.com/tsu-nera/5648961
# - https://qiita.com/the_red/items/a30e23c66a3d8838912a
# ------------------

# 表示設定
set -g theme_display_date yes
# YYYY-MM-DD HH:mm
set -g theme_date_format "+%F %H:%M"
# mainも表示
set -g theme_display_git_default_branch yes

# hooks --------------------

# direnv
direnv hook fish | source

# Starship
starship init fish | source

# ---------------------------

# GPG署名失敗対策
# https://stackoverflow.com/a/42265848
set -gx GPG_TTY $TTY

# Homebrew PATH
# Rosetta2使うと`uname -m` = 'x86_64'になってしまうので存在で判定
# https://qiita.com/the_red/items/a30e23c66a3d8838912a
if test -d /home/linuxbrew/.linuxbrew
	# Linux/WSL
  set -x HOMEBREW_PREFIX /home/linuxbrew/.linuxbrew
  set -x HOMEBREW_CELLAR /home/linuxbrew/.linuxbrew/Cellar
  set -x HOMEBREW_REPOSITORY /home/linuxbrew/.linuxbrew/Homebrew
  set -x PATH /home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin $PATH
  set -x MANPATH /home/linuxbrew/.linuxbrew/share/man $MANPATH
  set -x INFOPATH /home/linuxbrew/.linuxbrew/share/info $INFOPATH
else if test -d /opt/homebrew
	# M1 Mac
	set HOMEBREW_HOME '/opt/homebrew'
else
	# Intel Mac
	set HOMEBREW_HOME '/usr/local'
end

# asdf https://asdf-vm.com/guide/getting-started.html#_3-install-asdf
source ~/.asdf/asdf.fish

# phpbrew
source ~/.phpbrew/phpbrew.fish

# pnpm
set -gx PNPM_HOME "/home/temasaguru/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

# BAT https://github.com/sharkdp/bat
set -gx PAGER bat

# NEOVIM https://github.com/neovim/neovim
if type -q nvim
  alias vi='nvim'
  alias vim='nvim'
  set -gx EDITOR nvim
  set -gx VISUAL nvim
else if type -q vi
  set -gx EDITOR vi
  set -gx VISUAL vi
end

# スーパー便利エイリアスs ほぼ https://scribble.washo3.com/zsh-neovim-2022.html のまま
switch (uname)
    case Darwin
        alias ls='ls -alFG'
        alias df="df -h"
        alias rm='rm -vR'
    case Linux
        alias ls='ls -Fh --color=auto --group-directories-first'
        alias df="df -Th"
        alias rm='rm -RI'
end
alias mkdir='mkdir -vp'
alias grep="grep --color=auto"
alias fgrep="fgrep --color=auto"
alias egrep="egrep --color=auto"
alias du="du -hc"
alias lsnew="ls -rl *(D.om[1,10])"
alias lsold="ls -rtlh *(D.om[1,10])"
if type -q gsed
  alias sed='gsed'
end
if type -q bat
  alias cat='bat'
  alias more='bat'
end
for c in cp chmod chown rename
  alias $c="$c -v"
end

if type -q rg
  alias rg='rg --colors path:fg:green --colors match:fg:red'
  alias ag=rg
  alias ack=rg
else if type -q ag
  alias ack=ag
  alias ag='ag --color-path 1\;31 --color-match 1\;32 --color'
end

# Laravel Sail
# グローバルインストールする訳では無いが、面倒なので状況にかかわらずエイリアス
# https://laravel.com/docs/10.x/sail#configuring-a-shell-alias
alias sail='[ -f sail ] && sh sail || sh vendor/bin/sail'

# ---------------------
# https://stackoverflow.com/a/61036356 IS_WSLはWSL2にはないが一応
if test -n $IS_WSL || test -n $WSL_DISTRO_NAME
  # WSLでブラウザ開く際にwslviewを指定
  set -gx BROWSER wslview
  alias open=wslview

  # 1Password
  source ~/.agent-bridge.fish
end

# fly.io
set -gx FLYCTL_INSTALL "$HOME/.fly"
set -x PATH $PATH "$HOME/.fly/bin"

# ---------------------
# dotfiles用 gitエイリアス
# 例: `config add <dotfilesにコミットしたいファイル>`
# README参照
# https://www.ackama.com/what-we-think/the-best-way-to-store-your-dotfiles-a-bare-git-repository-explained/
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

