# Default completon(compsys)
autoload -U compinit

# auto change directory
setopt auto_cd

# 文字列中でも補完を行う
setopt completeinword

# command correct edition before each completion attempt
setopt correct

# compacked complete list display
setopt list_packed


# = 以降でも補完できるようにする( --prefix=/usr 等の場合)
setopt magic_equal_subst

# 補完候補リストの日本語を正しく表示
setopt print_eight_bit

# no remove postfix slash of command line
setopt noautoremoveslash

# 一覧表示出した後の補完選択をメニュー選択のようにする
zstyle ':completion:*' menu select

# 補完の時に大文字小文字を区別しない(但し、大文字を打った場合は小文字に変換しない)
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

#aliasを使ったコマンドに補完を効かせる
setopt complete_aliases # aliased ls needs if file/dir completions work

ls_dircolors_home="${HOME}/.zsh.d/dircolors-solarized/dircolors."
#ls_color_theme=256dark
#ls_color_theme=ansi-dark
#ls_color_theme=ansi-light
ls_color_theme=ansi-universal

# lsのカラー設定
if type dircolors > /dev/null 2>&1 ;then
    eval $(dircolors -b ${ls_dircolors_home}${ls_color_theme})
elif type gdircolors > /dev/null 2>&1 ;then
    eval $(gdircolors -b ${ls_dircolors_home}${ls_color_theme})
fi

#lsのカラーと補完リストの色を同じにする
zstyle ':completion:*:default' list-colors ${LS_COLORS}

# kill の候補にも色付き表示
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([%0-9]#)*=0=01;31'

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

fpath=(~/.zsh.d/my-completions(N-/) $fpath)

if [ $OSTYPE = cygwin ]; then
    zstyle ':completion:*' fake-files '/:c' '/:d' '/:e'
fi

compinit
