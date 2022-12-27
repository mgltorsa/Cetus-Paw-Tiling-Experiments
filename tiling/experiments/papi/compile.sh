#!/bin/bash

WORKSPACE_FOLDER=$PWD/../../..
PAPI_DIR=$WORKDIR/sw/papi/src/install/3.7
PROJECT_PATH="-I${PAPI_DIR}/include -I${WORKSPACE_FOLDER}/lib"
PROJECT_LIB="-L${PAPI_DIR}/lib"
PROJECT_EXTRA="-lpapi -lm"
BINARY_FOLDER=bin
LOOP_INTER_BINARY_FOLDER=bin/loop-inter

mkdir $BINARY_FOLDER
mkdir $LOOP_INTER_BINARY_FOLDER

mkdir $BINARY_FOLDER/matrix-multiplication
mkdir $BINARY_FOLDER/vector-multiplication
mkdir $BINARY_FOLDER/jacobi


mkdir $LOOP_INTER_BINARY_FOLDER/matrix-multiplication
mkdir $LOOP_INTER_BINARY_FOLDER/vector-multiplication
mkdir $LOOP_INTER_BINARY_FOLDER/jacobi

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


#loop inter

#Matrix
gcc $PROJECT_PATH $PROJECT_LIB -g -fopenmp loop_inter_tiling/matrix-multiplication/ParallelNonTiled.c -o $LOOP_INTER_BINARY_FOLDER/matrix-multiplication/ParallelNonTiled $PROJECT_EXTRA
gcc $PROJECT_PATH $PROJECT_LIB -g -fopenmp loop_inter_tiling/matrix-multiplication/ParallelTiled.c -o $LOOP_INTER_BINARY_FOLDER/matrix-multiplication/ParallelTiled $PROJECT_EXTRA
gcc $PROJECT_PATH $PROJECT_LIB -g -fopenmp loop_inter_tiling/matrix-multiplication/ParallelSingleTiled.c -o $LOOP_INTER_BINARY_FOLDER/matrix-multiplication/ParallelSingleTiled $PROJECT_EXTRA

#Vector
gcc $PROJECT_PATH $PROJECT_LIB -g -fopenmp loop_inter_tiling/vector-multiplication/ParallelNonTiled.c -o $LOOP_INTER_BINARY_FOLDER/vector-multiplication/ParallelNonTiled $PROJECT_EXTRA
gcc $PROJECT_PATH $PROJECT_LIB -g -fopenmp loop_inter_tiling/vector-multiplication/ParallelTiled.c -o $LOOP_INTER_BINARY_FOLDER/vector-multiplication/ParallelTiled $PROJECT_EXTRA
gcc $PROJECT_PATH $PROJECT_LIB -g -fopenmp loop_inter_tiling/vector-multiplication/ParallelSingleTiled.c -o $LOOP_INTER_BINARY_FOLDER/vector-multiplication/ParallelSingleTiled $PROJECT_EXTRA


#Jacobi
gcc $PROJECT_PATH $PROJECT_LIB -g -fopenmp loop_inter_tiling/jacobi/ParallelNonTiled.c -o $LOOP_INTER_BINARY_FOLDER/jacobi/ParallelNonTiled $PROJECT_EXTRA
gcc $PROJECT_PATH $PROJECT_LIB -g -fopenmp loop_inter_tiling/jacobi/ParallelTiled.c -o $LOOP_INTER_BINARY_FOLDER/jacobi/ParallelTiled $PROJECT_EXTRA
gcc $PROJECT_PATH $PROJECT_LIB -g -fopenmp loop_inter_tiling/jacobi/ParallelSingleTiled.c -o $LOOP_INTER_BINARY_FOLDER/jacobi/ParallelSingleTiled $PROJECT_EXTRA
