import sys


f = open("300ko_v1.txt", "w")

size = 307200

for i in range(size):
    f.write('a\n')
f.close()
