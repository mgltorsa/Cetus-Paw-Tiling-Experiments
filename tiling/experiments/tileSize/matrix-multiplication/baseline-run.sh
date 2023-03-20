#!/bin/bash
#SBATCH --job-name=base-mmtl
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --nodes=1
#SBATCH --exclusive
#SBATCH --mail-type=END,FAIL            # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=mgltorsa@udel.edu   # Where to send mail
#SBATCH --time=32:00:00
#SBATCH --constraint='Gen2'

BINARY_FOLDER=bin

. ../../setup.sh

CORES=1

for i in {1..10}
do
    ./$BINARY_FOLDER/NonTiled $MATRIX_MULT_M $MATRIX_MULT_M
done


for j in {1..10}
do
    ./$BINARY_FOLDER/ParallelNonTiled "$CORES" "$CACHE" $MATRIX_MULT_M $MATRIX_MULT_M
done
