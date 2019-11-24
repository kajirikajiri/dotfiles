#...

DOTPATH=~/.ghq/github.com/kajirikajiri/dotfiles
# is_exists returns true if executable $1 exists in $PATH
is_exists() {
    which "$1" >/dev/null 2>&1
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
