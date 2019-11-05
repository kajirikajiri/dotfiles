# mkdir && change directory
function mkdircd { mkdir -p "$@" && eval cd "\"\$$#\""; }
# git checkout feature/issue-
function gcof { git checkout feature/issue-"$@" }
# git checkout issue-
function gcoi { git checkout issue-"$@" }
# git checkout -b feature/issue-
function gcobf {
    echo "$(currentBranch) -> feature/issue-$@\ny/n"
    if read -q; then
        echo "\n"
        git checkout -b feature/issue-"$@";
    fi
}
# git checkout -b issue-
function gcobi () {
    echo "$(currentBranch) -> issue-$@\ny/n"
    if read -q; then
        echo "\n"
        git checkout -b issue-"$@";
    fi
}
# git quick push
function gq {
    git add .
    git commit -m "Quick update"
    git push
}
# git quick push add message
function gqm {
  git add . &&
  git commit -m "$@" &&
  git push
}
# git current branch
function currentBranch {
  git branch | grep \* | cut -d ' ' -f2
}
# git push first
function gpuf {
    currentBranch=$(currentBranch)
    git push --set-upstream origin $currentBranch
}
# git quick push viba
function gqv {
    currentDirectory=$(pwd)
    cviba
    gq
    cd $currentDirectory
}

# git quick push daily
function gqd {
    currentDirectory=$(pwd)
    cdaily
    gq
    cd $currentDirectory
}

# git quick push zsh_history
function gqh {
    currentDirectory=$(pwd)
    chistory
    gq
    cd $currentDirectory
}

# image open suffix
if [ `uname` = "Darwin" ]; then
  alias eog='open -a Preview'
fi
alias -s {png,jpg,bmp,PNG,JPG,BMP}=eog

function preexec {
  _prev_cmd_start_time=$SECONDS
  _cmd_is_running=true
}
function precmd {
  #send_slack
  if $_cmd_is_running ; then
    _prev_cmd_exec_time=$((SECONDS - _prev_cmd_start_time))
    if ((_prev_cmd_exec_time > 5)); then
      h=$(history -1)
      terminal-notifier -message "$h" -activate com.googlecode.iterm2
    fi
  fi
  _cmd_is_running=false
}
# git checkout master
function gcom {
  git checkout master &&
  git pull
}
# git checkout .
function gco. {
  git checkout .
}
# git branch get all
function gbag {
  for remote in `git branch -r`; do git branch --track ${remote#origin/} $remote; done
  git fetch --all
  git pull --all
}

# keybind check fzf
alias f='bindkey|grep fzf'

# open vscode for current directory
function open_vscode () {
  BUFFER="c."
  zle accept-line
  zle reset-prompt
}

zle -N open_vscode
bindkey '^V' open_vscode

# tree fzf
function tree-fzf() {
  local SELECTED_FILE=$(tree --charset=o -f | fzf --query "$LBUFFER" | tr -d '\||`|-' | xargs echo)

  if [ "$SELECTED_FILE" != "" ]; then
    BUFFER="$EDITOR $SELECTED_FILE"
    zle accept-line
  fi

  zle reset-prompt
}

zle -N tree-fzf
bindkey "^T" tree-fzf

# ghq fzf
function ghq-fzf() {
  local selected_dir=$(ghq list | fzf --query="$LBUFFER")

  if [ -n "$selected_dir" ]; then
    BUFFER="cd $(ghq root)/${selected_dir}"
    zle accept-line
  fi

  zle reset-prompt
}

zle -N ghq-fzf
bindkey "^G" ghq-fzf

# gh-open current dir fzf
function gh-open-cd-fzf() {
    BUFFER="gh-open $(pwd)"
    zle accept-line
  zle reset-prompt
}

zle -N gh-open-cd-fzf
bindkey "^O" gh-open-cd-fzf

# ignore duplicate history
setopt hist_ignore_dups
# history fzf
function history-fzf() {
  local tac

  if which tac > /dev/null; then
    tac="tac"
  else
    tac="tail -r"
  fi

  BUFFER=$(history -n 1 | eval $tac | fzf --query "$LBUFFER")
  CURSOR=$#BUFFER

  zle reset-prompt
}

zle -N history-fzf
bindkey '^R' history-fzf

# open multiple vscode
function vm {
  cd /Users/kazukinakamura/.ghq/github.com/OnetapInc/locked-frontend && code . &&
  cd /Users/kazukinakamura/.ghq/github.com/OnetapInc/locked-api && code . &&
  cd /Users/kazukinakamura/.ghq/github.com/OnetapInc/team-docs && code . &&
  cd /Users/kazukinakamura/.ghq/github.com/OnetapInc/locked_cdn && code . &&
  cd /Users/kazukinakamura/.ghq/github.com/OnetapInc/locked-rails-web-sample && code . &&
  cd /Users/kazukinakamura/.ghq/github.com/kajirikajiri/daily_report && code .
}

# clipboard vim

# default
alias l='ls -al'
alias pag='ps aux | grep'

# ghq get
alias gg='ghq get'

# testcafe
alias t='testcafe chrome'

# git alias
alias g='git'
alias gs='git status'
alias gst='git status -sb'
# alias ga='git add'
alias ga.='git add .'
alias gau='git add -u' # Removes deleted files
alias gap='git add -p'
alias gp='git pull'
alias gpu='git push'
alias gc='git commit -v'
alias gca='git commit -v -a' # Does both add and commit in same command, add -m 'blah' for comment
alias gcm='git commit -m'
alias gco='git checkout'
alias gcofull="git checkout other/full-renewal"
alias gcosmall="git checkout other/small-renewal"
alias gcob='git checkout -b'
alias gl='git log'
# alias glo='git log --oneline -20'
alias gla='git log --pretty="format:%C(yellow)%h %C(green)%cd %C(reset)%s %C(red)%d %C(cyan)[%an]" --date=iso --all --graph'
alias glp='git log -p'
alias gb='git branch'
alias gba='git branch -a'
alias gbn='git branch --contains=HEAD'
alias gd='git diff'
alias gsb='git show-branch'
alias gsba='git show-branch -a'
alias gcp='git cherry-pick'
alias gsm='git stash save'
alias gsp='git stash pop'
alias gsl='git stash list'
alias gsd='git stash drop'

# go alias
alias goi='go install'

# docker alias
d='docker'
dc="$d-compose"
dcn="$d container"
dcb="$dc build"
alias d="$d"
alias da="$d attach"
alias dp="$d ps"
alias dc="$dc"
alias dcn="$dcn"
alias dexec="$d exec -it"
alias dcrr="$dc run --rm"
alias dcd="$dc down"
alias dck="$dc kill"
alias dcs="$dc stop"
alias dcu="$dc up"
alias dcb="$dcb"
alias dcbn="$dcb --no-cache"
alias dcp="$dc ps"
alias dcr="$dc restart"
alias dcrm="$dc rm"
alias dcimage='docker run --rm -it --name dcv -v $(pwd):/input pmsipilot/docker-compose-viz render -m image docker-compose.yml'

# react-native
alias rnra='react-native run-android'
alias rnri='react-native run-ios'

# heroku
alias gsprails='git subtree push --prefix rails heroku master'

# npm
alias npmi='npm install'

# other
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
#alias viba='vi /Users/kazukinakamura/.ghq/github.com/kajirikajiri/soba-viba/.zshrc'
alias vika='vi ~/.config/karabiner/karabiner.json && cp ~/.config/karabiner/karabiner.json ~/.ghq/github.com/kajirikajiri/karabiner_backup'
alias vizs='vi ~/.zshrc'
alias cviba='cd /Users/kazukinakamura/.ghq/github.com/kajirikajiri/soba-viba/'
alias cdaily='cd /Users/kazukinakamura/.ghq/github.com/kajirikajiri/daily_report/'
alias chistory='cd /Users/kazukinakamura/.ghq/github.com/kajirikajiri/zsh_history'
alias td="touch /Users/kazukinakamura/.ghq/github.com/kajirikajiri/daily_report/20$(date +%y%m%d).md && code /Users/kazukinakamura/.ghq/github.com/kajirikajiri/daily_report/20$(date +%y%m%d).md"
#alias soba='source ~/.zprofile'
alias dev="cd ~/dev"
alias croncreate="crontab ~/.ghq/github.com/kajirikajiri/cron_zsh/cron.edit && crontab -l"

# alias trans
alias te='trans en:ja'
alias tj='trans ja:en'
# vscode
#alias c.='code --add .'
alias c.='code .'

# vim indent fix
function vip {
  echo -e "G=gg\n:wq\n" | vim $@
}

##### zsh default & work
#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
####if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
####  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
####fi

# Customize to your needs...

### Added by Zplugin's installer
####source '/Users/kazukinakamura/.zplugin/bin/zplugin.zsh'
####autoload -Uz _zplugin
####(( ${+_comps} )) && _comps[zplugin]=_zplugin
### End of Zplugin's installer chunk
source $HOME/.zplugin/bin/zplugin.zsh
#source /Users/kazukinakamura/.ghq/github.com/kajirikajiri/soba-viba/.zshrc
autoload -Uz _zplugin
(( ${+_comps} )) && _comps[zplugin]=_zplugin

zplugin load momo-lab/zsh-abbrev-alias # 略語を展開する
zplugin ice wait'!0'; zplugin light zsh-users/zsh-autosuggestions
zplugin ice wait'!0'; zplugin light zdharma/fast-syntax-highlighting
zplugin ice wait'!0'; zplugin load zsh-users/zsh-syntax-highlighting # 実行可能なコマンドに色付け
zplugin ice wait'!0'; zplugin load zsh-users/zsh-completions # 補完
zplugin ice pick"async.zsh" src"pure.zsh"; zplugin light sindresorhus/pure

autoload -U compinit
compinit
setopt share_history
setopt auto_cd
export LANG=ja_JP.UTF-8
HISTSIZE=1000000
SAVEHIST=1000000
HISTTIMEFORMAT='[%Y/%m/%d %H:%M:%S] '
HISTFILE=~/.zhistory
#alias soba='source /Users/kazukinakamura/.ghq/github.com/kajirikajiri/soba-viba/.zshrc'

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# onetap alias
alias and-debug='adb shell input keyevent 82'
alias capp='cd ~/onetapinc/cointraderapp'
alias cserver='cd ~/src/github.com/OnetapInc/cointrader/server'
alias ctrade='cd ~/src/github.com/OnetapInc/cointrader/trade'
alias cbacktest='cd ~/src/github.com/OnetapInc/cointrader/trade/backtest'
alias cclient='cd ~/src/github.com/OnetapInc/cointrader/client'
alias cccxt='cd ~/src/github.com/OnetapInc/cointrader/ccxt'
alias cadmin='cd ~/src/github.com/OnetapInc/cointrader/admin'
alias ctrader='cd ~/src/github.com/OnetapInc/cointrader'
alias ceventlog='cd ~/src/github.com/OnetapInc/cointrader/eventlog'
alias clean-xcode='rm -rf /Library/Developer/Xcode/DerivedData'
alias fuck-rails="pkill -9 -f 'rb-fsevent|rails|spring|puma'"
alias lockedprod="sudo ssh -i ~/Downloads/demo.pem ec2-user@52.69.93.180"
alias locked='cd /Users/kazukinakamura/Desktop/workdir/work/v001_locked/locked'
alias lockeddeploy="sudo ssh -i ~/Downloads/demo.pem ec2-user@52.69.93.180"
alias cdndev='npm run build:dev && npm run build-push'


## path
export ANDROID_HOME=$HOME/Library/Android/sdk
export GOROOT=/usr/local/opt/go/libexec
export GOPATH=$HOME/go
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/tools:/platform-tools:$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools:$GOROOT/bin:$GOPATH/bin:$HOME/.nodebrew/current/bin:"/usr/local/opt/go@1.11/bin":/usr/local:$ANDROID_HOME/emulator
#rbenv
[[ -d ~/.rbenv  ]] && \
  export PATH=${HOME}/.rbenv/bin:${PATH} && \
  eval "$(rbenv init -)"
export PATH="$HOME/.cargo/bin:$PATH"

# use emacs move
#bindkey -e

# use vim commandline
bindkey '^[' vi-cmd-mode

######
#forgit
######

# MIT (c) Wenxuan Zhang

forgit::warn() { printf "%b[Warn]%b %s\n" '\e[0;33m' '\e[0m' "$@" >&2; }
forgit::info() { printf "%b[Info]%b %s\n" '\e[0;32m' '\e[0m' "$@" >&2; }
forgit::inside_work_tree() { git rev-parse --is-inside-work-tree >/dev/null; }

# https://github.com/so-fancy/diff-so-fancy
hash diff-so-fancy &>/dev/null && forgit_fancy='|diff-so-fancy'
# https://github.com/wfxr/emoji-cli
hash emojify &>/dev/null && forgit_emojify='|emojify'

# git commit viewer
forgit::log() {
    forgit::inside_work_tree || return 1
    local cmd opts
    cmd="echo {} |grep -Eo '[a-f0-9]+' |head -1 |xargs -I% git show --color=always % $* $forgit_fancy"
    opts="
        $FORGIT_FZF_DEFAULT_OPTS
        +s +m --tiebreak=index --preview=\"$cmd\"
        --bind=\"enter:execute($cmd |LESS='-R' less)\"
        --bind=\"ctrl-y:execute-silent(echo {} |grep -Eo '[a-f0-9]+' | head -1 | tr -d '\n' |${FORGIT_COPY_CMD:-pbcopy})\"
        $FORGIT_LOG_FZF_OPTS
    "
    eval "git log --graph --color=always --format='%C(auto)%h%d %s %C(black)%C(bold)%cr' $* $forgit_emojify" |
        FZF_DEFAULT_OPTS="$opts" fzf
}

# git diff viewer
forgit::diff() {
    forgit::inside_work_tree || return 1
    local cmd files opts commit
    [[ $# -ne 0 ]] && {
        if git rev-parse "$1" -- &>/dev/null ; then
            commit="$1" && files=("${@:2}")
        else
            files=("$@")
        fi
    }

    cmd="git diff --color=always $commit -- {} $forgit_fancy"
    opts="
        $FORGIT_FZF_DEFAULT_OPTS
        +m -0 --preview=\"$cmd\" --bind=\"enter:execute($cmd |LESS='-R' less)\"
        $FORGIT_DIFF_FZF_OPTS
    "
    cmd="echo" && hash realpath &>/dev/null && cmd="realpath --relative-to=."
    eval "git diff --name-only $commit -- ${files[*]}| xargs -I% $cmd '$(git rev-parse --show-toplevel)/%'"|
        FZF_DEFAULT_OPTS="$opts" fzf
}

# git add selector
forgit::add() {
    forgit::inside_work_tree || return 1
    local changed unmerged untracked files opts
    changed=$(git config --get-color color.status.changed red)
    unmerged=$(git config --get-color color.status.unmerged red)
    untracked=$(git config --get-color color.status.untracked red)

    opts="
        $FORGIT_FZF_DEFAULT_OPTS
        -0 -m --nth 2..,..
        --preview=\"git diff --color=always -- {-1} $forgit_fancy\"
        $FORGIT_ADD_FZF_OPTS
    "
    files=$(git -c color.status=always -c status.relativePaths=true status --short |
        grep -F -e "$changed" -e "$unmerged" -e "$untracked" |
        awk '{printf "[%10s]  ", $1; $1=""; print $0}' |
        FZF_DEFAULT_OPTS="$opts" fzf | cut -d] -f2 |
        sed 's/.* -> //') # for rename case
    [[ -n "$files" ]] && echo "$files" |xargs -I{} git add {} && git status --short && return
    echo 'Nothing to add.'
}

# git reset HEAD (unstage) selector
forgit::reset::head() {
    forgit::inside_work_tree || return 1
    local cmd files opts
    cmd="git diff --cached --color=always -- {} $forgit_fancy"
    opts="
        $FORGIT_FZF_DEFAULT_OPTS
        -m -0 --preview=\"$cmd\"
        $FORGIT_RESET_HEAD_FZF_OPTS
    "
    files="$(git diff --cached --name-only --relative | FZF_DEFAULT_OPTS="$opts" fzf)"
    [[ -n "$files" ]] && echo "$files" |xargs -I{} git reset -q HEAD {} && git status --short && return
    echo 'Nothing to unstage.'
}

# git checkout-restore selector
forgit::restore() {
    forgit::inside_work_tree || return 1
    local cmd files opts
    cmd="git diff --color=always -- {} $forgit_fancy"
    opts="
        $FORGIT_FZF_DEFAULT_OPTS
        -m -0 --preview=\"$cmd\"
        $FORGIT_CHECKOUT_FZF_OPTS
    "
    files="$(git ls-files --modified "$(git rev-parse --show-toplevel)"| FZF_DEFAULT_OPTS="$opts" fzf)"
    [[ -n "$files" ]] && echo "$files" |xargs -I{} git checkout {} && git status --short && return
    echo 'Nothing to restore.'
}

# git stash viewer
forgit::stash::show() {
    forgit::inside_work_tree || return 1
    local cmd opts
    cmd="git stash show \$(echo {}| cut -d: -f1) --color=always --ext-diff $forgit_fancy"
    opts="
        $FORGIT_FZF_DEFAULT_OPTS
        +s +m -0 --tiebreak=index --preview=\"$cmd\" --bind=\"enter:execute($cmd |LESS='-R' less)\"
        $FORGIT_STASH_FZF_OPTS
    "
    git stash list | FZF_DEFAULT_OPTS="$opts" fzf
}

# git clean selector
forgit::clean() {
    forgit::inside_work_tree || return 1
    local files opts
    opts="
        $FORGIT_FZF_DEFAULT_OPTS
        -m -0
        $FORGIT_CLEAN_FZF_OPTS
    "
    # Note: Postfix '/' in directory path should be removed. Otherwise the directory itself will not be removed.
    files=$(git clean -xdfn "$@"| awk '{print $3}'| FZF_DEFAULT_OPTS="$opts" fzf |sed 's#/$##')
    [[ -n "$files" ]] && echo "$files" |xargs -I% git clean -xdf % && return
    echo 'Nothing to clean.'
}

# git ignore generator
export FORGIT_GI_REPO_REMOTE=${FORGIT_GI_REPO_REMOTE:-https://github.com/dvcs/gitignore}
export FORGIT_GI_REPO_LOCAL=${FORGIT_GI_REPO_LOCAL:-~/.forgit/gi/repos/dvcs/gitignore}
export FORGIT_GI_TEMPLATES=${FORGIT_GI_TEMPLATES:-$FORGIT_GI_REPO_LOCAL/templates}

forgit::ignore() {
    [ -d "$FORGIT_GI_REPO_LOCAL" ] || forgit::ignore::update
    local IFS cmd args cat opts
    # https://github.com/sharkdp/bat.git
    hash bat &>/dev/null && cat='bat -l gitignore --color=always' || cat="cat"
    cmd="$cat $FORGIT_GI_TEMPLATES/{2}{,.gitignore} 2>/dev/null"
    opts="
        $FORGIT_FZF_DEFAULT_OPTS
        -m --preview=\"$cmd\" --preview-window='right:70%'
        $FORGIT_IGNORE_FZF_OPTS
    "
    # shellcheck disable=SC2206,2207
    IFS=$'\n' args=($@) && [[ $# -eq 0 ]] && args=($(forgit::ignore::list | nl -nrn -w4 -s'  ' |
        FZF_DEFAULT_OPTS="$opts" fzf  |awk '{print $2}'))
    [ ${#args[@]} -eq 0 ] && return 1
    # shellcheck disable=SC2068
    if hash bat &>/dev/null; then
        forgit::ignore::get ${args[@]} | bat -l gitignore
    else
        forgit::ignore::get ${args[@]}
    fi
}
forgit::ignore::update() {
    if [[ -d "$FORGIT_GI_REPO_LOCAL" ]]; then
        forgit::info 'Updating gitignore repo...'
        (cd "$FORGIT_GI_REPO_LOCAL" && git pull --no-rebase --ff) || return 1
    else
        forgit::info 'Initializing gitignore repo...'
        git clone --depth=1 "$FORGIT_GI_REPO_REMOTE" "$FORGIT_GI_REPO_LOCAL"
    fi
}
forgit::ignore::get() {
    local item filename header
    for item in "$@"; do
        if filename=$(find -L "$FORGIT_GI_TEMPLATES" -type f \( -iname "${item}.gitignore" -o -iname "${item}" \) -print -quit); then
            [[ -z "$filename" ]] && forgit::warn "No gitignore template found for '$item'." && continue
            header="${filename##*/}" && header="${header%.gitignore}"
            echo "### $header" && cat "$filename" && echo
        fi
    done
}
forgit::ignore::list() {
    find "$FORGIT_GI_TEMPLATES" -print |sed -e 's#.gitignore$##' -e 's#.*/##' | sort -fu
}
forgit::ignore::clean() {
    setopt localoptions rmstarsilent
    [[ -d "$FORGIT_GI_REPO_LOCAL" ]] && rm -rf "$FORGIT_GI_REPO_LOCAL"
}

FORGIT_FZF_DEFAULT_OPTS="
$FZF_DEFAULT_OPTS
--ansi
--height='90%'
--reverse
--bind='alt-k:preview-up,alt-p:preview-up'
--bind='alt-j:preview-down,alt-n:preview-down'
--bind='ctrl-r:toggle-all'
--bind='ctrl-s:toggle-sort'
--bind='?:toggle-preview'
--bind='alt-w:toggle-preview-wrap'
--preview-window='right:60%'
$FORGIT_FZF_DEFAULT_OPTS
"

# register aliases
# shellcheck disable=SC2139
if [[ -z "$FORGIT_NO_ALIASES" ]]; then
    alias "${forgit_add:-ga}"='forgit::add'
    alias "${forgit_reset_head:-grh}"='forgit::reset::head'
    alias "${forgit_log:-glo}"='forgit::log'
    alias "${forgit_diff:-gd}"='forgit::diff'
    alias "${forgit_ignore:-gi}"='forgit::ignore'
    alias "${forgit_restore:-gcf}"='forgit::restore'
    alias "${forgit_clean:-gclean}"='forgit::clean'
    alias "${forgit_stash_show:-gss}"='forgit::stash::show'
fi
