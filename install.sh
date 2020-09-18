#! /bin/bash

CURRENTDIR=$(cd $(dirname $0) && pwd)

link () {
    from="$1"
    to="$2"
    echo "Linking ${from} to ${to}"
    ln -sf "$from" "$to"
}

HOGE=(".tmux.conf" ".zshenv" ".zsh.d" ".emacs.d" ".gitconfig" ".aspell.conf" ".latexmkrc")
for ofile in ${HOGE[@]}; do
    link ${CURRENTDIR}/${ofile} ${HOME}/
done

touch ${CURRENTDIR}/.emacs.d/config/local.el


case $OSTYPE in
    *cygwin*)
        cp ${CURRENTDIR}/.keysnail.js ${USERPROFILE}/
        ;;
    *)
        link ${CURRENTDIR}/.keysnail.js ${HOME}/
        ;;
esac
