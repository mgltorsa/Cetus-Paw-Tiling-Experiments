#!/bin/bash
#SBATCH --job-name=matrix-mult-job
#SBATCH --ntasks=2
#SBATCH --cpus-per-task=32
#SBATCH --nodes=2
#SBATCH --exclusive
#SBATCH --mail-type=END,FAIL            # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=mgltorsa@udel.edu   # Where to send mail
#SBATCH --output=../results.csv    # Standard output and error log
#SBATCH --open-mode=append

BINARY_FOLDER=bin
#32*1024
CACHE=32768

N=1200

TYPE=0

for i in {1..8}; do
    #Matrix mult
    ./$BINARY_FOLDER/matrix-multiplication/ParallelSingleTiled "$i" "$CACHE" "$TYPE" $N

    ./$BINARY_FOLDER/matrix-multiplication/ParallelNonTiled "$i" "$CACHE" "$TYPE" $N

    ./$BINARY_FOLDER/matrix-multiplication/ParallelTiled "$i" "$CACHE" "$TYPE" $N

    #vector
    ./$BINARY_FOLDER/vector-multiplication/ParallelSingleTiled "$i" "$CACHE" "$TYPE" $N

    ./$BINARY_FOLDER/vector-multiplication/ParallelNonTiled "$i" "$CACHE" "$TYPE" $N

    ./$BINARY_FOLDER/vector-multiplication/ParallelTiled "$i" "$CACHE" "$TYPE" $N
    
    #jacobi
    ./$BINARY_FOLDER/jacobi/ParallelSingleTiled "$i" "$CACHE" "$TYPE" $N

    ./$BINARY_FOLDER/jacobi/ParallelNonTiled "$i" "$CACHE" "$TYPE" $N

    ./$BINARY_FOLDER/jacobi/ParallelTiled "$i" "$CACHE" "$TYPE" $N

done

TYPE=1
for i in {1..8}; do
    #Matrix mult
    ./$BINARY_FOLDER/matrix-multiplication/ParallelNonTiled "$i" "$CACHE" "$TYPE" $N

    ./$BINARY_FOLDER/matrix-multiplication/ParallelTiled "$i" "$CACHE" "$TYPE" $N

    ./$BINARY_FOLDER/matrix-multiplication/ParallelSingleTiled "$i" "$CACHE" "$TYPE" $N

    ./$BINARY_FOLDER/vector-multiplication/ParallelNonTiled "$i" "$CACHE" "$TYPE" $N

    ./$BINARY_FOLDER/vector-multiplication/ParallelTiled "$i" "$CACHE" "$TYPE" $N

    ./$BINARY_FOLDER/vector-multiplication/ParallelSingleTiled "$i" "$CACHE" "$TYPE" $N

    ./$BINARY_FOLDER/jacobi/ParallelNonTiled "$i" "$CACHE" "$TYPE" $N

    ./$BINARY_FOLDER/jacobi/ParallelTiled "$i" "$CACHE" "$TYPE" $N
    
    ./$BINARY_FOLDER/jacobi/ParallelSingleTiled "$i" "$CACHE" "$TYPE" $N
done
