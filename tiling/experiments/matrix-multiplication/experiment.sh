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


for i in {1..32}
do
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive speed-up/ParallelNonTiled "$i" 1000 &
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive speed-up/ParallelTiled "$i" 1000 &
    wait
done

