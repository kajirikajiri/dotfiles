# .zsh read http://fnwiya.hatenablog.com/entry/2015/11/03/191902
ZSHHOME="${HOME}/.zsh.d"

if [ -d $ZSHHOME -a -r $ZSHHOME -a \
     -x $ZSHHOME ]; then
    for i in $ZSHHOME/*; do
        [[ ${i##*/} = *.zsh ]] &&
            [ \( -f $i -o -h $i \) -a -r $i ] && . $i
    done
fi

autoload -U compinit
compinit
setopt share_history
setopt auto_cd
export LANG=ja_JP.UTF-8

bindkey '^[' vi-cmd-mode

source ~/.zplug/init.zsh
zplug 'zsh-users/zsh-completions'
zplug 'zsh-users/zaw'
zplug 'zsh-users/zsh-syntax-highlighting', defer:2
zplug check || zplug install

autoload -Uz chpwd_recent_dirs cdr add-zsh-hook is-at-least
if is-at-least 4.3.10; then
  add-zsh-hook chpwd chpwd_recent_dirs
  zstyle ':chpwd:*' recent-dirs-max 5000
  zstyle ':chpwd:*' recent-dirs-default yes
fi

zplug load

autoload -Uz add-zsh-hook
autoload -U colors && colors

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn hg
zstyle ':vcs_info:*' formats '(%s)[%b] '
zstyle ':vcs_info:*' actionformats '(%s)[%b|%a] '
zstyle ':vcs_info:svn:*' branchformat '%b:r%r'

precmd () {
  psvar=()
  LANG=en_US.UTF-8 vcs_info
  [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"

  [[ -t 1 ]] || return
  [ $EMACS ] && return
  case $TERM in
    *xterm*|rxvt|(dt|k|E)term)
      print -Pn "\e]2;localhost\a"
      ;;
  esac
}
if is-at-least 4.3.10; then
  zstyle ':vcs_info:git:*' check-for-changes true
  zstyle ':vcs_info:git:*' stagedstr "+"
  zstyle ':vcs_info:git:*' unstagedstr "-"
  zstyle ':vcs_info:git:*' formats '(%s)[%b]%c%u'
  zstyle ':vcs_info:git:*' actionformats '(%s)[%b|%a]%c%u'
fi
function _update_vcs_info_msg() {
  psvar=()
  LANG=en_US.UTF-8 vcs_info
  [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}
add-zsh-hook precmd _update_vcs_info_msg
zstyle ':vcs_info:bzr:*' use-simple true

function toon {
  echo -n ""
}

if [ $EMACS ]; then
  export TERM=xterm-256color
  PROMPT="%F{green}%~%f %{$fg[red]%}>%{$reset_color%} "
else
  PROMPT="%F{green}%~%f %{$fg[white]%}$(toon)%{$reset_color%} "
fi
PROMPT2="%_%% "
SPROMPT="%r is correct? [n,y,a,e]: "
RPROMPT="%1(v|%F{yellow}%1v%f|)%F{red}%T%f"

HISTFILE=~/.zhistory
HISTSIZE=10000
SAVEHIST=10000

autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

autoload -U compinit; compinit -C

zstyle ':completion:*' format '%B%F{blue}%d%f%b'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:default' menu select=2
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

zstyle ':completion:*' keep-prefix
zstyle ':completion:*' recent-dirs-insert both

zstyle ':completion:*' completer _complete _ignored

zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle ':completion:*' verbose no

zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin

setopt no_beep  # 補完候補がないときなどにビープ音を鳴らさない。
setopt no_nomatch # git show HEAD^とかrake foo[bar]とか使いたい
setopt prompt_subst  # PROMPT内で変数展開・コマンド置換・算術演算を実行
setopt transient_rprompt  # コマンド実行後は右プロンプトを消す
setopt hist_ignore_dups   # 直前と同じコマンドラインはヒストリに追加しない
setopt hist_ignore_all_dups  # 重複したヒストリは追加しない
setopt hist_reduce_blanks
setopt hist_no_store
setopt hist_verify
setopt share_history  # シェルのプロセスごとに履歴を共有
setopt extended_history  # 履歴ファイルに時刻を記録
setopt append_history  # 複数の zsh を同時に使う時など history ファイルに上書きせず追加
setopt auto_cd  # ディレクトリ名だけで移動
setopt auto_pushd  # cd したら pushd
setopt auto_list  # 補完候補が複数ある時に、一覧表示
setopt auto_menu  # 補完候補が複数あるときに自動的に一覧表示する
setopt list_packed
setopt list_types
setopt no_flow_control
setopt print_eight_bit
setopt pushd_ignore_dups
setopt rec_exact
setopt autoremoveslash
unsetopt list_beep
setopt complete_in_word  # カーソル位置で補完する。
setopt glob
setopt glob_complete  # globを展開しないで候補の一覧から補完する。
setopt extended_glob  # 拡張globを有効にする。
setopt mark_dirs   # globでパスを生成したときに、パスがディレクトリだったら最後に「/」をつける。
setopt numeric_glob_sort  # 辞書順ではなく数字順に並べる。
setopt magic_equal_subst  # コマンドライン引数の --prefix=/usr とか=以降でも補完
setopt always_last_prompt  # 無駄なスクロールを避ける

REPORTTIME=3


#
# use vim commandline
bindkey '^[' vi-cmd-mode

# https://qiita.com/miyagaw61/items/c299c452a105a6a9f50a
export DISPLAY=localhost:0.0

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# export PATH="/root/ghq/github.com/riywo/anyenv/bin:$PATH"
#eval "$(anyenv init -)"
# environment variable
export PATH="$PATH:/root/.local/bin:/root/.anyenv/envs/nodenv/shims:/root/.anyenv/envs/nodenv/bin:/root/.cargo/bin:/root/.cargo/bin:/usr/local/bin:/usr/local/sbin:/Users/kazukinakamura/.ebcli-virtual-env/executables:/root/.cargo/bin:/root/.goenv/shims:/root/.goenv/bin:/root/go/1.14.1/bin:/root/.zinit/polaris/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/mnt/c/WINDOWS/system32:/mnt/c/WINDOWS:/mnt/c/WINDOWS/System32/Wbem:/mnt/c/WINDOWS/System32/WindowsPowerShell/v1.0/:/mnt/c/WINDOWS/System32/OpenSSH/:/mnt/c/Program Files/nodejs/:/mnt/c/Program Files/Docker/Docker/resources/bin:/mnt/c/ProgramData/DockerDesktop/version-bin:/mnt/c/Users/kajir/scoop/apps/yarn/current/Yarn/bin:/mnt/c/Users/kajir/scoop/apps/yarn/current/global/node_modules/.bin:/mnt/c/Users/kajir/scoop/shims:/mnt/c/Users/kajir/AppData/Local/Programs/Python/Python38/Scripts/:/mnt/c/Users/kajir/AppData/Local/Programs/Python/Python38/:/mnt/c/Users/kajir/AppData/Local/Microsoft/WindowsApps:/mnt/c/Vim/vim82:/mnt/c/Users/kajir/AppData/Local/Programs/Microsoft VS Code/bin:/mnt/c/Users/kajir/AppData/Roaming/npm:/root/.fzf/bin"
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
