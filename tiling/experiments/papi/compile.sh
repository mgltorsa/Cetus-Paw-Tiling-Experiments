#!/bin/bash

WORKSPACE_FOLDER=/home/mgltorsa/workspace/cetus-experiments
PROJECT_PATH="-I${PAPI_DIR}/include -I${WORKSPACE_FOLDER}/lib"
PROJECT_LIB="-L${PAPI_DIR}/lib"
PROJECT_EXTRA="-lpapi"
BINARY_FOLDER=bin

mkdir $BINARY_FOLDER

mkdir $BINARY_FOLDER/matrix-multiplication
mkdir $BINARY_FOLDER/vector-multiplication
mkdir $BINARY_FOLDER/jacobi

#Matrix
gcc $PROJECT_PATH $PROJECT_LIB -g -fopenmp matrix-multiplication/ParallelNonTiled.c -o $BINARY_FOLDER/matrix-multiplication/ParallelNonTiled $PROJECT_EXTRA
gcc $PROJECT_PATH $PROJECT_LIB -g -fopenmp matrix-multiplication/ParallelTiled.c -o $BINARY_FOLDER/matrix-multiplication/ParallelTiled $PROJECT_EXTRA
gcc $PROJECT_PATH $PROJECT_LIB -g -fopenmp matrix-multiplication/ParallelSingleTiled.c -o $BINARY_FOLDER/matrix-multiplication/ParallelSingleTiled $PROJECT_EXTRA

#Vector
gcc $PROJECT_PATH $PROJECT_LIB -g -fopenmp vector-multiplication/ParallelNonTiled.c -o $BINARY_FOLDER/vector-multiplication/ParallelNonTiled $PROJECT_EXTRA
gcc $PROJECT_PATH $PROJECT_LIB -g -fopenmp vector-multiplication/ParallelTiled.c -o $BINARY_FOLDER/vector-multiplication/ParallelTiled $PROJECT_EXTRA
gcc $PROJECT_PATH $PROJECT_LIB -g -fopenmp vector-multiplication/ParallelSingleTiled.c -o $BINARY_FOLDER/vector-multiplication/ParallelSingleTiled $PROJECT_EXTRA


#Jacobi
gcc $PROJECT_PATH $PROJECT_LIB -g -fopenmp jacobi/ParallelNonTiled.c -o $BINARY_FOLDER/jacobi/ParallelNonTiled $PROJECT_EXTRA
gcc $PROJECT_PATH $PROJECT_LIB -g -fopenmp jacobi/ParallelTiled.c -o $BINARY_FOLDER/jacobi/ParallelTiled $PROJECT_EXTRA
gcc $PROJECT_PATH $PROJECT_LIB -g -fopenmp jacobi/ParallelSingleTiled.c -o $BINARY_FOLDER/jacobi/ParallelSingleTiled $PROJECT_EXTRA