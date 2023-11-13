#!/bin/bash

cd "$(dirname "$0")"

#include the config file:
chmod +x config.sh
source config.sh

cd rancher-v2.4.10/

#$1 is the rancher login token

# ./login.sh $1


# echo "Deploying IPFS"
# ./rancher kubectl -n $NAMESPACE apply -f ../ipfs.yaml

echo "Load Deployments"
#big file so update config map manually using cmd line:
./rancher kubectl delete configmap chain-spec -n $NAMESPACE
./rancher kubectl create configmap chain-spec -n $NAMESPACE --from-file=../customSpecRaw.json

echo "Deploying Substrate"
# ./rancher kubectl -n $NAMESPACE apply -f ../substrate.yaml
./rancher kubectl -n $NAMESPACE apply -f ../substrate-generated.yaml