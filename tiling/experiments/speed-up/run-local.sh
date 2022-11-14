#!/bin/bash
BINARY_FOLDER=bin
#32*1024
CACHE=32768 

N=1200

for i in {1..8}
do
    #Matrix mult
    ./$BINARY_FOLDER/matrix-multiplication/ParallelSingleTiled "$i" "$CACHE" $N
    
    ./$BINARY_FOLDER/matrix-multiplication/ParallelNonTiled "$i" "$CACHE" $N

    ./$BINARY_FOLDER/matrix-multiplication/ParallelTiled "$i" "$CACHE" $N

    #vector
    ./$BINARY_FOLDER/vector-multiplication/ParallelSingleTiled "$i" "$CACHE" $N

    ./$BINARY_FOLDER/vector-multiplication/ParallelNonTiled "$i" "$CACHE" $N

    ./$BINARY_FOLDER/vector-multiplication/ParallelTiled "$i" "$CACHE" $N


    #jacobi
    
    ./$BINARY_FOLDER/jacobi/ParallelSingleTiled "$i" "$CACHE" $N
    
    ./$BINARY_FOLDER/jacobi/ParallelNonTiled "$i" "$CACHE" $N

    ./$BINARY_FOLDER/jacobi/ParallelTiled "$i" "$CACHE" $N

done