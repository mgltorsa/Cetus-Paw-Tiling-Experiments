#!/bin/bash
#SBATCH --job-name=matrix-mult-job
#SBATCH --ntasks=2
#SBATCH --cpus-per-task=32
#SBATCH --nodes=2
#SBATCH --exclusive
#SBATCH --mail-type=END,FAIL            # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=mgltorsa@udel.edu   # Where to send mail
#SBATCH --output=papi-experiments.csv    # Standard output and error log
#SBATCH --open-mode=append

BINARY_FOLDER=bin

TYPE=0
for i in {1..8}
do
    #Matrix mult
    ./$BINARY_FOLDER/matrix-multiplication/ParallelNonTiled "$i" "$TYPE" 2000 &
    wait
    ./$BINARY_FOLDER/matrix-multiplication/ParallelTiled "$i" "$TYPE" 2000 &
    wait
    ./$BINARY_FOLDER/matrix-multiplication/ParallelSingleTiled "$i" "$TYPE" 2000 &
    wait
    ./$BINARY_FOLDER/vector-multiplication/ParallelNonTiled "$i" "$TYPE" 2000 &
    wait
    ./$BINARY_FOLDER/vector-multiplication/ParallelTiled "$i" "$TYPE" 2000 &
    wait
    ./$BINARY_FOLDER/vector-multiplication/ParallelSingleTiled "$i" "$TYPE" 2000 &
    wait
    ./$BINARY_FOLDER/jacobi/ParallelNonTiled "$i" "$TYPE" 2000 &
    wait
    ./$BINARY_FOLDER/jacobi/ParallelTiled "$i" "$TYPE" 2000 &
    wait
    ./$BINARY_FOLDER/jacobi/ParallelSingleTiled "$i" "$TYPE" 2000 &
    wait
done

TYPE=1
for i in {1..8}
do
    #Matrix mult
    ./$BINARY_FOLDER/matrix-multiplication/ParallelNonTiled "$i" "$TYPE" 2000 &
    wait
    ./$BINARY_FOLDER/matrix-multiplication/ParallelTiled "$i" "$TYPE" 2000 &
    wait
    ./$BINARY_FOLDER/matrix-multiplication/ParallelSingleTiled "$i" "$TYPE" 2000 &
    wait
    ./$BINARY_FOLDER/vector-multiplication/ParallelNonTiled "$i" "$TYPE" 2000 &
    wait
    ./$BINARY_FOLDER/vector-multiplication/ParallelTiled "$i" "$TYPE" 2000 &
    wait
    ./$BINARY_FOLDER/vector-multiplication/ParallelSingleTiled "$i" "$TYPE" 2000 &
    wait
    ./$BINARY_FOLDER/jacobi/ParallelNonTiled "$i" "$TYPE" 2000 &
    wait
    ./$BINARY_FOLDER/jacobi/ParallelTiled "$i" "$TYPE" 2000 &
    wait
    ./$BINARY_FOLDER/jacobi/ParallelSingleTiled "$i" "$TYPE" 2000 &
    wait
done




