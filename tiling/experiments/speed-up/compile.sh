#!/bin/bash

BINARY_FOLDER=bin

mkdir $BINARY_FOLDER

mkdir $BINARY_FOLDER/matrix-multiplication
mkdir $BINARY_FOLDER/vector-multiplication
mkdir $BINARY_FOLDER/jacobi

#Matrix
gcc -g -fopenmp matrix-multiplication/ParallelNonTiled.c -o $BINARY_FOLDER/matrix-multiplication/ParallelNonTiled
gcc -g -fopenmp matrix-multiplication/ParallelTiled.c -o $BINARY_FOLDER/matrix-multiplication/ParallelTiled
gcc -g -fopenmp matrix-multiplication/ParallelSingleTiled.c -o $BINARY_FOLDER/matrix-multiplication/ParallelSingleTiled

#Vector
gcc -g -fopenmp vector-multiplication/ParallelNonTiled.c -o $BINARY_FOLDER/vector-multiplication/ParallelNonTiled
gcc -g -fopenmp vector-multiplication/ParallelTiled.c -o $BINARY_FOLDER/vector-multiplication/ParallelTiled
gcc -g -fopenmp vector-multiplication/ParallelSingleTiled.c -o $BINARY_FOLDER/vector-multiplication/ParallelSingleTiled


#Jacobi
gcc -g -fopenmp jacobi/ParallelNonTiled.c -o $BINARY_FOLDER/jacobi/ParallelNonTiled
gcc -g -fopenmp jacobi/ParallelTiled.c -o $BINARY_FOLDER/jacobi/ParallelTiled
gcc -g -fopenmp jacobi/ParallelSingleTiled.c -o $BINARY_FOLDER/jacobi/ParallelSingleTiled