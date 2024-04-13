# dotfiles

Win も Mac も両方使うので、ここにセットアップのナレッジを集約する

> [!Warning]
> このリポジトリのREADME・コメント等は自分用に書いた説明のため、参考にした場合の動作保証はしておりません。
> 損害の責任も負いかねます。

## 参考

その他、細かい設定やセットアップ手順でツールのREADMEなどを参考にしておりますが、リポジトリのURLをもってかえさせていただきます。

### セットアップ

Hacker News に投稿された、work-tree を`$HOME`にする dotfiles 管理方法の、詳細な解説。

https://www.ackama.com/what-we-think/the-best-way-to-store-your-dotfiles-a-bare-git-repository-explained/

### 1Password の SSH エージェントの使用

#### bashと1PasswordとWSL2の組み合わせ

https://gist.github.com/WillianTomaz/a972f544cc201d3fbc8cd1f6aeccef51#3-connect-wsl-with-1passwords-ssh-agent

#### fish shellと1PasswordとWSL2の組み合わせ

https://antho.dev/utiliser-le-ssh-agent-de-1password-sur-wsl2-avec-fish-shell/

### WSL のマウントについて

https://yanor.net/wiki/?Windows/WSL/Windows%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB%E3%82%B7%E3%82%B9%E3%83%86%E3%83%A0%E3%81%AEchmod%E3%81%A8chown

### WSLにおけるFish shellの使用

https://tech.ateruimashin.com/2021/03/wsl2_fish_shell/

## 前提条件

- Windows 11 23H2 (x86) で検証済
- macOS Big Sur (arm)で検証済 (それより新しいバージョンで検証できていない)

### 方向性

- 基本的にUbuntu(WSL2)を基準とし、Macでクローン時に問題が生じたなら修正する形をとる
- SSH Agentは1Passwordのものを使用
- ただしコミット署名はSSH鍵ではなくGPGを使用

### 前提としているサブスク

- 1Password
- GitHub Copilot
- (2024.4) JetBrains系IDEは一旦使用をやめた

---

### JetBrains系IDEの共通設定

- **JetBrains Toolboxインストール後、各IDEを英語でインストールする。**
- **各ツールのConfigure→Settings Syncで、アカウントから設定をPullする。**

アカウントに設定がない場合、共通で以下の設定を適用する。

- 外観 & 振る舞い
  - 外観
    - テーマ: `Light with Light Header` / OSと同期OFF (OSと同期するとメニューが黒くなってしまう)
    - メインメニューを別のツールバーに表示する ON
      - これがOFFだとハンバーガーメニューをいちいち開く必要がある
  - 新しいUIの有効化 ON
    - コンパクトモード ON
    - メインメニューを別のツールバーに表示する ON
- システム設定
  - プロジェクト
    - 起動時に前回のプロジェクトを開く OFF

※不安な場合はファイルとして設定をエクスポートできる

---

## このリポジトリ自体のメンテ方法

※**Windowsの場合、WSLのVHDにリポジトリを内蔵しているので、後述するWSLのインポートができれば、クローンする必要はない。**

https://www.atlassian.com/git/tutorials/dotfiles

こちらで紹介されている方法。 **ベアリポジトリとしてクローンし、`.cfg`を`.git`の代わりに使う。**

### コミットとプッシュ

```sh
config checkout -b <ブランチ名>
```

**必ずブランチを切ること！**

```sh
config add <管理したいファイル>
config commit -m <メッセージ>
```

```sh
/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME <ここにコマンド>
```

`config`は上記のエイリアスとなっているので、セットアップ未完成状態で git 操作したい場合は上記のようにすればよい。

---

以下、Windows(WSL)とMacを完全に分けて書いている。(昔はごっちゃにしていたが、SSH/GPG関連であまりに違いが大きいため分けた)

---

## 環境復元(Windows)

Windows Terminalを既定のターミナルに設定する。

https://apps.microsoft.com/detail/9NBLGGH4NNS1

すべての作業より先に、「アプリインストーラー」を更新しないとwingetをちゃんと使えない(Windows 11 22631.3007現在)。

https://learn.microsoft.com/ja-jp/windows/package-manager/winget/

また、上記ページに掲載されている`Add-AppxPackage`コマンドが必要な場合もある。

```ps
winget install Microsoft.PowerShell  -e
```

PowerShell7を入れ、ターミナルの既定のプロファイルにする。

### Win:アプリ

#### winget で済むもの

`-e` はIDを厳密に指定するでという意味。

```ps
winget install --id=AgileBits.1Password  -e
winget install --id=dbeaver.dbeaver -e
winget install --id=Microsoft.VisualStudioCode  -e
winget install --id=Microsoft.PowerToys  -e
winget install --id=Figma.Figma  -e
winget install --id=WinDirStat.WinDirStat  -e
```

### Win:VS Codeを設定する

GitHubアカウントでログインして設定を同期する。

### Win:Cicaフォントを入れる

https://github.com/miiton/Cica

ターミナルで使う

### Win:nipiperelayのインストール

1Password の SSH エージェントを使うために`npiperelay`を入れる。

**Powershellで**以下のコマンドを実行する。

```sh
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser 
irm get.scoop.sh | iex
scoop install git
scoop bucket add extras
scoop install npiperelay
```

### Win:WSLごとバックアップから復元する場合

#### Win:旧マシンでWSLのエクスポート

```ps
wsl --export docker-desktop-data $env:USERPROFILE\wsl\backups\ docker-desktop-data.tar
```

- wsl
  - instances
    - Ubuntu
	    - ext4.vhdx

**wslディレクトリをNASにコピーする。注意として、Ubuntuは「VHDXイメージそのものがマシン」。**

docker-desktop-dataはデカすぎるのでバックアップしない。

#### Win:新PCでWSLを有効化

ここだけは管理者権限のPowerShellで。

```ps
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```

再起動する。

https://learn.microsoft.com/ja-jp/windows/wsl/install-manual#step-4---download-the-linux-kernel-update-package

カーネル更新パッケージを入れる。

再起動する。

#### Win:新PCでUbuntuをインポート

```ps
mkdir $env:USERPROFILE\wsl\instances
wsl --import-in-place Ubuntu $env:USERPROFILE\wsl\instances\Ubuntu\ext4.vhdx
```

これでUbuntuをインポートできた。**GPG鍵も内蔵されているため、以降のWSL内の作業は一切必要ない。**

### Ubuntuのセットアップをやり直す場合

```ps
sudo vi /etc/wsl.conf
```

```toml
[user]
default=temasaguru
```

wsl.confでユーザー名を指定する。※UbuntuとMacではこのユーザー名を使っているが特に意味はない

それから`wsl --shutdown`で入りなおせば、以前のUbuntuが使えるはずだ。

Windows Terminalのプロファイルが消えた場合、新規作成→「Ubuntu」からコピーする。ubuntu.exe が指定されていればよい。

1Passwordの設定でSSHエージェントを有効化するのを忘れずに。

https://stackoverflow.com/a/68377832

Dockerが動かない場合、上記のシンボリックリンクが失われていないか確認する。

#### WSLのGPGを設定する

1Passwordから秘密鍵をダウンロードする。

**Git for Windowsを使わない限り、KreopatraでGPG鍵をインポートする必要はない**

```sh
mkdir ~/.gnupg
```

`~/.gnupg/gpg-agent.conf` を以下のように編集する。([参考](https://stackoverflow.com/a/63474095))

```
default-cache-ttl 2592000
max-cache-ttl 2592000
pinentry-program "/mnt/c/Program Files (x86)/GnuPG/bin/pinentry-basic.exe"
```

後述するgitの設定も合わせれば、コミット時にパスフレーズのプロンプトが GUI で出るようになる。その際は1Password のクイックアクセスを Ctrl+Shift+Space で開けば GPG パスフレーズをすぐ探せる。

#### WSLのGPG鍵のインポート

```sh
gpg --import <秘密鍵パス>
```

1Passwordにパスフレーズがあるので入力する。

```sh
gpg --edit-key 410B7848C1675824 trust quit
```

意図した鍵がインポートされているなら、究極に信頼するを選択。

ターミナルを開き直し、 `gpg --edit-key 410B7848C1675824` で信頼が `[究極]` になっているのを確認する。

もし署名できない場合、`change-usage` で `Sign Certify` 可能にして保存する必要がある。

#### シンボリックリンクと権限

```sh
sudo vi /etc/wsl.conf
```

```conf
[automount]
options = "metadata,umask=22,fmask=11"
```

マウントした部分の権限をいじれるようにする。

**`systemctl`は絶対にオフにしろ！！！！！** gpg-agentが正常に動作しない。

#### WSLのbashでSSH Agentを有効化する

**※間違ってもWindows側でSSHの設定をいじるな。権限が面倒なことになる。**

```sh
mkdir ~/.1password
mkdir ~/.ssh
vi ~/.ssh/config
```

```
Host *
  IdentityAgent ~/.1password/agent.sock
```

まずbashでこのリポジトリをクローンするため、bash用のセットアップをする。

```
touch ~/.agent-bridge.sh
chmod +x ~/.agent-bridge.sh
vi ~/.agent-bridge.sh
```

```sh
# https://gist.github.com/WillianTomaz/a972f544cc201d3fbc8cd1f6aeccef51#3-connect-wsl-with-1passwords-ssh-agent
export SSH_AUTH_SOCK=$HOME/.1password/agent.sock
ALREADY_RUNNING=$(ps -auxww | grep -q "[n]piperelay.exe -ei -s //./pipe/openssh-ssh-agent"; echo $?)
if [[ $ALREADY_RUNNING != "0" ]]; then
    if [[ -S $SSH_AUTH_SOCK ]]; then
        echo "removing previous socket..."
        rm $SSH_AUTH_SOCK
    fi
    echo "Starting SSH-Agent relay..."
    (setsid socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork EXEC:"npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",nofork &) >/dev/null 2>&1
fi

```

これはbash用なので、リポジトリに入ってるスクリプトと若干違う。

```sh
echo "source ~/.agent-bridge.sh" >> .bashrc
```

ひとまずクローンまでは上記のスクリプトに助けてもらう。

```sh
ln -s ~/.ssh /mnt/c/Users/temasaguru/.ssh
```

Win側にシンボリックリンク作成。

#### wslu

https://wslutiliti.es/wslu/install.html

Ubuntu の場合は PPA があるのでそっから入れる

`wslview`によって Win 側のブラウザを開けるので、CLI の認証などで便利

#### 必要なもの(WSL)

```sh
sudo apt -y install curl git ripgrep bat gnupg direnv
# 他ツールの使用に必要なもの
sudo apt -y install build-essential socat tk-dev liblzma-dev libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev ghostscript libxml2-dev libonig-dev libxslt-dev libzip-dev re2c libcurl4-openssl-dev libgd-dev libpq-dev
```

**ここではまだfishを入れてはいけない。**

socat は WSL の SSH エージェント用。

`tk-dev liblzma-dev libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev` はpython2系3系の両方をインストールする際に必要。

`libxml2-dev`, `libonig-dev`, `libxslt-dev`, `libzip-dev`, `re2c`, `libcurl4-openssl-dev` `libgd-dev`, `libpq-dev` はPHPビルドするとき用。

ghostscript は TeX 環境用。

```sh
sudo ln -s /usr/bin/batcat /usr/local/bin/bat
```

Ubuntuではコマンドの衝突が起こっているようで、batが`batcat`になってしまっている。シンボリックリンクを張って`bat` で呼べるようにする。

#### WSLの.gitconfigの設定

```
[user]
	name = Ryo Ando
	email = sasigume@gmail.com
	signingkey = 410B7848C1675824
[commit]
	gpgsign = true
[init]
	defaultBranch = main
[credential]
	helper = /mnt/c/Program\\ Files/Git/mingw64/bin/git-credential-manager-core.exe
```

このリポジトリに付属のスクリプトにより1Password SSH Agentが使えるようになる。

#### WSLのGit動作確認

一旦ターミナルを開きなおし、SSHエージェントの軌道を確認する。

```sh
ssh -T git@github.com
```

正常に設定されていれば、これで1Passwordのプロンプトが出るはず。

#### WSLにこのリポジトリをクローンする

ここからが面倒。

```sh
git clone --bare git@github.com:biyoai/dotfiles.git $HOME/.cfg
```

`.cfg` に bare repositoryとしてクローンする。

```sh
git --git-dir=$HOME/.cfg/ --work-tree=$HOME checkout
git --git-dir=$HOME/.cfg/ --work-tree=$HOME config status.showUntrackedFiles no 
```

チェックアウト。衝突がない場合、これで必要なファイルが揃う。

#### WSLのfishとneovimを入れる

このリポジトリとファイルがかぶる為、ここでやっとインストールする。

https://fishshell.com/

fishはここを参考に入れる。

neovimはUbuntu packages から落とすと古いため、下記の説明に従って PPA を使う

https://github.com/neovim/neovim/wiki/Installing-Neovim#ubuntu

...が、どうやら`unstable`を指定する必要がある。

### WSLのシェルの変更

```sh
chsh -s $(which fish)
```

#### Win:Ubuntuに追加で必要なものを入れていく

##### Win:fzf

https://github.com/junegunn/fzf#installation

##### Win:fisher

https://github.com/jorgebucaran/fisher

##### Win:Fish プラグイン

- [z](https://github.com/jethrokuan/z)
- [fzf](https://github.com/jethrokuan/fzf)

##### Win:Fish テーマ

```sh
fisher install oh-my-fish/theme-bobthefish
```

##### Win:lazygit

https://github.com/jesseduffield/lazygit

#### Win:バージョン切り替えが必要なもの

基本的にはasdfで各ランタイムのバージョンを管理する

https://asdf-vm.com/guide/getting-started.html

##### Win:Bun

```sh
asdf plugin add bun
```

Node.jsで行っていた作業を順次置き換えている。置き換えやすさが十分に考慮されておりありがたい。

##### Win:Go

```sh
asdf plugin add golang
```

##### Win:Node.js

```sh
asdf plugin add nodejs
```

後述のpnpm にも Node.js バージョン管理機能があるが、v8.2.0 現在発展途上のため、他ツールと同様 asdf を使え。

##### Win:pnpm

```sh
asdf plugin add pnpm
```

##### Win:PHP

```sh
asdf plugin add php
```

必要なパッケージがやたら多いので注意。あと各種モジュールについては割愛。どうせDocker使うし。バージョンによっては先述したパッケージで足りないかもしれない。

##### Win:Ruby

```sh
asdf plugin add ruby
```

RVMやrbenvも試したが面倒なのでasdfでいいやとなった。WSLではRubyMine 2023.2でうまくインタープリタとして指定できないので、Docker内のRubyを使う。

##### Win:Java

```sh
asdf plugin add java
```

前は `jabba` を使っていたがasdfで済むことに気づいた。

少なくともWindowsにおけるInteliJの設定では、shims/javaではなくJDKのディレクトリを選ぶ必要がある。

##### Win:Python

```sh
asdf plugin add python
```


##### Win:terraform

```sh
asdf plugin-add terraform https://github.com/asdf-community/asdf-hashicorp.git
```

Hashicorp関連のプラグインは皆同じリポジトリから追加する。

##### Win:flyctl

https://fly.io/docs/hands-on/install-flyctl

fly.io操作用

#### Win:WSLのTeX 環境構築

余裕があれば。

https://texwiki.texjp.org/?TeX%20Live%2FMac#texlive-install-official

```sh
wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
tar xvf install-tl-unx.tar.gz
cd install-tl-2*
sudo ./install-tl -no-gui -repository http://mirror.ctan.org/systems/texlive/tlnet/
sudo /usr/local/texlive/????/bin/*/tlmgr path add
sudo tlmgr install collection-langjapanese utf8add url cite latexmk
```

参考: https://blog.cles.jp/item/13135

---

Ubuntuをインポートした場合、ここまで飛ばしていい！

#### Win:Starship

https://github.com/starship/starship

starship前提で設定を書いているので入れる。

**PowerShellとWSLの両方にインストーする必要がある。**

### Win:1Password

**GPGの設定が終わってから**SSHエージェントを有効化する。

### Win:Docker Desktop for Windowsのインストール

```
winget install Docker.DockerDesktop
```

docker-desktop-dataはデカすぎるので、VHDのバックアップをするべきではない。

その代わり、Docker Desktopの「Volumes Backup & Export」プラグインで、仕事に関するボリュームをエクスポートして、NASにバックアップしておく。

---

## 環境復元(Mac)

まず[Homebrew](https://brew.sh)を入れる。

```sh
brew install curl git ripgrep bat gnupg direnv wget coreutils libyaml
```

### caskで済むMacアプリ

```
brew install --cask coteditor
brew install --cask iterm2
```

### 必須アイテムを入れていく

**ここではまだfishを入れてはいけない。このリポジトリとファイルが衝突する**

#### Macの場合:GPGを設定する

1Passwordから秘密鍵をダウンロードする。

```sh
brew install gpg pinentry-mac
mkdir ~/.gnupg
```

`~/.gnupg/gpg-agent.conf` を以下のように編集する。([参考](https://stackoverflow.com/a/63474095))

```
default-cache-ttl 2592000
max-cache-ttl 2592000
pinentry-program /opt/homebrew/bin/pinentry-mac
```

後述するgitの設定も合わせれば、コミット時にパスフレーズのプロンプトが出るようになる。その際は1Password のクイックアクセスを Cmd+Shift+Space で開けば GPG パスフレーズをすぐ探せる。

#### Macの場合:鍵のインポート

```sh
gpg --import <秘密鍵パス>
```

1Passwordにパスフレーズがあるので入力する。

```sh
gpg --edit-key 410B7848C1675824 trust quit
```

意図した鍵がインポートされているなら、究極に信頼するを選択。

ターミナルを開き直し、 `gpg --edit-key 410B7848C1675824` で信頼が `[究極]` になっているのを確認する。

もし署名できない場合、`change-usage` で `Sign Certify` 可能にして保存する必要がある。

### Macの場合:.gitconfigを設定する

```
[user]
	name = Ryo Ando
	email = sasigume@gmail.com
	signingkey = 410B7848C1675824
[commit]
	gpgsign = true
[init]
	defaultBranch = main
[gpg]
    program = /usr/local/bin/gpg
	# aarch64の場合は下記
	# program = /opt/homebrew/bin/gpg
```

GPGのパスに注意。

#### Macの場合:Git動作確認

**ここで1PasswordのSSHエージェントを有効化する。**

一旦ターミナルを開きなおし、SSHエージェントの起動を確認する。

```sh
ssh -T git@github.com
```

正常に設定されていれば、これで1Passwordのプロンプトが出るはず。

#### Macの場合:このリポジトリをクローンする

ここからが面倒。

```sh
git clone --bare git@github.com:biyoai/dotfiles.git $HOME/.cfg
```

`.cfg` に bare repositoryとしてクローンする。

```sh
git --git-dir=$HOME/.cfg/ --work-tree=$HOME checkout
git --git-dir=$HOME/.cfg/ --work-tree=$HOME config status.showUntrackedFiles no 
```

チェックアウト。衝突がない場合、これで必要なファイルが揃う。

#### Macの場合:fishとneovimを入れる

このリポジトリとファイルがかぶる為、ここでやっとインストールする。

```sh
brew install fish nvim
```

### Macの場合:シェルの変更

```sh
chsh -s $(which fish)
```

**iTerm2はこれだけじゃ変わらないので、設定のProfileで `Custom Shell` を選び、fishのパスを手動で入力する。**

#### Macの場合:Starship

https://github.com/starship/starship

starship前提で設定を書いているので入れる。

### Macの場合:追加で必要なものを入れていく

#### Docker Desktop for Mac

インストーラーをダウンロードする形になると思う。caskもあるかな。

#### Macの場合:fzf

https://github.com/junegunn/fzf#installation

#### Macの場合:fisher

https://github.com/jorgebucaran/fisher

#### Macの場合:Fish プラグイン

- [z](https://github.com/jethrokuan/z)
- [fzf](https://github.com/jethrokuan/fzf)

#### Macの場合:Fish テーマ

```sh
fisher install oh-my-fish/theme-bobthefish
```

#### Macの場合:lazygit

https://github.com/jesseduffield/lazygit

### Macの場合:バージョン切り替えが必要なものを入れていく

基本的にはasdfで各ランタイムのバージョンを管理する

https://asdf-vm.com/guide/getting-started.html

#### Macの場合:Bun

```sh
asdf plugin add bun
```

Node.jsで行っていた作業を順次置き換えている。置き換えやすさが十分に考慮されておりありがたい。

#### Macの場合:Go

```sh
asdf plugin add golang
```

#### Node.js

```sh
asdf plugin add nodejs
```

後述のpnpm にも Node.js バージョン管理機能があるが、v8.2.0 現在発展途上のため、他ツールと同様 asdf を使え。

#### pnpm

```sh
asdf plugin add pnpm
```

#### PHP

phpbrewには以下のパッケージが必要なので、先に入れる

```sh
sudo apt-get update
sudo apt-get install \
  build-essential \
  libbz2-dev \
  libreadline-dev \
  libsqlite3-dev \
  libcurl4-gnutls-dev \
  libzip-dev \
  libssl-dev \
  libxml2-dev \
  libxslt-dev \
  php8.1-cli \
  php8.1-bz2 \
  php8.1-xml \
  pkg-config
```

https://github.com/phpbrew/phpbrew

asdfにもPHPプラグインがあるが、うまくいかなかったためphpbrewにする

#### Ruby

```sh
asdf plugin add ruby
```

RVMやrbenvも試したが面倒なのでasdfでいいやとなった。

#### Java

```sh
asdf plugin add java
```

前は `jabba` を使っていたがasdfで済むことに気づいた。

#### Python

```sh
asdf plugin add python
```

Macならasdfに任せれば大丈夫。

#### terraform

```sh
asdf plugin-add terraform https://github.com/asdf-community/asdf-hashicorp.git
```

Hashicorp関連のプラグインは皆同じリポジトリから追加する。

#### flyctl

https://fly.io/docs/hands-on/install-flyctl

fly.io操作用

### Macの場合:TeX 環境構築

余裕があれば。

https://texwiki.texjp.org/?TeX%20Live%2FMac#texlive-install-brew
