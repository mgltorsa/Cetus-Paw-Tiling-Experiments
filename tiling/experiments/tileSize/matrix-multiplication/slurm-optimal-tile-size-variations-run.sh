#!/bin/bash
#SBATCH --job-name=mm-tile-sizes-optimals
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

CORES=1

for reps in {1..10}
do
    
    TILE_SIZE_1_LVL=1402
    TILE_SIZE_2_LVL=1983
    
    ./$BINARY_FOLDER/ParallelSingleTiledV2 "$CORES" "$CACHE" $MATRIX_MULT_M $MATRIX_MULT_M $TILE_SIZE_1_LVL
    
    ./$BINARY_FOLDER/ParallelTiledV2 "$CORES" "$CACHE" $MATRIX_MULT_M $MATRIX_MULT_M $TILE_SIZE_2_LVL
    
    
    CORES=4
    
    TILE_SIZE_1_LVL=350
    TILE_SIZE_2_LVL=991
    
    ./$BINARY_FOLDER/ParallelSingleTiledV2 "$CORES" "$CACHE" $MATRIX_MULT_M $MATRIX_MULT_M $TILE_SIZE_1_LVL
    
    ./$BINARY_FOLDER/ParallelTiledV2 "$CORES" "$CACHE" $MATRIX_MULT_M $MATRIX_MULT_M $TILE_SIZE_2_LVL
    
    
    CORES=7
    
    TILE_SIZE_1_LVL=200
    TILE_SIZE_2_LVL=749
    
    ./$BINARY_FOLDER/ParallelSingleTiledV2 "$CORES" "$CACHE" $MATRIX_MULT_M $MATRIX_MULT_M $TILE_SIZE_1_LVL
    
    ./$BINARY_FOLDER/ParallelTiledV2 "$CORES" "$CACHE" $MATRIX_MULT_M $MATRIX_MULT_M $TILE_SIZE_2_LVL
    
    
    CORES=10
    
    TILE_SIZE_1_LVL=140
    TILE_SIZE_2_LVL=627
    
    ./$BINARY_FOLDER/ParallelSingleTiledV2 "$CORES" "$CACHE" $MATRIX_MULT_M $MATRIX_MULT_M $TILE_SIZE_1_LVL
    
    ./$BINARY_FOLDER/ParallelTiledV2 "$CORES" "$CACHE" $MATRIX_MULT_M $MATRIX_MULT_M $TILE_SIZE_2_LVL
    
done






