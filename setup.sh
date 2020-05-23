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

    brew install zsh vim ghq fzf tmux
    
#    # zshがなければinstallする
#    if has "zsh"; then
#        echo 'zsh is present!'
#    # ない場合はinstallする
#    elif has "apt"; then
#        echo 'install zsh'
#        sudo apt update
#        sudo apt install -y zsh
#        chsh -s /usr/bin/zsh || true # for skipping in CI
#    else
#        echo 'zsh, apt not found'
#    fi
#
#    # vimがなければinstallする
#    if has "vim"; then
#        echo 'vim is present!'
#    # ない場合はinstallする
#    elif has "apt"; then
#        echo 'install vim'
#        sudo apt update
#        sudo apt install -y vim
#    else
#        echo 'vim, apt not found'
#    fi
#    
#    # vim-plugをインストールする
#    if has "curl"; then
#        echo 'install vim-plug'
#        curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
#        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
#    else
#        echo 'curl not found'
#    fi
#    
#    # zpluginをインストールする
#    if has "git"; then
#        echo 'install zplugin'
#        mkdir ~/.zplugin
#        git clone https://github.com/zdharma/zplugin.git ~/.zplugin/bin
#    else
#        echo 'git not found'
#    fi
#    
#    # tmuxをインストールする
#    if has "tmux"; then
#        echo 'tmux is present!'
#    elif has "apt"; then
#        echo 'install tmux'
#        sudo apt update
#        sudo apt install -y tmux
#        sudo apt search locales
#        sudo apt install locales-all
#    else
#        echo 'tmux apt not found'
#    fi
#
#        
#    # golangがなければinstallする
#    if has "go"; then
#        echo 'go is present!'
#    # ない場合はinstallする
#    elif has "apt"; then
#        echo 'install go'
#        sudo apt update
#        sudo apt install -y golang
#        go get github.com/x-motemen/ghq
#    else
#        echo 'go, apt not found'
#    fi
#    
#    # fzfがなければinstallする
#    if has "fzf"; then
#        echo 'fzf is present!'
#    # ない場合はinstallする
#    elif has "git"; then
#        echo 'install fzf'
#        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
#        ~/.fzf/install
#    else
#        echo 'fzf, git not found'
#    fi
#    
#    # 言語ファイルをダウンロード
#    if has "apt"; then
#        sudo apt install locales-all
#    fi
    
elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo 'darwin'
    brew install zsh vim ghq fzf tmux
    
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

fi

    # zshがなければinstallする
    if has "zsh"; then
        echo 'zsh is present!'
    # ない場合はinstallする
    elif has "apt"; then
        echo 'install zsh'
        sudo apt update
        sudo apt install -y zsh
        chsh -s /usr/bin/zsh || true # for skipping in CI
    else
        echo 'zsh, apt not found'
    fi

    # vimがなければinstallする
    if has "vim"; then
        echo 'vim is present!'
    # ない場合はinstallする
    elif has "apt"; then
        echo 'install vim'
        sudo apt update
        sudo apt install -y vim
    else
        echo 'vim, apt not found'
    fi
    
    # vim-plugをインストールする
    if has "curl"; then
        echo 'install vim-plug'
        curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    else
        echo 'curl not found'
    fi
    
    # zpluginをインストールする
    if has "git"; then
        echo 'install zplugin'
        mkdir ~/.zplugin
        git clone https://github.com/zdharma/zplugin.git ~/.zplugin/bin
    else
        echo 'git not found'
    fi
    
    # tmuxをインストールする
    if has "tmux"; then
        echo 'tmux is present!'
    elif has "apt"; then
        echo 'install tmux'
        sudo apt update
        sudo apt install -y tmux
        sudo apt search locales
        sudo apt install locales-all
    else
        echo 'tmux apt not found'
    fi

        
    # golangがなければinstallする
    if has "go"; then
        echo 'go is present!'
    # ない場合はinstallする
    elif has "apt"; then
        echo 'install go'
        sudo apt update
        sudo apt install -y golang
        go get github.com/x-motemen/ghq
    else
        echo 'go, apt not found'
    fi
    
    # fzfがなければinstallする
    if has "fzf"; then
        echo 'fzf is present!'
    # ない場合はinstallする
    elif has "git"; then
        echo 'install fzf'
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
        ~/.fzf/install
    else
        echo 'fzf, git not found'
    fi
    
    # 言語ファイルをダウンロード
    if has "apt"; then
        sudo apt install locales-all
    fi
    
elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo 'darwin'
    brew install zsh vim ghq fzf tmux
    
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

fi

