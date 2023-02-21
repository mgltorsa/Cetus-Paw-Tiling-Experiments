#!/bin/bash
#SBATCH --job-name=mm-tile-sizes-job
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=13
#SBATCH --nodes=3
#SBATCH --array=1-10%3
#SBATCH --exclusive
#SBATCH --mail-type=END,FAIL            # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=mgltorsa@udel.edu   # Where to send mail
#SBATCH --time=32:00:00
#SBATCH --constraint='Gen2'

BINARY_FOLDER=bin

. ../../setup.sh

echo "$CACHE and $MATRIX_MULT_M"

for i in {1..10}
do
    ./$BINARY_FOLDER/NonTiled "$CORES" "$CACHE" $MATRIX_MULT_M $MATRIX_MULT_M
done


for j in {1..10}
do
    CORES=0
    ./$BINARY_FOLDER/ParallelNonTiled "$CORES" "$CACHE" $MATRIX_MULT_M $MATRIX_MULT_M
    
done
