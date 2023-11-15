#!/bin/bash
# Basic range in for loop

tnxprivatekey=$(<tests_keys/driver.priv)
tnxpublickey=$(<tests_keys/driver.pub)
batchprivatekey=$(<tests_keys/car.priv)
batchpublickey=$(<tests_keys/car.pub)


declare -a arr=("1ko.txt" "10ko.txt" "100ko.txt" "1Mo.txt" "10Mo.txt")

for i in "${arr[@]}"
do
    for value in {1..3}
    do
        sleep 2;
        ./transaction  --mode measurments \
        --tnxprivatekey $tnxprivatekey \
        --tnxpublickey $tnxpublickey \
        --batchprivatekey $batchprivatekey \
        --batchpublickey $batchpublickey \
        --file_name "dataSet/$i" \
        --cmd crash \
        --dataPublicKey "Bxm4djh5ap9zBb9YyYHzdw5j6v8IOaHn" \
        --url http://134.59.230.148:8008/batches 


    done

    ./accumulation.py "dataSet/measurements/$i" >> "dataSet/measurements/measurementResults.txt"
done