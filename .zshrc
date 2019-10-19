# mkdir && change directory
function mkdircd { mkdir -p "$@" && eval cd "\"\$$#\""; }
# git checkout feature/issue-
function gcof { git checkout feature/issue-"$@" }
# git checkout issue-
function gcoi { git checkout issue-"$@" }
# git checkout -b feature/issue-
function gcobf {
    echo "pullしましたか?ブランチは正しいですか?y/n[feature/issue]"
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
alias ga='git add'
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
alias glo='git log --oneline -20'
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
alias dp="$d ps"
alias dc="$dc"
alias dcn="$dcn"
alias dexec="$d exec -it"
alias dcrr="$dc run --rm"
alias dck="$dc kill"
alias dcs="$dc stop"
alias dcu="$dc up"
alias dcb="$dcb"
alias dcbn="$dcb --no-cache"
alias dcp="$dc ps"
alias dcr="$dc restart"
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
alias cviba='cd /Users/kazukinakamura/.ghq/github.com/kajirikajiri/soba-viba/'
alias cdaily='cd /Users/kazukinakamura/.ghq/github.com/kajirikajiri/daily_report/'
alias chistory='cd /Users/kazukinakamura/.ghq/github.com/kajirikajiri/zsh_history'
alias td="touch /Users/kazukinakamura/.ghq/github.com/kajirikajiri/daily_report/20$(date +%y%m%d).md && code /Users/kazukinakamura/.ghq/github.com/kajirikajiri/daily_report/20$(date +%y%m%d).md"
#alias soba='source ~/.zprofile'
alias dev="cd ~/dev"
alias croncreate="crontab ~/.ghq/github.com/kajirikajiri/cron_zsh/cron.edit && crontab -l"

# vscode
#alias c.='code --add .'
alias c.='code .'




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
export GOROOT=/usr/local/Cellar/go@1.11/1.11.6/libexec
export GOPATH=$HOME
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/tools:/platform-tools:$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools:$GOROOT/bin:$GOPATH/bin:$HOME/.nodebrew/current/bin:"/usr/local/opt/go@1.11/bin":/usr/local:$ANDROID_HOME/emulator
#rbenv
[[ -d ~/.rbenv  ]] && \
  export PATH=${HOME}/.rbenv/bin:${PATH} && \
  eval "$(rbenv init -)"
export PATH="$HOME/.cargo/bin:$PATH"

# use emacs move
bindkey -e
bindkey '^j' vi-cmd-mode

