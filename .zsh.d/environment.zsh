set_env() {
    ##lsコマンドの色設定
    # lsコマンドの補完候補にも色付き表示
    # eval `dircolors`
    export LANG=C
    export LSCOLORS=exfxcxdxbxegedabagacad
    export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=01;05;37;41:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31:*.tbz=01;31:*.tbz2=01;31:*.bz=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=01;36:*.au=01;36:*.flac=01;36:*.mid=01;36:*.midi=01;36:*.mka=01;36:*.mp3=01;36:*.mpc=01;36:*.ogg=01;36:*.ra=01;36:*.wav=01;36:*.axa=01;36:*.oga=01;36:*.spx=01;36:*.xspf=01;36:*.pdf=00;33:*.ps=00;33:*.ps.gz=00;33:*.txt=00;33:*.patch=00;33:*.diff=00;33:*.log=00;33:*.tex=00;33:*.xls=00;33:*.xlsx=00;33:*.ppt=00;33:*.pptx=00;33:*.rtf=00;33:*.doc=00;33:*.docx=00;33:*.odt=00;33:*.ods=00;33:*.odp=00;33:*.xml=00;33:*.epub=00;33:*.abw=00;33:*.htm=00;33:*.html=00;33:*.shtml=00;33:*.wpd=00;33:'
    fpath=(~/.localzshcomp(N-/) $fpath)
    path=(
        $HOME/bin(N-/)
        $HOME/script(N-/)
        $HOME/nora/bin(N-/)
        $HOME/nora/calc_scripts/bin(N-/)
        $HOME/nora/DataProcessor/bin(N-/)
        $HOME/.cask/bin(N-/)
        /System/Library/Frameworks/Python.framework/Versions/2.7/Extras/bin(N-/)
        $path)
    export BIBPYSCRIPT="${HOME}/.bibtex_source/desc_cand_pybtex.py"
    export PYTHONSTARTUP="${HOME}/.pythonstartup"
    export CTEST_OUTPUT_ON_FAILURE=1

    #for highlight syntax in less
    if type src-hilite-lesspipe.sh > /dev/null 2>&1 ; then
        export LESS=' -R '
        export LESSOPEN="| src-hilite-lesspipe.sh %s"
    fi

    pythonpath=(
        $HOME/nora/DataProcessor/lib(N-/)
        $HOME/nora/calc_scripts/lib(N-/)
        $pythonpath)
    manpath=($HOME/man(N-/) $manpath)
}

set_gnu_env() {
    export EDITOR="emacsclient -nw"
    export GIT_EDITOR="emacsclient -nw"
    export VISUAL="emacsclient -nw"
    # For bibtex path
    export BIBINPUTS=$BIBINPUTS:"/home/kentaro/document/journal/bib":"/home/kentaro/Documents"
    # export BIBINPUTS="/home/kentaro/document/journal/bib"
    if [ "$TERM" != "linux" ]; then
        export LC_TIME=C
    fi

    export GOPATH="${HOME}/workspaces/gocode"

    #For Texlive 2011 PATH
    path=(
        /usr/local/cuda/bin(N-/)
        /usr/local/texlive/2013/bin/x86_64-linux(N-/)
        /usr/local/texlive/2014/bin/x86_64-linux(N-/)
        ${HOME}/workspaces/gocode/bin
        $path)
# export MANPATH=/usr/local/texlive/2011/texmf/doc/man:$MANPATH
# export INFOPATH=/usr/local/texlive/2011/texmf/doc/info:$INFOPATH

    pythonpath=(
        /usr/lib64/paraview/site-packages(N-/)
        /usr/lib64/paraview(N-/)
        $pythonpath)
    ld_library_path=(/usr/lib64/paraview(N-/) $ld_library_path)
    ld_library_path=(/usr/lib64/paraview(N-/) /usr/local/cuda/lib(N-/) /usr/local/cuda/lib64 $ld_library_path)
    [ -f /opt/intel/bin/compilervars.sh ] && source /opt/intel/bin/compilervars.sh intel64
    ld_library_path=(~/nora/cmigemo/lib(N-/) $ld_library_path)
}

set_darwin_env() {
    # export LSCOLORS=DxGxcxdxCxegedabagacad
    export GIT_EDITOR="/usr/local/bin/emacsclient -nw"
    export EDITOR="/usr/local/bin/emacsclient -nw"
    export VISUAL="/usr/local/bin/emacsclient -nw"
    export BIBINPUTS=$BIBINPUTS:"/Users/kentaro/Documents/journal/bib/"
    export BIBPDFDIR="${HOME}/Documents/pdf/"
    export BIBFILESDIR="${HOME}/Documents/journal/bib/"
    export GOPATH="${HOME}/workspaces/gocode"
    path=(/usr/local/sbin
          /usr/local/bin
          /Library/Frameworks/Python.framework/Versions/2.7/bin(N-/)
          /usr/local/texlive/2013/bin/x86_64-darwin(N-/)
          ${HOME}/workspaces/gocode/bin
          /usr/local/opt/llvm/bin(N-/)
          $path
    )

    export GNUTERM='x11'
    export REPO1="svn+ssh://tarumi/home/kentaro/svn/repository"
    dyld_library_path=(/Users/kentaro/nora/lib /usr/local/opt/llvm/lib $dyld_library_path)
}

set_solaris_env() {}
set_linux_env() {}

set_os_env() {
    case $OSTYPE in
      *darwin*)
        set_darwin_env
        ;;
      *solaris*)
        set_gnu_env
        set_solaris_env
        ;;
      *)
        set_gnu_env
        set_linux_env
        ;;
    esac
}


typeset -xT PYTHONPATH pythonpath
typeset -xT LD_LIBRARY_PATH ld_library_path
typeset -xT DYLD_LIBRARY_PATH dyld_library_path
typeset -U path manpath cdpath fpath pythonpath ld_library_path dyld_library_path
set_env
set_os_env