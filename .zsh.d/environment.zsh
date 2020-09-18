set_env() {
    export EDITOR="emacsclient -nw"
    export GIT_EDITOR="emacsclient -nw"
    export VISUAL="emacsclient -nw"
    export LANG=ja_JP.UTF-8

    fpath=(~/.localzshcomp(N-/) ~/.zsh.d/my-completions(N-/) $fpath)

    path=(
        $HOME/bin(N-/)
        $HOME/script(N-/)
        $HOME/nora/bin(N-/)
        $HOME/.local/bin(N-/)
        ${HOME}/workspaces/gocode/bin
        /usr/local/cuda/bin(N-/)
        /usr/local/texlive/2017/bin/x86_64-linux(N-/)
        $path)
    ld_library_path=(${HOME}/nora/lib(N-/)
                     /usr/local/cuda/lib(N-/)
                     /usr/local/cuda/lib64(N-/)
                     /usr/local/cuda/extras/CUPTI/lib64(N-/)
                     $ld_library_path)
    PKG_CONFIG_PATH=${HOME}/nora/lib/pkgconfig
    export GOPATH="${HOME}/workspaces/gocode"
    #for highlight syntax in less
    if type src-hilite-lesspipe.sh > /dev/null 2>&1 ; then
        export LESS=' -R '
        export LESSOPEN="| src-hilite-lesspipe.sh %s"
    fi

    manpath=($HOME/man(N-/) $manpath)

    if [ -d "${HOME}/.pyenv" ]; then
        export PYENV_ROOT="${HOME}/.pyenv"
        path=(${PYENV_ROOT}/bin(N-/) $path)
    fi

    ld_library_path=(${HOME}/.cudnn/active/cuda/lib64(N-/) $ld_library_path)
    cpath=(${HOME}/.cudnn/active/cuda/include(N-/) $cpath)
    library_path=(${HOME}/.cudnn/active/cuda/lib64(N-/) $library_path)

}

set_darwin_env() {
    export GIT_EDITOR="/usr/local/bin/emacsclient -nw"
    export EDITOR="/usr/local/bin/emacsclient -nw"
    export VISUAL="/usr/local/bin/emacsclient -nw"
    path=(/usr/local/sbin
          /usr/local/bin
          $path
    )
    export GNUTERM='x11'
    dyld_library_path=(/Users/kentaro/nora/lib(N-/) $dyld_library_path)
    export LSCOLORS=exfxcxdxbxegedabagacad
    export PYENV_ROOT=/usr/local/var/pyenv
}

set_cygwin_env() {
    export LANG=C
    export EDITOR="emacsclient --socket-name=~/.emacs.d/server -nw"
    export GIT_EDITOR="emacsclient --socket-name=~/.emacs.d/server -nw"
    export VISUAL="emacsclient --socket-name=~/.emacs.d/server -nw"
    export TMUX_TMPDIR="/var/tmp"
    export LANG=C
    [ -f ~/.minttyrc.solarized.dark ] && source ~/.minttyrc.solarized.dark
    path=(/usr/local/texlive/2017/bin/i386-cygwin
          $path
    )


}

set_wsl_env() {
    if builtin command -v tasklist.exe > /dev/null ; then
        command_path="/mnt/c/Program Files/VcXsrv/vcxsrv.exe"
        command_name=$(basename "$command_path")
        if ! tasklist.exe 2> /dev/null | grep -q "$command_name"; then
            "$command_path" :0 -multiwindow -wgl &
        fi
        export DISPLAY="localhost:0.0"
    fi
}


set_os_env() {
    case $OSTYPE in
        *darwin*)
            set_darwin_env
            ;;
        *cygwin*)
            set_cygwin_env
        ;;
    esac
}


typeset -xT PYTHONPATH pythonpath
typeset -xT LD_LIBRARY_PATH ld_library_path
typeset -xT DYLD_LIBRARY_PATH dyld_library_path
typeset -xT LIBRARY_PATH library_path
typeset -xT CPATH cpath
typeset -U path manpath cdpath fpath pythonpath ld_library_path dyld_library_path library_path cpath
set_env
set_os_env
set_wsl_env
