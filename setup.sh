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
    
    # sudoがなければinstallする
    if has "sudo"; then
        echo 'sudo is present!'
    elif has "apt"; then
        echo 'install sudo'
        apt update
        apt install -y sudo
    fi

    sudo apt update && sudo apt upgrade
    sudo apt-get install build-essential curl file git
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
    test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
    test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
    
    brew install zsh vim ghq fzf tmux go zplug
    curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
    
    # vim-plugをインストールする
    if has "curl"; then
        echo 'install vim-plug'
        curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    else
        echo 'curl not found'
    fi

    # 言語ファイルをダウンロード
    if has "apt"; then
        sudo apt install locales-all
    else
        echo 'apt not found'
    fi
    
elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo 'darwin'
    brew install zsh vim ghq fzf tmux go zplug
    
    # vim-plugをインストールする
    if has "curl"; then
        echo 'install vim-plug'
        curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    fi

fi

