#!/bin/bash
#SBATCH --job-name=mmpp-variations
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=10
#SBATCH --nodes=1
#SBATCH --exclusive
#SBATCH --mail-type=END,FAIL            # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=mgltorsa@udel.edu   # Where to send mail
#SBATCH --time=32:00:00
#SBATCH --constraint='Gen2'

. ../../setup.sh

BINARY_FOLDER=bin
LOOP_INTER_BINARY_FOLDER=bin/loop-inter

for reps in {1..10}
do
    for z in {0..1}
    do
        TYPE=$z
        for i in {1..12..3}
        do
            CORES=$i
            
            for j in {16..256..16}
            do
                TILE_SIZE=$j
                ./$BINARY_FOLDER/ParallelTiled "$CORES" "$CACHE" "$TYPE" $MATRIX_MULT_M $MATRIX_MULT_M $TILE_SIZE
                
                
                ./$BINARY_FOLDER/ParallelSingleTiled "$CORES" "$CACHE" "$TYPE" $MATRIX_MULT_M $MATRIX_MULT_M $TILE_SIZE
                
                
            done
        done
    done
done