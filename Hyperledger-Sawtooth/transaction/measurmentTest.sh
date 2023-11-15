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

./transaction  --mode measurments \
    --tnxprivatekey $tnxprivatekey \
    --tnxpublickey $tnxpublickey \
    --batchprivatekey $batchprivatekey \
    --batchpublickey $batchpublickey \
    --file_name "dataSet/1ko.txt" \
    --cmd crash \
    --dataPublicKey "Bxm4djh5ap9zBb9YyYHzdw5j6v8IOaHn" \
    --url "http://134.59.230.148:8008/batches" \
    --url_ipfs http://134.59.230.100:5000

    