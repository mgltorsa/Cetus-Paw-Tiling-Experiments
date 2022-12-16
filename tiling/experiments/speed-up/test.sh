#!/bin/bash
#SBATCH --job-name=execution-time-job
#SBATCH --ntasks=2
#SBATCH --cpus-per-task=32
#SBATCH --nodes=2
#SBATCH --exclusive
#SBATCH --mail-type=END,FAIL            # Mail events (NONE, BEGIN, END, FAIL, $
#SBATCH --mail-user=mgltorsa@udel.edu   # Where to send mail
#SBATCH --output=job_test    # Standard output and error log
#SBATCH --open-mode=append

. ./../setup.sh

echo "$CACHE"
