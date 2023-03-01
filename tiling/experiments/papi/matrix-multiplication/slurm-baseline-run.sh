#!/bin/bash
#SBATCH --job-name=mm-tile-sizes-job
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=13
#SBATCH --nodes=3
#SBATCH --array=1-10%3
#SBATCH --exclusive
#SBATCH --mail-type=END,FAIL            # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=mgltorsa@udel.edu   # Where to send mail
#SBATCH --time=32:00:00
#SBATCH --constraint='Gen2'

BINARY_FOLDER=bin

TYPE=0
CORES=1

./$BINARY_FOLDER/NonTiled "$TYPE" $MATRIX_MULT_M $MATRIX_MULT_M

./$BINARY_FOLDER/ParallelNonTiled "$CORES" "$CACHE" "$TYPE" $MATRIX_MULT_M $MATRIX_MULT_M


TYPE=1
./$BINARY_FOLDER/NonTiled "$TYPE" $MATRIX_MULT_M $MATRIX_MULT_M


./$BINARY_FOLDER/ParallelNonTiled "$CORES" "$CACHE" "$TYPE" $MATRIX_MULT_M $MATRIX_MULT_M


