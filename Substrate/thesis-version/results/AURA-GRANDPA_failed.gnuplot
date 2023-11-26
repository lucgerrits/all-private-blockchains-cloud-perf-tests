set terminal pngcairo nocrop enhanced font "verdana,8" size 640,400
set output "aura_grandpa_failed_tx_result.eps"

set terminal postscript eps enhanced color font 'Times-Roman,18'

set title "AURA-GRANDPA Consensus for 4 to 24 nodes"


set xlabel "Input TPS"
set ylabel "Failed TX (log)"

set grid ytics lc rgb "black" lw 1.5 lt 0.1
set grid xtics lc rgb "black" lw 1.5 lt 0.1

# set yrange [0 to 25]
# set yrange [0:10000]
set ytics ("0" 0.001, "1" 1, "10" 10, "100" 100, "1000" 1000, "10000" 10000)
# set ytics ("0" 0.01, "1" 1, "5" 5, "10" 10)
set log y

set key at graph 0.25, 0.95

#csv settings:
# set key autotitle columnhead
set datafile separator comma

plot "./block_logs/compiled/test_1___4nb_nodes_stats_values.csv" using 15:xtic(1) with linespoints lw 2 title "4 nodes", \
     "./block_logs/compiled/test_1__8nb_nodes_stats_values.csv" using 15:xtic(1) with linespoints lw 2 title "8 nodes", \
     "./block_logs/compiled/test_1__12nb_nodes_stats_values.csv" using 15:xtic(1) with linespoints lw 2 title "12 nodes", \
     "./block_logs/compiled/test_1__16nb_nodes_stats_values.csv" using 15:xtic(1) with linespoints lw 2 title "16 nodes", \
     "./block_logs/compiled/test_1__20nb_nodes_stats_values.csv" using 15:xtic(1) with linespoints lw 2 title "20 nodes", \
     "./block_logs/compiled/test_1__24nb_nodes_stats_values.csv" using 15:xtic(1) with linespoints lw 2 title "24 nodes"

