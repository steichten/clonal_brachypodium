#!/bin/bash
FILE=$1
awk -F $"\t" 'BEGIN{OFS = FS; print "Chr\tPos\tN\tX"}{print $1,$2,$5+$6,$5}' $1 > ${1}.dss
