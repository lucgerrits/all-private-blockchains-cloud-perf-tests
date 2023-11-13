#!/bin/bash


cd "$(dirname "$0")"

#include the config file:
chmod +x config.sh
source config.sh

#RUN example:
#
#./big_test.sh <RANCHER TOKEN> > logs/test-"`date +"%Y-%m-%d-%T"`".log
#

GRAFANA_URL="http://grafana.unice.cust.tasfrance.com/api/annotations"
GRAFANA_DASHBOARD_ID="1"

# JS_THREADS=20
# arr_tests_tps=(200 400 600 800 1000 1200 1400 1600)
# arr_tests_nodes=(3)
# tot_cars=20000
# tot_factories=10
# total_accidents=20000
# TEST_LABEL_PREFIX="test_1" #prefix for the CSV files results (ex: test_1)

JS_THREADS=20
arr_tests_tps=(200 400 600)
arr_tests_nodes=(3)
tot_cars=1000
tot_factories=10
total_accidents=20000
TEST_LABEL_PREFIX="test_1" #prefix for the CSV files results (ex: test_1)


ENABLE_PERSONAL_NOTIFICATIONS=false #true or false

function send_annotation {
    curl -s -H "Content-Type: application/json" \
        -X POST \
        -u admin:admin123  \
        -d "{\"tags\":[\"tests\", \"$4\"], \"dashboardId\":$GRAFANA_DASHBOARD_ID, \"text\":\"tps=$1,total=$2,nb_nodes=$3,cars=$tot_cars,factories=$tot_factories,threads=$JS_THREADS\"}" \
        $GRAFANA_URL
    echo ""
}

cd ../ # goto root folder

for nb_nodes in "${arr_tests_nodes[@]}"; do
    for tps in "${arr_tests_tps[@]}"; do
        if $ENABLE_PERSONAL_NOTIFICATIONS; then
            ss notif "Start ${tps}tps (${nb_nodes} nb_nodes)"
        fi
            
            echo "Number of nodes: $nb_nodes"
            #TODO: change the number of nodes and deploy

            send_annotation "${tps}" "$total_accidents" "${nb_nodes}" "start_init_test"
            ./benchmark/init.sh $tot_cars $tot_factories

            number_of_zero_pending_tx=0
            number_of_loops=0
            #if we have 30 times 0 pending tx, we can exit the while loop
            while [[ $number_of_zero_pending_tx -lt 20 ]]
            do
                echo "#$number_of_loops Waiting for pending transactions to be processed...Current pending transactions: $paras_total_pending_tx"
                sleep 1
                paras_total_pending_tx=$(($(node ./Js/out/get_current_tx_queue.js "$SUBSTRATE_URL") + 0 ))
                if [[ $paras_total_pending_tx -eq 0 ]]; then
                    #if pending tx is 0, we increment the counter
                    number_of_zero_pending_tx=$((number_of_zero_pending_tx + 1))
                else
                    number_of_zero_pending_tx=0 #reset counter
                fi
                number_of_loops=$((number_of_loops + 1))
            done

            send_annotation "${tps}" "$total_accidents" "${nb_nodes}" "end_init_test"
            sleep 60

            # for i in {1..5}; do #repeat 5 times the test
                start_block=$(node ./Js/out/get_current_block_number.js "$SUBSTRATE_URL" "renault")
                echo ""
                echo "################### TEST tps=$tps n°$i #######################"
                send_annotation "${tps}" "$total_accidents" "${nb_nodes}" "start_send_accidents"
                ./benchmark/benchmark.sh $total_accidents $tps $JS_THREADS #send accidents

                number_of_zero_pending_tx=0
                number_of_loops=0
                #if we have 30 times 0 pending tx, we can exit the while loop
                while [[ $number_of_zero_pending_tx -lt 20 ]]
                do
                    echo "#$number_of_loops Waiting for pending transactions to be processed...Current pending transactions: $paras_total_pending_tx"
                    sleep 1
                    #because of the kubernetes ingress, sometimes the node requested has no pending tx but the other nodes may have pending tx
                    paras_total_pending_tx=$(($(node ./Js/out/get_current_tx_queue.js "$SUBSTRATE_URL") + 0 ))
                    if [[ $paras_total_pending_tx -eq 0 ]]; then
                        #if pending tx is 0, we increment the counter
                        number_of_zero_pending_tx=$((number_of_zero_pending_tx + 1))
                    else
                        number_of_zero_pending_tx=0 #reset counter
                    fi
                    number_of_loops=$((number_of_loops + 1))
                done
            
                send_annotation "${tps}" "$total_accidents" "${nb_nodes}" "end_send_accidents"
                sleep 60

                stop_block=$(node ./Js/out/get_current_block_number.js "$SUBSTRATE_URL" "renault")

                echo "################### GET data tps=$tps n°$i #######################"
                #get block stats:
                node Js/out/get_block_stats.js $start_block $stop_block "${TEST_LABEL_PREFIX}_${total_accidents}totaltx_${nb_nodes}nb_nodes_${tps}tps_" "$SUBSTRATE_URL" "renault"

            # done
        if $ENABLE_PERSONAL_NOTIFICATIONS; then
            ss notif "Done ${tps}tps (${nb_nodes} nb_nodes)"
        fi
    done
        if $ENABLE_PERSONAL_NOTIFICATIONS; then
            ss notif "Done ${nb_nodes} nb_nodes"
        fi
done

# echo "move files"
# ./results/move_files.sh
ss notif "Done all tests"

echo "Done"