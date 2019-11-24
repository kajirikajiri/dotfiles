#...

DOTPATH=~/.dotfiles
GITHUB_URL=http://github.com/kajirikajiri/dotfiles.git
UNAME=$(uname)
# is_exists returns true if executable $1 exists in $PATH
is_exists() {
    type "$1" >/dev/null 2>&1
    return $?
}
# has is wrapper function
has() {
    is_exists "$@"
}
# die returns exit code error and echo error message
die() {
    e_error "$1" 1>&2
    exit "${2:-1}"
}

# git が使えるなら git
if has "git"; then
    echo 'git is present!'
    git clone --recursive "$GITHUB_URL" "$DOTPATH"

# 使えない場合は curl か wget を使用する
elif has "curl" || has "wget"; then
    echo 'git isnt present... , but curl or wget are present!!'
    tarball="https://github.com/kajirikajiri/dotfiles/archive/master.tar.gz"

    # どっちかでダウンロードして，tar に流す
    if has "curl"; then
        curl -L "$tarball"

    elif has "wget"; then
        wget -O - "$tarball"

    fi | tar zxv

    # 解凍したら，DOTPATH に置く
    mv -f dotfiles-master "$DOTPATH"

else
    die "curl or wget required"
fi

cd "$DOTPATH"
if [ $? -ne 0 ]; then
    die "not found: $DOTPATH"
fi

# 移動できたらリンクを実行する
for f in .??*
do
    [ "$f" = ".git" ] && continue

    ln -snfv "$DOTPATH/$f" "$HOME/$f"
done

if [[ "$OSTYPE" == "linux-gnu" ]]; then
    echo 'linux-gnu'
    # zshがなければinstallする
    if has "zsh"; then
        echo 'zsh is present!'
    # ない場合はinstallする
    elif has "apt"; then
        echo 'install zsh'
        sudo apt update
        sudo apt install -y zsh
        chsh -s /usr/bin/zsh || true # for skipping in CI
    fi

    # vimがなければinstallする
    if has "vim"; then
        echo 'vim is present!'
    # ない場合はinstallする
    elif has "apt"; then
        echo 'install vim'
        sudo apt update
        sudo apt install -y vim
    fi
    
    if has "tmux"; then
        echo 'tmux is present!'
    elif has "apt"; then
        echo 'install tmux'
        sudo apt update
        sudo apt install -y tmux
        sudo apt search locales
        sudo apt install locales-all
    fi

elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo 'darwin'
    brew install zsh vim ghq fzf tmux
fi

# vim-plugをインストールする
if has "curl"; then
    echo 'install vim-plug'
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi
    # zpluginをインストールする
if has "git"; then
    echo 'install zplugin'
    mkdir ~/.zplugin
    git clone https://github.com/zdharma/zplugin.git ~/.zplugin/bin
fi
