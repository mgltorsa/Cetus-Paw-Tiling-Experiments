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

N=2000

for i in {1..32}
do
    #Matrix mult
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $BINARY_FOLDER/matrix-multiplication/ParallelNonTiled "$i" $N &
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $BINARY_FOLDER/matrix-multiplication/ParallelTiled "$i" $N &
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $BINARY_FOLDER/matrix-multiplication/ParallelSingleTiled "$i" $N &
    wait
    #vector
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $BINARY_FOLDER/vector-multiplication/ParallelNonTiled "$i" $N &
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $BINARY_FOLDER/vector-multiplication/ParallelTiled "$i" $N &
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $BINARY_FOLDER/vector-multiplication/ParallelSingleTiled "$i" $N &
    wait
    #jacobi
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $BINARY_FOLDER/jacobi/ParallelNonTiled "$i" $N &
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $BINARY_FOLDER/jacobi/ParallelTiled "$i" $N &
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $BINARY_FOLDER/jacobi/ParallelSingleTiled "$i" $N &
    wait
done

