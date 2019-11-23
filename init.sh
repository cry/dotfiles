#!/usr/bin/env bash

GLOBIGNORE=.

if [[ ! -d ~/.local/dotfiles ]]; then
    mkdir -p ~/.local/dotfiles
fi

for d in {shell,tmux,vim};  do
    echo "[+] Entering $d"

    pushd $d > /dev/null 2>&1

    if [[ -f "init.sh" ]]; then
	./init.sh
    fi

    for f in .*; do
        [[ "$f" == '.*' ]] && continue
        cp -av $f ~/$(basename $f)
    done

    popd > /dev/null 2>&1
done
