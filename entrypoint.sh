#!/bin/sh
exportfs -o "$SETTING" $ALLOW_HOST:$EXPORT_DIR
rpcbind 
rpc.statd 
rpc.nfsd
exec rpc.mountd --foreground
