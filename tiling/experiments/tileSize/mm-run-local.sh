#!/bin/bash
CACHE=8388608


## Setting up params
MATRIX_MULT_M=1673
MATRIX_VECTOR_MULT_M=2500
MATRIX_VECTOR_MULT_N=3353
JACOBI_M=2897

BINARY_FOLDER=bin
LOOP_INTER_BINARY_FOLDER=bin/loop-inter


#STEP=64
#for TILE_SIZE in $( eval echo {16..$MATRIX_MULT_M..$STEP})
#do
for j in {1..5}
do
   for i in {1..12..3}
   do
   CORES=$i
   #Matrix mult
   ./$BINARY_FOLDER/matrix-multiplication/ParallelNonTiled "$CORES" "$CACHE" $MATRIX_MULT_M $MATRIX_MULT_M


   #Loop interchange
   #LP-Matrix mult
   ./$LOOP_INTER_BINARY_FOLDER/matrix-multiplication/ParallelNonTiled "$CORES" "$CACHE" $MATRIX_MULT_M $MATRIX_MULT_M
              

    for k in {16..2016..64}
    do
        TILE_SIZE=$k
        #Matrix mult

        ./$BINARY_FOLDER/matrix-multiplication/ParallelTiled "$CORES" "$CACHE" $MATRIX_MULT_M $MATRIX_MULT_M "$TILE_SIZE"
              
        ./$BINARY_FOLDER/matrix-multiplication/ParallelSingleTiled "$CORES" "$CACHE" $MATRIX_MULT_M $MATRIX_MULT_M "$TILE_SIZE"

          #Loop interchange
          #LP-Matrix mult
                
          ./$LOOP_INTER_BINARY_FOLDER/matrix-multiplication/ParallelTiled "$CORES" "$CACHE" $MATRIX_MULT_M $MATRIX_MULT_M "$TILE_SIZE"
                
          ./$LOOP_INTER_BINARY_FOLDER/matrix-multiplication/ParallelSingleTiled "$CORES" "$CACHE" $MATRIX_MULT_M $MATRIX_MULT_M "$TILE_SIZE"
                
    done
  done
done
