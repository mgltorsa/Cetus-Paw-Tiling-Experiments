#!/bin/bash
#SBATCH --job-name=base-mmtl
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --nodes=3
#SBATCH --array=1-10%3
#SBATCH --exclusive
#SBATCH --mail-type=END,FAIL            # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=mgltorsa@udel.edu   # Where to send mail
#SBATCH --time=32:00:00
#SBATCH --constraint='Gen2'

. ../../setup.sh

BINARY_FOLDER=bin

CORES=1
./$BINARY_FOLDER/NonTiled $MATRIX_MULT_M $MATRIX_MULT_M

./$BINARY_FOLDER/ParallelNonTiled "$CORES" "$CACHE" $MATRIX_MULT_M $MATRIX_MULT_M


