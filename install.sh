#! /bin/bash

CURRENTDIR=$(cd $(dirname $0) && pwd)

link () {
    from="$1"
    to="$2"
    echo "Linking ${from} to ${to}"
    ln -sf "$from" "$to"
}

(cd $CURRENTDIR && git submodule update --init)

HOGE=(".tmux.conf" ".zshenv" ".zsh.d" ".emacs.d")
for ofile in ${HOGE[@]}; do
    link ${CURRENTDIR}/${ofile} ${HOME}/
done
