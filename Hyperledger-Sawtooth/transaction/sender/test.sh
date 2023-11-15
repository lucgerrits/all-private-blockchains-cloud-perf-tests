#!/bin/bash


tnxprivatekey=$(<tests_keys/driver.priv)
tnxpublickey=$(<tests_keys/driver.pub)
batchprivatekey=$(<tests_keys/car.priv)
batchpublickey=$(<tests_keys/car.pub)

./transaction  --mode cartp \
    --tnxprivatekey $tnxprivatekey \
    --tnxpublickey $tnxpublickey \
    --batchprivatekey $batchprivatekey \
    --batchpublickey $batchpublickey \
    --cmd crash \
    --accident_ID "QmfM2r8seH2GiRaC4esTjeraXEachRt8ZsSeGaWTPLyMoG" \
    --signature "eda5d1edecda089da6474432971c9ffdd6a7735050c72d1489ddafb6665d9fe31e0ab8fa92013b1ac3e02005714c95ae1c6e2612328d6868c4fd05258133f" \
    --dataPublicKey "Bxm4djh5ap9zBb9YyYHzdw5j6v8IOaHn" \
    --url "http://134.59.230.148:8008/batches"



#  while IFS= read -r line; do
#     $line
#     ./transaction  --mode cartp \
#     --tnxprivatekey $tnxprivatekey \
#     --tnxpublickey $tnxpublickey \
#     --batchprivatekey $batchprivatekey \
#     --batchpublickey $batchpublickey \
#     --cmd crash \
#     --accident_ID "QmfM2r8seH2GiRaC4esTjeraXEachRt8ZsSeGaWTPLyMoG" \
#     --signature  $line \
#     --dataPublicKey "Bxm4djh5ap9zBb9YyYHzdw5j6v8IOaHn" \
#     --url "http://134.59.230.148:8008/batches"
     
#  done < "$1"


echo "Work is done"