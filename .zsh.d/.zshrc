[[ $- == *i* ]] && stty -ixon               # インタラクティブシェルじゃない時用？
# stty -ixon               # Ctrl-sのキーバインド解消

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zsh.d/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit


### End of Zinit's installer chunk
#zmodload zsh/zprof
# plugin settings
zinit ice blockf atpull'zinit creinstall -q .'
zinit light zsh-users/zsh-completions

autoload compinit
compinit

zinit light zdharma-continuum/fast-syntax-highlighting

zinit light zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=242"

# lsのカラー設定
zinit ice atclone"dircolors -b dircolors.256dark > clrs.zsh"\
      atpull'%atclone' pick"clrs.zsh" nocompile'!' \
      atload'zstyle ":completion:*" list-colors “${(s.:.)LS_COLORS}”'
zinit light seebi/dircolors-solarized


###############################
# ディレクトリの移動履歴(cdr)
###############################
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':chpwd:*' recent-dirs-max 5000 # 保存する履歴数
zstyle ':chpwd:*' recent-dirs-default yes #
zstyle ':chpwd:*' recent-dirs-file ${ZDOTDIR:-$HOME}/.chpwd-recent-dirs.${HOST}
zstyle ':completion:*' recent-dirs-insert both
function my_compact_chpwd_recent_dirs() {
    emulate -L zsh
    setopt extendedglob
    local -aU reply
    integer history_size
    autoload -Uz chpwd_recent_filehandler
    chpwd_recent_filehandler
    histor_size=$#reply
    reply=(${^reply}(N))
    (( $history_size == $#reply )) || chpwd_recent_filehandler $reply
}
my_compact_chpwd_recent_dirs    # 移動履歴のコンパクト化


################################
# zawの設定
################################
zinit light zsh-users/zaw
bindkey '^R' zaw-history
zstyle ':filter-select' case-insensitive yes # 絞り込みをcase-insensitiveに
zstyle ':filter-select' extended-search yes # see below
bindkey '^S' zaw-cdr # zaw-cdrをbindkey
bindkey '^X^S' zaw-git-status
bindkey '^U' zaw-git-branches
bindkey '^T' zaw-tmux
bindkey -M filterselect '^E' accept-search
# zstyle ':filter-select:highlight' selected bg=cyan,standout
# tmuxのアクションのカスタマイズ
function zaw-callback-tmux-attach() {
    BUFFER="tmux attach -d -t ${(q)1}"
    zle accept-line
}


# 単語区切りの指定" /:@+|"を単語の区切りとする
WORDCHARS="*?_-.[]~=&;!#$%^(){}<>"
# 上記だけでよくなった？
# autoload -Uz select-word-style
# select-word-style normal
# zstyle ':zle:*' word-chars ":@+|"
# zstyle ':zle:*' word-style unspecified


zinit ice depth=1;zinit light romkatv/powerlevel10k
[[ -f ~/.zsh.d/.p10k.zsh ]] && source ~/.zsh.d/.p10k.zsh

#########################
# Completion setting
#########################
setopt auto_cd # auto change directory
setopt completeinword # 文字列中でも補完を行う
setopt correct # command correct edition before each completion attempt
setopt list_packed # compacked complete list display
setopt magic_equal_subst # = 以降でも補完できるようにする( --prefix=/usr 等の場合)
setopt print_eight_bit # 補完候補リストの日本語を正しく表示
setopt noautoremoveslash # no remove postfix slash of command line
setopt complete_aliases # aliased ls needs if file/dir completions work, aliasを使ったコマンドに補完を効かせる

zstyle ':completion:*' menu select # 一覧表示出した後の補完選択をメニュー選択のようにする
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' # 補完の時に大文字小文字を区別しない(但し、大文字を打った場合は小文字に変換しない)
zstyle ':completion:*:default' list-colors ${LS_COLORS} #lsのカラーと補完リストの色を同じにする
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([%0-9]#)*=0=01;31' # kill の候補にも色付き表示

# date completion
zstyle ':completion:*:date:*' fake \
    '+%Y%m%d: yearMonthDay' \
    '+%Y%m%d-%H%S: yearMonthDay-HourMinuteSecond' \
    '+%Y-%m-%d: year-month-day' \
    '+%Y/%m/%d %H\:%S: year/month/day hour\:minute\:second'

# display dots during Completion waiting.
expand-or-complete-with-dots() {
    echo -n "\e[31m......\e[0m"
    zle expand-or-complete
    zle redisplay
}
zle -N expand-or-complete-with-dots
bindkey "^I" expand-or-complete-with-dots

zmodload zsh/complist
bindkey -M menuselect "^P" up-line-or-history
bindkey -M menuselect "^N" down-line-or-history

if [ $OSTYPE = cygwin ]; then
    zstyle ':completion:*' fake-files '/:c' '/:d' '/:e'
fi

[ -f ~/.zsh.d/alias.zsh ] && source ~/.zsh.d/alias.zsh
[ -f ~/.zsh.d/history.zsh ] && source ~/.zsh.d/history.zsh
[ -f ~/.zsh.d/etc.zsh ] && source ~/.zsh.d/etc.zsh

if [ "$TERM" = "screen-256color" -o "$TERM" = "screen" -o "$TERM" = "xterm-256color" ]; then
    if which pyenv > /dev/null 2>&1; then
        eval "$(pyenv init --path)"
	[ -d $(pyenv root)/plugins/pyenv-virtualenv ] && eval "$(pyenv virtualenv-init -)"
    fi
fi
#zprof
