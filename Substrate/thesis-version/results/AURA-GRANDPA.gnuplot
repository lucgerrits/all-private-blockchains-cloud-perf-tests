set terminal pngcairo nocrop enhanced font "verdana,8" size 640,400
set output "aura_grandpa_result.eps"

set terminal postscript eps enhanced color font 'Times-Roman,18'

set title "AURA-GRANDPA Consensus for 4 to 24 nodes"

set grid ytics lc rgb "black" lw 1.5 lt 0.1
set grid xtics lc rgb "black" lw 1.5 lt 0.1


set xlabel "Input TPS"
set ylabel "Output TPS"

# set yrange [0 to 1000]

set key at graph 0.25, 0.95

#csv settings:
# set key autotitle columnhead
set datafile separator comma


$data << EOD
200, 185.35, 196.25
400, 370.54, 370.54
600, 476.34, 417.35
800, 370.54, 333.37
1000, 456.28, 300.31
1200, 474.32, 277.24
1400, 446.11, 237.87
1600, 443.2, 334.13
EOD

plot "$data" using 1:2 with linespoints lw 2 title "4 nodes", \
    "$data" using 1:3 with linespoints lw 2 title "8 nodes"