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

./transaction -v --mode cartp \
    --tnxprivatekey $tnxprivatekey \
    --tnxpublickey $tnxpublickey \
    --batchprivatekey $batchprivatekey \
    --batchpublickey $batchpublickey \
    --cmd new_owner \
    --owner_lastname "Gerrits" \
    --owner_name "Luc" \
    --owner_address "1 av Atlantis" \
    --owner_country "France" \
    --url http://134.59.230.148:8008/batches
