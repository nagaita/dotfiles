# -*- mode:sh -*-

# ディレクトリ名だけで cd できる
setopt auto_cd

# cd のあとに自動で ls
function chpwd() { ls }

# cd コマンドだけでディレクトリスタックに pushd する
setopt auto_pushd

# ディレクトリスタックに重複するディレクトリを登録しない
setopt pushd_ignore_dups

# emacs風キーバインド
bindkey -e

# 日本語ファイル名を表示可能にする
setopt print_eight_bit

# ビープ音なし
setopt no_beep

# フローコントロールを無効にする
setopt no_flow_control

# C-dでzshを終了しない
setopt ignore_eof

# #以降をコメントにする
setopt interactive_comments

#
# suffix rules
#
alias -s html=firefox
alias -s sparql="sparql --query"
alias -s rq="sparql --query"
alias -s py="python"
alias -s go="run_go"
alias -s zip="unzip"
alias -s pdf="evince"
alias -s tar.gz="tar zxvf"
alias -s tex="latexmk -pdfdvi"
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
alias -s R=Rscript

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
alias -g C='$(git log --oneline --branches | peco | cut -d" " -f1)'
alias -g F='$(find . -maxdepth 1 -type f -not -path '"'"'*/\.*'"'"' | peco)'
alias -g FR='$(find . -type f -not -path '"'"'*/\.*'"'"' | peco)'
alias -g FA='$(find . -type f | peco)'
alias -g M='$(git ls-files -m | peco)'

#
# 補完
#
fpath=($HOME/.zsh/plugin/zsh-completions/src(N-/) $fpath)
autoload -Uz compinit
compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*:default' menu select=2
autoload -Uz colors
colors

#
# ディレクトリ移動
#
autoload -Uz add-zsh-hook
autoload -Uz chpwd_recent_dirs cdr
add-zsh-hook chpwd chpwd_recent_dirs

# コマンド名/引数のスペルミスを訂正する("setopt correct" はコマンド名のみ)
setopt correct_all
PROMPT="%~%% "
PROMPT2="%_% % "
SPROMPT="%r is correct? [nyae]..."



#
# ヒストリ機能の設定
#
HISTFILE=~/.zsh_history
HISTSIZE=1000000
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

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
case ${OSTYPE} in
    darwin*)
        alias ls='ls -FG'
        ;;
    linux*)
        alias ls='ls -F --color=auto'
        ;;
esac

alias ll='ls -lh'
alias la='ls -lah'
alias rm='trash-put'
alias mozconf='/usr/lib/mozc/mozc_tool -mode=config_dialog'
alias mozdic='/usr/lib/mozc/mozc_tool --mode=dictionary_tool'
alias v='vim'
alias l='less -iMR'
alias e='emacsclient -n'
alias ee='emacsclient -nw'
alias h='head'
alias t='tail'
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

function git-checkout-from-remote-with-peco() {
    remote_branch_name=$(git branch -r | peco | sed -e 's/^..\([^ ]*\).*$/\1/')
    local_branch_name=${remote_branch_name#origin/}

    if git branch | grep $local_branch_name > /dev/null ; then
        git checkout $local_branch_name
    else
        git checkout -b $local_branch_name $remote_branch_name
    fi

    git branch
}

function git-add-with-peco() {
    git add -v $(git status -s | peco | sed -e 's/^...\(.*\)$/\1/g')
}

alias c='cd-with-peco'
function cd-with-peco() {
    local base_dir=${1:-"."}
    local dest_path="$(find $base_dir ! -wholename "*/.git/*" | peco)"

    if [ -d $dest_path ]; then
        cd $dest_path
    else
        cd $(dirname $dest_path)
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

function select-history-with-peco() {
    BUFFER="`history -r -n 1 | peco --query "$BUFFER"`"
    CURSOR=$#BUFFER
    zle clear-screen
}
zle -N select-history-with-peco
bindkey '^r' select-history-with-peco

function fetch-path-with-peco() {
    BUFFER="$BUFFER $(find . | peco)"
}
zle -N fetch-path-with-peco
bindkey '^x^f' fetch-path-with-peco

function search-git-sha() {
    BUFFER="$BUFFER $(git log --oneline | peco | cut -d\  -f1)"
}
zle -N search-git-sha
bindkey '^x^g' search-git-sha

#
# cd-bookmark
#
#. $HOME/bin/dirbm.sh
#alias b='cd_with_bookmark'
#alias ba='add_bookmark'
#alias be='edit_bookmark'

alias sts='(cd ~/opt/spring-tool-suite-3.8.3.RELEASE-e4.6.2-linux-gtk-x86_64/sts-bundle/sts-3.8.3.RELEASE/ > /dev/null 2>&1; ./STS)'

#
# git
#    ref. https://git-scm.com/book/en/v2/Appendix-A%3A-Git-in-Other-Environments-Git-in-Zsh
#
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
RPROMPT=\$vcs_info_msg_0_
zstyle ':vcs_info:git:*' formats '[%b]'
