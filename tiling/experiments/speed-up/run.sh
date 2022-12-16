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
CACHE=16777216 #Caviness CACHE
N=1673

for i in {1..32}
do
    #Matrix mult
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $BINARY_FOLDER/matrix-multiplication/ParallelNonTiled "$i" "$CACHE" $N &
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $BINARY_FOLDER/matrix-multiplication/ParallelTiled "$i" "$CACHE" $N &
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $BINARY_FOLDER/matrix-multiplication/ParallelSingleTiled "$i" "$CACHE" $N &
    wait
    #vector
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $BINARY_FOLDER/vector-multiplication/ParallelNonTiled "$i" "$CACHE" $N &
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $BINARY_FOLDER/vector-multiplication/ParallelTiled "$i" "$CACHE" $N &
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $BINARY_FOLDER/vector-multiplication/ParallelSingleTiled "$i" "$CACHE" $N &
    wait
    #jacobi
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $BINARY_FOLDER/jacobi/ParallelNonTiled "$i" "$CACHE" $N &
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $BINARY_FOLDER/jacobi/ParallelTiled "$i" "$CACHE" $N &
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $BINARY_FOLDER/jacobi/ParallelSingleTiled "$i" "$CACHE" $N &
    wait
done

