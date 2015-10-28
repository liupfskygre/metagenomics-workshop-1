#!/bin/bash

module load bioinfo-tools
module load BEDTools/2.23.0

infile=$1
gff=$2
outfile=$3
bed=$4

if [ "$infile" == "" ] || [ "$gff" == "" ] || [ "$outfile" == "" ]; then
    echo "Usage: bam_hist.sh <bam|bed infile> <gff file> <outfile> [bed]"
    exit 0
fi

prog=`which bedtools`
echo `date`

if [ "$bed" == "" ] ; then
    $prog coverage -hist -abam $infile -b $gff > $outfile
else
    $prog coverage -hist -a $infile -b $gff > $outfile
fi
echo `date`
