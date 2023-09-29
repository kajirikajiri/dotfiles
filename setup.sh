#...

DOTPATH=~/.dotfiles
GITHUB_URL=http://github.com/kajirikajiri/dotfiles.git
UNAME=$(uname)
TARBALL="https://github.com/kajirikajiri/dotfiles/archive/main.tar.gz"
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

# 使えない場合は curl
elif has "curl"; then
	echo 'curl is present!!'
	curl -L "$TARBALL" | tar zxv

	# 解凍したら，DOTPATH に置く
	mv -f dotfiles-main "$DOTPATH"

# 使えない場合は wget
elif has "wget"; then
	echo 'wget is present!!'
	wget -O - "$TARBALL" | tar zxv

	# 解凍したら，DOTPATH に置く
	mv -f dotfiles-main "$DOTPATH"
else
	die "git or curl or wget required"
fi

cd "$DOTPATH"
if [ $? -ne 0 ]; then
	die "not found: $DOTPATH"
fi

# バックアップ用のディレクトリを作成する
if [ ! -d "$HOME/.dotbackup" ];then
	command echo "$HOME/.dotbackup not found. Auto Make it"
	command mkdir "$HOME/.dotbackup"
fi

# 移動できたらリンクを実行する
for f in .??*
do
	[ "`basename $f`" = ".git" ] && continue
	if [[ -L "$HOME/`basename $f`" ]];then
		rm -f "$HOME/`basename $f`"
	fi
	if [[ -e "$HOME/`basename $f`" ]];then
		mv "$HOME/`basename $f`" "$HOME/.dotbackup"
		echo "mv $HOME/`basename $f` $HOME/.dotbackup"
	fi

	ln -snfv "$DOTPATH/$f" "$HOME/$f"
done

echo "linked dotfiles complete!"

