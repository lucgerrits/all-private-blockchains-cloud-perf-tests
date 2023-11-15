#!/usr/bin/env python

import argparse
parser = argparse.ArgumentParser()
parser.add_argument("fileName")
args = parser.parse_args()

fileStr = args.fileName


SUM=0;
iteration=0
with open(fileStr) as infile:
    for line in infile:
       SUM = SUM + int(line)
       iteration = iteration + 1
mean=SUM/ float(iteration)

print("Elapsed time of {} : {} us, number of iteration : {}, mean is {} us \n").format(fileStr, SUM, iteration, mean)

