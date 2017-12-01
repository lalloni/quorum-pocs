#!/usr/bin/zsh
BASE="$(dirname "$(readlink -f "$0")")"
source "$BASE/lib.zsh"

for NODE in $NODES; do
    rm -rf "$BASE/$NODE"
done

rm -f boot.key
