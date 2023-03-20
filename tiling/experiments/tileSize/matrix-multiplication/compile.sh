#!/bin/bash

BINARY_FOLDER=bin
PROJECT_EXTRA="-lm"

mkdir $BINARY_FOLDER

mkdir $BINARY_FOLDER

gcc -g -fopenmp NonTiled.c -o $BINARY_FOLDER/NonTiled $PROJECT_EXTRA
gcc -g -fopenmp ParallelNonTiled.c -o $BINARY_FOLDER/ParallelNonTiled $PROJECT_EXTRA
gcc -g -fopenmp NoFSParallelNonTiled.c -o $BINARY_FOLDER/NoFSParallelNonTiled $PROJECT_EXTRA


gcc -g -fopenmp ParallelTiled.c -o $BINARY_FOLDER/ParallelTiled $PROJECT_EXTRA
gcc -g -fopenmp ParallelSingleTiled.c -o $BINARY_FOLDER/ParallelSingleTiled $PROJECT_EXTRA


gcc -g -fopenmp ParallelTiledV2.c -o $BINARY_FOLDER/ParallelTiledV2 $PROJECT_EXTRA
gcc -g -fopenmp NoFSParallelTiledV2.c -o $BINARY_FOLDER/NoFSParallelTiledV2 $PROJECT_EXTRA


gcc -g -fopenmp ParallelSingleTiledV2.c -o $BINARY_FOLDER/ParallelSingleTiledV2 $PROJECT_EXTRA
gcc -g -fopenmp NoFSParallelSingleTiledV2.c -o $BINARY_FOLDER/NoFSParallelSingleTiledV2 $PROJECT_EXTRA
