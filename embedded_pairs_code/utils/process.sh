#!/bin/bash

filename="$1"
outputFile=result.txt
result="$(awk -F',' '{print $3  $4 $6}' $filename | awk '{print $3, $6, $9}')"
echo "${result}" > $outputFile

WRD=$(head -n 1 $outputFile|wc -w);
for((i=1;i<=$WRD;i++)); do
    awk '{print "& " $'$i'}' $outputFile | tr '\n' ' ';echo;
done
