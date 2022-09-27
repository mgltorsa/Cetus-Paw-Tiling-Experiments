#!/bin/bash
#SBATCH --job-name=matrix-mult-sup-job
#SBATCH --ntasks-per-core=1 
#SBATCH --ntasks=4
#SBATCH --cpus-per-task=1 
#SBATCH --mail-type=END,FAIL            # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=mgltorsa@udel.edu   # Where to send mail
#SBATCH --output=array_%A-%a.log    # Standard output and error log

echo This is task $SLURM_ARRAY_TASK_ID

export OMP_NUM_THREADS=$SLURM_ARRAY_TASK_ID

./ParallelNonTiled >> output