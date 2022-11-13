#!/bin/bash
BINARY_FOLDER=bin


for i in {1..8}
do
    #Matrix mult
    ./$BINARY_FOLDER/matrix-multiplication/ParallelNonTiled "$i" 2000 &
    wait
    ./$BINARY_FOLDER/matrix-multiplication/ParallelTiled "$i" 2000 &
    wait
    ./$BINARY_FOLDER/matrix-multiplication/ParallelSingleTiled "$i" 2000 &
    wait
    #vector
    ./$BINARY_FOLDER/vector-multiplication/ParallelNonTiled "$i" 2000 &
    wait
    ./$BINARY_FOLDER/vector-multiplication/ParallelTiled "$i" 2000 &
    wait
    ./$BINARY_FOLDER/vector-multiplication/ParallelSingleTiled "$i" 2000 &
    wait
    #jacobi
    ./$BINARY_FOLDER/jacobi/ParallelNonTiled "$i" 2000 &
    wait
    ./$BINARY_FOLDER/jacobi/ParallelTiled "$i" 2000 &
    wait
    ./$BINARY_FOLDER/jacobi/ParallelSingleTiled "$i" 2000 &
    wait
done