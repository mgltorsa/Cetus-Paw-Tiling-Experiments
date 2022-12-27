#!/bin/bash
#SBATCH --job-name=experiments-job
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --nodes=1
#SBATCH --exclusive
#SBATCH --mail-type=END,FAIL            # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=mgltorsa@udel.edu   # Where to send mail
#SBATCH --output=results.csv    # Standard output and error log
#SBATCH --open-mode=append

## Setting up params

. ./setup.sh

for j in {1..10}
do

    cd tileSize
    ./run.sh
    cd ..
    
    cd speed-up
    ./run.sh
    cd ..

    if [[ -n "$PAPI" ]]; then
        cd papi
        ./run.sh
        cd ..
    fi
    
done

