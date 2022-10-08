#!/bin/bash
#SBATCH --job-name=matrix-mult-sup-job
#SBATCH --array=2-32
#SBATCH --exclusive
#SBATCH --cpus-per-task=32
#SBATCH --mail-type=END,FAIL            # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=mgltorsa@udel.edu   # Where to send mail
#SBATCH --output=speed-up.csv    # Standard output and error log
#SBATCH --open-mode=append
#SBATCH --exclusive

./speed-up/ParallelNonTiled "$SLURM_ARRAY_TASK_ID"
./speed-up/ParallelTiled "$SLURM_ARRAY_TASK_ID"