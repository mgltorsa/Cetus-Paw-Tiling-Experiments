#!/bin/bash

WORKSPACE_FOLDER=$PWD/../../../..
PAPI_DIR=$WORKDIR/sw/papi/src/install/3.7
PROJECT_PATH="-I${PAPI_DIR}/include -I${WORKSPACE_FOLDER}/lib"
PROJECT_LIB="-L${PAPI_DIR}/lib"
PROJECT_EXTRA="-lpapi -lm"

BINARY_FOLDER=bin

mkdir $BINARY_FOLDER

echo "script"
echo "gcc $PROJECT_PATH $PROJECT_LIB -g -fopenmp ParallelNonTiled.c -o $BINARY_FOLDER/ParallelNonTiled $PROJECT_EXTRA"


gcc $PROJECT_PATH $PROJECT_LIB -g -fopenmp NonTiled.c -o $BINARY_FOLDER/NonTiled $PROJECT_EXTRA
gcc $PROJECT_PATH $PROJECT_LIB -g -fopenmp ParallelNonTiled.c -o $BINARY_FOLDER/ParallelNonTiled $PROJECT_EXTRA
gcc $PROJECT_PATH $PROJECT_LIB -g -fopenmp ParallelTiled.c -o $BINARY_FOLDER/ParallelTiled $PROJECT_EXTRA
gcc $PROJECT_PATH $PROJECT_LIB -g -fopenmp ParallelSingleTiled.c -o $BINARY_FOLDER/ParallelSingleTiled $PROJECT_EXTRA
