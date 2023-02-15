#!/bin/bash
#SBATCH --job-name=tile-sizes-job
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=13
#SBATCH --nodes=1
#SBATCH --array=1-5%1
#SBATCH --exclusive
#SBATCH --mail-type=END,FAIL            # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=mgltorsa@udel.edu   # Where to send mail
#SBATCH --time=32:00:00


BINARY_FOLDER=bin
LOOP_INTER_BINARY_FOLDER=bin/loop-inter

. ./../setup.sh


# Baseline
./$BINARY_FOLDER/matrix-multiplication/NonTiled $MATRIX_MULT_M $MATRIX_MULT_M

for i in {1..12..3}
do
    CORES=$i
    #Matrix mult
    
    ./$BINARY_FOLDER/matrix-multiplication/ParallelNonTiled "$CORES" "$CACHE" $MATRIX_MULT_M $MATRIX_MULT_M
    
    
    #Loop interchange
    #LP-Matrix mult
    #./$LOOP_INTER_BINARY_FOLDER/matrix-multiplication/ParallelNonTiled "$CORES" "$CACHE" $MATRIX_MULT_M $MATRIX_MULT_M
    
    
    for k in {16..79..64}
    do
        TILE_SIZE=$SLURM_ARRAY_TASK_ID
        #Matrix mult
        
        ./$BINARY_FOLDER/matrix-multiplication/ParallelTiled "$CORES" "$CACHE" $MATRIX_MULT_M $MATRIX_MULT_M "$TILE_SIZE"
        
        ./$BINARY_FOLDER/matrix-multiplication/ParallelSingleTiled "$CORES" "$CACHE" $MATRIX_MULT_M $MATRIX_MULT_M "$TILE_SIZE"
        
        #Loop interchange
        #LP-Matrix mult
        
        # ./$LOOP_INTER_BINARY_FOLDER/matrix-multiplication/ParallelTiled "$CORES" "$CACHE" $MATRIX_MULT_M $MATRIX_MULT_M "$TILE_SIZE"
        
        # ./$LOOP_INTER_BINARY_FOLDER/matrix-multiplication/ParallelSingleTiled "$CORES" "$CACHE" $MATRIX_MULT_M $MATRIX_MULT_M "$TILE_SIZE"
        
    done
done

