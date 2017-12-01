#!/usr/bin/zsh
BASE="$(dirname "$(readlink -f "$0")")"
source "$BASE/lib.zsh"

for NODE in $NODES; do
    NODEDIR="$BASE/$NODE"
    [[ -d "$NODEDIR" ]] && die "$NODEDIR node directory exists"
    mkdir "$NODEDIR"
    geth init --datadir "$NODEDIR/data" "$GENESIS"
done
