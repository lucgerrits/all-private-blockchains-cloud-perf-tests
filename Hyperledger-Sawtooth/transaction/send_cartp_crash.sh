#!/bin/bash

######
#tnx keys=driver keys
#batch keys=car keys
#
######

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
    --accident_ID "QmPn3iFnHH9SrL7rfEMKExR8MaELC62z29MeSxVvnUQA6e" \
    --signature "oLqhmasm3U+NGSE260jHFLQdJJ0PZWs7" \
    --dataPublicKey "Bxm4djh5ap9zBb9YyYHzdw5j6v8IOaHn" \
    --url http://134.59.230.148:8008/batches
