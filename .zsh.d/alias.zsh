# 補完される前にオリジナルのコマンドまで展開してチェックする
setopt complete_aliases

set_alias(){
    alias grep='grep --color'
    alias pag="ps aux |grep"
    alias ll='ls -lh'
    alias la='ls -a'
    alias pkill='pkill -x'
    alias lv='lv -c'
    alias less='less -r'
    alias le='less -r'
    alias ne="emacsclient -nw"
    alias e="emacsclient -n"
    alias em="emacsclient"
    function read_only_emacsclient() {
        emacsclient -t -e "(find-file-read-only \"$1\")"
    }
    alias vw="read_only_emacsclient"

    alias -g L='| less'
    alias -g H='| head'
    alias -g T='| tail'
    alias -g G='| grep'
    alias -g S='| sed'
    alias -g A='| awk'
    alias -g W='| wc'
}

set_darwin_alias(){
    alias javac="javac -J-Dfile.encoding=UTF8"
    alias java="java -Dfile.encoding=UTF8"
    alias ls="gls --color"
    alias more='more -r'
    alias emacsserver="open -a emacs -n"
    alias emacs="/usr/local/bin/emacsclient -n"
    alias emacsclient="/usr/local/bin/emacsclient"
    alias acroread='open -a Adobe\ reader -n'
    alias vlc='open -a vlc'
}

set_linux_alias(){
    alias emacsserver="XMODIFIERS=@im=none emacs"
    alias xlock="xlock -mode blank"
    alias pxdvi='LANG=C pxdvi'
    alias gv='LANG=C gv'
    alias ls="ls --color"
}

set_cygwin_alias(){
    alias emacs="emacsclient -n"
    alias emacsclient="emacsclient --socket-name=~/.emacs.d/server"
}


set_os_alias() {
    case $OSTYPE in
      *darwin*)
          set_darwin_alias
          ;;
      *linux*)
          set_linux_alias
          ;;
      *cygwin*)
          set_linux_alias
          set_cygwin_alias
          ;;
    esac
}

# For default alias
set_alias

# For OS depending alias
set_os_alias
