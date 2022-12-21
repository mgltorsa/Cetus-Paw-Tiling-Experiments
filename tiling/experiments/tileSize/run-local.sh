#!/bin/bash
BINARY_FOLDER=bin
CAVINESS_CACHE=47185920
DARWIN_CACHE=16777216
CACHE=$DARWIN_CACHE


## Setting up params

MATRIX_MULT_M=1673
MATRIX_VECTOR_MULT_M=2500
MATRIX_VECTOR_MULT_N=3353
JACOBI_M=2897

for i in {1..8}
do
    #Matrix mult
    ./$BINARY_FOLDER/matrix-multiplication/ParallelSingleTiled "$i" "$CACHE" $MATRIX_MULT_M
    
    ./$BINARY_FOLDER/matrix-multiplication/ParallelTiled "$i" "$CACHE" $MATRIX_MULT_M
    
    ./$BINARY_FOLDER/matrix-multiplication/ParallelNonTiled "$i" "$CACHE" $MATRIX_MULT_M
    
    
    ./$BINARY_FOLDER/vector-multiplication/ParallelNonTiled "$i" "$CACHE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N
    
    ./$BINARY_FOLDER/vector-multiplication/ParallelSingleTiled "$i" "$CACHE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N
    
    ./$BINARY_FOLDER/vector-multiplication/ParallelTiled "$i" "$CACHE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N
    
    
    ./$BINARY_FOLDER/jacobi/ParallelTiled "$i" "$CACHE" $JACOBI_M   
    
    ./$BINARY_FOLDER/jacobi/ParallelNonTiled "$i" "$CACHE" $JACOBI_M
    
    ./$BINARY_FOLDER/jacobi/ParallelSingleTiled "$i" "$CACHE" $JACOBI_M
    
done