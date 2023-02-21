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
LOOP_INTER_BINARY_FOLDER=bin/loop-inter

. ../../setup.sh

echo "$CACHE and $MATRIX_MULT_M"

srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $BINARY_FOLDER/NonTiled "$CORES" "$CACHE" $MATRIX_MULT_M $MATRIX_MULT_M
wait

for i in {1..12..3}
do
    CORES=$i
    
    #Matrix mult
    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $BINARY_FOLDER/ParallelNonTiled "$CORES" "$CACHE" $MATRIX_MULT_M $MATRIX_MULT_M
    wait
    
    for j in {16..2016..64}
    do
        TILE_SIZE=$j
        srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $BINARY_FOLDER/ParallelTiled "$CORES" "$CACHE" $MATRIX_MULT_M $MATRIX_MULT_M $TILE_SIZE
        wait
        srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $BINARY_FOLDER/ParallelSingleTiled "$CORES" "$CACHE" $MATRIX_MULT_M $MATRIX_MULT_M $TILE_SIZE
        wait
        srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $BINARY_FOLDER/ParallelTiledV2 "$CORES" "$CACHE" $MATRIX_MULT_M $MATRIX_MULT_M $TILE_SIZE
        wait
        srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $BINARY_FOLDER/ParallelSingleTiledV2 "$CORES" "$CACHE" $MATRIX_MULT_M $MATRIX_MULT_M $TILE_SIZE
        wait
    done
done
