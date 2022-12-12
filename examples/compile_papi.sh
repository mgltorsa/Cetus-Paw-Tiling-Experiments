#!/bin/sh
WORKSPACE_FOLDER=$PWD
PROJECT_PATH="-I${PAPI_DIR}/include -I${WORKSPACE_FOLDER}/lib"
PROJECT_LIB="-L${PAPI_DIR}/lib"
PROJECT_EXTRA="-lpapi"

echo "running: gcc $PROJECT_PATH $PROJECT_LIB -g -fopenmp $1 -o $2 $PROJECT_EXTRA"

gcc $PROJECT_PATH $PROJECT_LIB -g -fopenmp $1 -o $2 $PROJECT_EXTRA