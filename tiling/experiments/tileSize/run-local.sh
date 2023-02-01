#!/bin/bash
CACHE=8388608


## Setting up params
MATRIX_MULT_M=1673
MATRIX_VECTOR_MULT_M=2500
MATRIX_VECTOR_MULT_N=3353
JACOBI_M=2897

BINARY_FOLDER=bin
LOOP_INTER_BINARY_FOLDER=bin/loop-inter


TILE_SIZE=$SLURM_ARRAY_TASK_ID
#STEP=64
#for TILE_SIZE in $( eval echo {16..$MATRIX_MULT_M..$STEP})
#do
for i in {1..12..3}
do
    CORES=$i

    #Matrix mult
   ./$BINARY_FOLDER/matrix-multiplication/ParallelNonTiled "$CORES" "$CACHE" $MATRIX_MULT_M $MATRIX_MULT_M $TILE_SIZE
    
   ./$BINARY_FOLDER/matrix-multiplication/ParallelTiled "$CORES" "$CACHE" $MATRIX_MULT_M $MATRIX_MULT_M $TILE_SIZE
    
   ./$BINARY_FOLDER/matrix-multiplication/ParallelSingleTiled "$CORES" "$CACHE" $MATRIX_MULT_M $MATRIX_MULT_M $TILE_SIZE
    
    #vector
   ./$BINARY_FOLDER/vector-multiplication/ParallelNonTiled "$CORES" "$CACHE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N $TILE_SIZE
    
   ./$BINARY_FOLDER/vector-multiplication/ParallelTiled "$CORES" "$CACHE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N $TILE_SIZE
    
   ./$BINARY_FOLDER/vector-multiplication/ParallelSingleTiled "$CORES" "$CACHE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N $TILE_SIZE
    
    #jacobi
   ./$BINARY_FOLDER/jacobi/ParallelNonTiled "$CORES" "$CACHE" $JACOBI_M $TILE_SIZE
    
   ./$BINARY_FOLDER/jacobi/ParallelTiled "$CORES" "$CACHE" $JACOBI_M $TILE_SIZE
    
   ./$BINARY_FOLDER/jacobi/ParallelSingleTiled "$CORES" "$CACHE" $JACOBI_M $TILE_SIZE
    

    #Loop interchange
    #LP-Matrix mult
   ./$LOOP_INTER_BINARY_FOLDER/matrix-multiplication/ParallelNonTiled "$CORES" "$CACHE" $MATRIX_MULT_M $MATRIX_MULT_M $TILE_SIZE
    
   ./$LOOP_INTER_BINARY_FOLDER/matrix-multiplication/ParallelTiled "$CORES" "$CACHE" $MATRIX_MULT_M $MATRIX_MULT_M $TILE_SIZE
    
   ./$LOOP_INTER_BINARY_FOLDER/matrix-multiplication/ParallelSingleTiled "$CORES" "$CACHE" $MATRIX_MULT_M $MATRIX_MULT_M $TILE_SIZE
    
    #LP-vector
   ./$LOOP_INTER_BINARY_FOLDER/vector-multiplication/ParallelNonTiled "$CORES" "$CACHE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N $TILE_SIZE
    
   ./$LOOP_INTER_BINARY_FOLDER/vector-multiplication/ParallelTiled "$CORES" "$CACHE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N $TILE_SIZE
    
   ./$LOOP_INTER_BINARY_FOLDER/vector-multiplication/ParallelSingleTiled "$CORES" "$CACHE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N $TILE_SIZE
    
    #LP-jacobi
   ./$LOOP_INTER_BINARY_FOLDER/jacobi/ParallelNonTiled "$CORES" "$CACHE" $JACOBI_M $TILE_SIZE
    
   ./$LOOP_INTER_BINARY_FOLDER/jacobi/ParallelTiled "$CORES" "$CACHE" $JACOBI_M $TILE_SIZE
    
   ./$LOOP_INTER_BINARY_FOLDER/jacobi/ParallelSingleTiled "$CORES" "$CACHE" $JACOBI_M $TILE_SIZE
    
done
