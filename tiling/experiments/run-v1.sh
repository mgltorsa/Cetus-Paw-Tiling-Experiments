#!/bin/bash
#SBATCH --job-name=execution-time-job
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --nodes=1
#SBATCH --exclusive
#SBATCH --mail-type=END,FAIL            # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=mgltorsa@udel.edu   # Where to send mail
#SBATCH --output=jobs.csv    # Standard output and error log
#SBATCH --open-mode=append

echo "setup"
./setup.sh

cd papi/
echo "Running experiments in $PWD"
./compile.sh

for i in {1..5};
do
    ssbatch run.sh
done

echo "Finish experiments in $PWD"

cd ../speed-up/
echo "Running experiments in $PWD"
./compile.sh

for i in {1..5};
do
    ssbatch run.sh
done
echo "Finish experiments in $PWD"

echo "Finished experiments"
