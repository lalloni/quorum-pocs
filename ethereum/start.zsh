#!/usr/bin/zsh
BASE="$(dirname "$(readlink -f "$0")")"
source "$BASE/lib.zsh"

trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM EXIT

[[ -f "$BOOTKEY" ]] || bootnode --genkey="$BOOTKEY"
BOOTNODE="enode://$(bootnode --nodekey="$BOOTKEY" --writeaddress)@$BOOTADDR"
bootnode --nodekey="$BOOTKEY" --addr="$BOOTADDR" |& awk '{print "BOOTNODE " $0}' &

MINE=(--mine --minerthreads=1 --etherbase=0x0000000000000000000000000000000000000001 --gasprice=0)
NODEPORT=30000
RPCPORT=40000
for NODE in $NODES; do
    NODEDIR="$BASE/$NODE"
    NODEPORT=$((NODEPORT+1))
    RPCPORT=$((RPCPORT+1))
    geth \
        $MINE[@] \
        --identity="$NODE" \
        --rpc --rpcport=$RPCPORT --rpcaddr=0.0.0.0 \
        --shh --shh.pow=0 \
        --txpool.pricelimit=0 \
        --ethash.dagdir="$NODEDIR/ethash" \
        --fakepow \
        --port="$NODEPORT" \
        --datadir="$NODEDIR/data" \
        --bootnodes="$BOOTNODE" \
        |& awk "{print \"NODE[$NODE] \" \$0}" &
    MINE=""
done

while true; do
    sleep 1
done
