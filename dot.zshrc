#!/bin/zsh

#
# ディレクトリ変更
#

# ディレクトリ名だけで cd できる
setopt auto_cd
# cd のあとに自動で ls
function chpwd() { ls -F --color=auto }

# cd コマンドだけでディレクトリスタックに pushd する
setopt auto_pushd

# ディレクトリスタックに重複するディレクトリを登録しない
setopt pushd_ignore_dups


#
# suffix rules
#
alias -s html=firefox
alias -s sparql="sparql --query"
alias -s rq="sparql --query"
alias -s go="run_go"
alias -s zip="unzip"
alias -s tar.gz="tar zxvf"
function run_go() {
    for arg in $argv; do
        goimports -w=true $arg

        case $arg in
            *_test.go)
                go test $arg ;;
            *.go)
                go run $arg ;;
            *)
                echo "argument '$arg' is not golang file"
        esac
    done
}

#
# global alias
#
alias -g L='| less -iMR'
alias -g H='| head'
alias -g T='| tail'
alias -g TF='| tail -f'
alias -g G='| grep'
alias -g GI='| grep -i'
alias -g P='| peco'
alias -g S='| sed'
alias -g A='| awk'
alias -g X='| xargs'
alias -g S='| sort'
alias -g W='| wc'
alias -g WL='| wc -l'

#
# 補完
#
autoload -Uz compinit
compinit

# コマンド名/引数のスペルミスを訂正する("setopt correct" はコマンド名のみ)
setopt correct_all

PROMPT="%~%% "
PROMPT2="%_% % "
SPROMPT="%r is correct? [nyae]..."





#
# ヒストリ機能の設定
#

HISTFILE=~/.zsh_history
HISTSIZE=5000000
SAVEHIST=$HISTSIZE

# history コマンド自体は履歴に記録しない
setopt hist_no_store

# 直前と同じコマンドは履歴に記録しない
setopt hist_ignore_dups

# 履歴に ":実行時間:経過時間:コマンド" を記録する
setopt extended_history

# コマンドの余分なスペースを正規化して重複を取り除く
setopt hist_reduce_blanks

# コマンドの先頭がスペースのとき履歴に記録しない (sudo とかに使う)
setopt hist_ignore_space

# 複数のzshでリアルタイムで履歴を相互参照する
setopt inc_append_history
setopt share_history



# no matches found が出ないようにする
# * ? [ ] を使うと，グロブ展開が行われるのでそれを止める
# （alias の定義で正規表現を使うと事故るので）
setopt nonomatch

# 新規ファイルを作成するコマンドでは訂正機能を無効化する
alias mv='nocorrect mv'
alias cp='nocorrect cp'
alias mkdir='nocorrect mkdir'
alias touch='nocorrect touch'

alias ls='ls -F --color=auto'
alias ll='ls -lh'
alias la='ls -lah'
alias rm='trash-put'
alias mozconf='/usr/lib/mozc/mozc_tool -mode=config_dialog'
alias mozdic='/usr/lib/mozc/mozc_tool --mode=dictionary_tool'
alias n='w3m http://google.co.jp'
alias e='emacsclient -n'
alias ee='emacsclient -nw'
alias g='my-git'
function my-git() {
    local oper="$argv[1]"
    case $oper in
        "co")
            git-checkout-with-peco
            ;;
        "a")
            git-add-with-peco
            ;;
        *)
            git $argv
    esac
}

function git-checkout-with-peco() {
    local branch_name=$(git branch -av | peco | sed -e 's/^..\([^ ]*\).*$/\1/g')
    git checkout $branch_name
    git branch
}

function git-add-with-peco() {
    git add -v $(git status -s | peco | sed -e 's/^...\(.*\)$/\1/g')
}

alias c='cd-with-peco'
function cd-with-peco() {
    local file="$(find . ! -wholename "*/.git{$|/*}" | peco)"

    if [ -d $file ]; then
        cd $file
    else
        cd $(dirname $file)
    fi
}



# tmux/screenの自動起動設定
#  Note: .bashrc or .zshrc に設定して使用して下さい。
#
#  ログイン時にtmux または screenが起動してない場合は自動的に起動
#  デタッチ済みセッションが存在すればアタッチし、なければ新規セッションを生成
#  tmuxを優先して起動し、tmuxが使えなければscreenを起動する
if [ -z "$TMUX" -a -z "$STY" ]; then
    if type tmuxx >/dev/null 2>&1; then
        tmuxx
    elif type tmux >/dev/null 2>&1; then
        if tmux has-session && tmux list-sessions | egrep -q '.*]$'; then
            # デタッチ済みセッションが存在する
            tmux attach && echo "tmux attached session "
        else
            tmux new-session && echo "tmux created new session"
        fi
    elif type screen >/dev/null 2>&1; then
        screen -rx || screen -D -RR
    fi
fi

[ -f ~/.zsh/plugin/incr*.zsh ] && source ~/.zsh/plugin/incr*.zsh

/usr/bin/xmodmap $HOME/.Xmodmap 2> /dev/null

function select-history-with-peco() {
    BUFFER="`history -n 1 | tac | peco --query "$BUFFER"`"
    CURSOR=$#BUFFER
    zle clear-screen
}
zle -N select-history-with-peco
bindkey '^r' select-history-with-peco
