set terminal pngcairo nocrop enhanced font "verdana,8" size 640,400
set output "aura_grandpa_result.eps"

set terminal postscript eps enhanced color font 'Times-Roman,18'

set title "AURA-GRANDPA Consensus for 4 to 24 nodes"

set grid ytics lc rgb "black" lw 1.5 lt 0.1
set grid xtics lc rgb "black" lw 1.5 lt 0.1


set xlabel "Input TPS"
set ylabel "Output TPS"

set yrange [0 to 600]

set key at graph 0.25, 0.95

#csv settings:
# set key autotitle columnhead
set datafile separator comma


$data << EOD
200, 185.35, 196.25, 196.25, 185.35, 185.35, 185.35
400, 370.54, 370.54, 333.5, 370.54, 333.18, 334.53
600, 476.34, 417.35, 476.35, 303.2, 277.95, 306.29
800, 370.54, 333.37, 256.49, 185.19, 158.9, 264.82
1000, 456.28, 300.31, 196.25, 166.8, 110.88, 302.49
1200, 474.32, 277.24, 222.13, 222.11, 150.62, 298.82
1400, 446.11, 237.87, 192.72, 152.9, 141.22, 236.85
1600, 443.2, 334.13, 229.45, 238.3, 151.58, 237.51
EOD

plot "$data" using 1:2 with linespoints lw 2 title "4 nodes", \
    "$data" using 1:3 with linespoints lw 2 title "8 nodes", \
    "$data" using 1:4 with linespoints lw 2 title "12 nodes", \
    "$data" using 1:5 with linespoints lw 2 title "16 nodes", \
    "$data" using 1:6 with linespoints lw 2 title "20 nodes", \
    "$data" using 1:7 with linespoints lw 2 title "24 nodes"