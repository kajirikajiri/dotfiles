# .zsh read http://fnwiya.hatenablog.com/entry/2015/11/03/191902
ZSHHOME="${HOME}/.zsh.d"

if [ -d $ZSHHOME -a -r $ZSHHOME -a \
     -x $ZSHHOME ]; then
    for i in $ZSHHOME/*; do
        [[ ${i##*/} = *.zsh ]] &&
            [ \( -f $i -o -h $i \) -a -r $i ] && . $i
    done
fi

# environment variable
# golang env
if [ -x "`which go`" ]; then
	export GOPATH=$HOME/go/1.14.1 # goenv need version number
	export PATH="$GOPATH/bin:$PATH"
fi
# goenv: go version manager
export GOENV_ROOT=$HOME/.goenv
export PATH=$GOENV_ROOT/bin:$PATH
eval "$(goenv init -)"

# rust
source ~/.cargo/env

# https://forums.docker.com/t/wsl-and-docker-for-windows-cannot-connect-to-the-docker-daemon-at-tcp-localhost-2375-is-the-docker-daemon-running/63571/12
#export DOCKER_HOST="tcp://localhost:2375"
#export PATH="$PATH:$HOME/.local/bin"

# https://qiita.com/miyagaw61/items/c299c452a105a6a9f50a
export DISPLAY=localhost:0.0


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export PATH="/root/ghq/github.com/riywo/anyenv/bin:$PATH"
eval "$(anyenv init -)"
export PATH="/root/.local/bin:/root/.anyenv/envs/nodenv/shims:/root/.anyenv/envs/nodenv/bin:/root/ghq/github.com/riywo/anyenv/bin:/root/.cargo/bin:/root/.goenv/shims:/root/.goenv/bin:/root/go/1.14.1/bin:/root/.cargo/bin:/usr/local/bin:/usr/local/sbin:/Users/kazukinakamura/.ebcli-virtual-env/executables:/root/.anyenv/envs/nodenv/shims:/root/.anyenv/envs/nodenv/bin:/root/ghq/github.com/riywo/anyenv/bin:/root/.cargo/bin:/root/.goenv/shims:/root/.goenv/bin:/root/go/1.14.1/bin:/root/.zinit/polaris/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/mnt/c/WINDOWS/system32:/mnt/c/WINDOWS:/mnt/c/WINDOWS/System32/Wbem:/mnt/c/WINDOWS/System32/WindowsPowerShell/v1.0/:/mnt/c/WINDOWS/System32/OpenSSH/:/mnt/c/Program Files/nodejs/:/mnt/c/Program Files/Docker/Docker/resources/bin:/mnt/c/ProgramData/DockerDesktop/version-bin:/mnt/c/Users/kajir/scoop/apps/yarn/current/Yarn/bin:/mnt/c/Users/kajir/scoop/apps/yarn/current/global/node_modules/.bin:/mnt/c/Users/kajir/scoop/shims:/mnt/c/Users/kajir/AppData/Local/Programs/Python/Python38/Scripts/:/mnt/c/Users/kajir/AppData/Local/Programs/Python/Python38/:/mnt/c/Users/kajir/AppData/Local/Microsoft/WindowsApps:/mnt/c/Vim/vim82:/mnt/c/Users/kajir/AppData/Local/Programs/Microsoft VS Code/bin:/mnt/c/Users/kajir/AppData/Roaming/npm:/root/.fzf/bin"
