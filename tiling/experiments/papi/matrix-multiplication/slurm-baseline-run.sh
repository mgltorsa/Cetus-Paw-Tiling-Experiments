#!/bin/bash
#SBATCH --job-name=mmpp-baseline
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --threads-per-core=1
#SBATCH --exclusive
#SBATCH --mail-type=END,FAIL            # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=mgltorsa@udel.edu   # Where to send mail
#SBATCH --time=32:00:00
#SBATCH --constraint='Gen2'

vpkg_require papi

. ../../setup.sh

BINARY_FOLDER=bin

CORES=1

for i in {1..10}
do
    TYPE=0
    ./$BINARY_FOLDER/NonTiled "$TYPE" $MATRIX_MULT_M $MATRIX_MULT_M
    
    ./$BINARY_FOLDER/ParallelNonTiled "$CORES" "$CACHE" "$TYPE" $MATRIX_MULT_M $MATRIX_MULT_M
    
    ./$BINARY_FOLDER/NoFSParallelNonTiled "$CORES" "$CACHE" "$TYPE" $MATRIX_MULT_M $MATRIX_MULT_M

    
    TYPE=1
    ./$BINARY_FOLDER/NonTiled "$TYPE" $MATRIX_MULT_M $MATRIX_MULT_M
    
    
    ./$BINARY_FOLDER/ParallelNonTiled "$CORES" "$CACHE" "$TYPE" $MATRIX_MULT_M $MATRIX_MULT_M

    ./$BINARY_FOLDER/NoFSParallelNonTiled "$CORES" "$CACHE" "$TYPE" $MATRIX_MULT_M $MATRIX_MULT_M
done


