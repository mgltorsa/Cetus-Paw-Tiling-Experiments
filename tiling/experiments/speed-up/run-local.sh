#!/bin/bash
BINARY_FOLDER=bin

N=1100

for i in {1..8}
do
    #Matrix mult
    ./$BINARY_FOLDER/matrix-multiplication/ParallelNonTiled "$i" $N
    
    ./$BINARY_FOLDER/matrix-multiplication/ParallelTiled "$i" $N

    ./$BINARY_FOLDER/matrix-multiplication/ParallelSingleTiled "$i" $N

    #vector
    ./$BINARY_FOLDER/vector-multiplication/ParallelNonTiled "$i" $N

    ./$BINARY_FOLDER/vector-multiplication/ParallelTiled "$i" $N

    ./$BINARY_FOLDER/vector-multiplication/ParallelSingleTiled "$i" $N

    #jacobi
    ./$BINARY_FOLDER/jacobi/ParallelNonTiled "$i" $N

    ./$BINARY_FOLDER/jacobi/ParallelTiled "$i" $N

    ./$BINARY_FOLDER/jacobi/ParallelSingleTiled "$i" $N
done