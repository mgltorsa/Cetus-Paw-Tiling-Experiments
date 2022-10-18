#!/bin/bash
#SBATCH --job-name=matrix-mult-job
#SBATCH --ntasks=2
#SBATCH --cpus-per-task=32
#SBATCH --nodes=2
#SBATCH --exclusive
#SBATCH --mail-type=END,FAIL            # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=mgltorsa@udel.edu   # Where to send mail
#SBATCH --output=speed-up.csv    # Standard output and error log
#SBATCH --open-mode=append


#Matrix mult

gcc -g -fopenmp matrix-multiplication/ParallelNonTiled.c -o matrix-multiplication/ParallelNonTiled
gcc -g -fopenmp matrix-multiplication/ParallelTiled.c -o matrix-multiplication/ParallelTiled

for i in {1..32}
do
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive matrix-multiplication/ParallelNonTiled "$i" 2000 &
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive matrix-multiplication/ParallelTiled "$i" 2000 &
    wait
done

#Vector mult
gcc -g -fopenmp vector-multiplication/ParallelNonTiled.c -o vector-multiplication/ParallelNonTiled
gcc -g -fopenmp vector-multiplication/ParallelTiled.c -o vector-multiplication/ParallelTiled

for i in {1..32}
do
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive vector-multiplication/ParallelNonTiled "$i" 2000 &
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive vector-multiplication/ParallelTiled "$i" 2000 &
    wait
done

#Jacobi
gcc -g -fopenmp jacobi/ParallelNonTiled.c -o jacobi/ParallelNonTiled
gcc -g -fopenmp jacobi/ParallelNonTiled.c -o jacobi/ParallelNonTiled


for i in {1..32}
do
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive jacobi/ParallelNonTiled "$i" 2000 &
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive jacobi/ParallelTiled "$i" 2000 &
    wait
done

