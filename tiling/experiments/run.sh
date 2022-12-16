#!/bin/bash
#SBATCH --job-name=experiments-run
#SBATCH --ntasks=2
#SBATCH --cpus-per-task=32
#SBATCH --nodes=2
#SBATCH --exclusive
#SBATCH --mail-type=END,FAIL            # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=mgltorsa@udel.edu   # Where to send mail
#SBATCH --output=results.csv    # Standard output and error log
#SBATCH --open-mode=append

cd papi/
echo "Running experiments in $PWD"
./compile.sh

for i in {1..5};
do
    ./run.sh
done

echo "Finish experiments in $PWD"

cd ../speed-up/
echo "Running experiments in $PWD"
./compile.sh

for i in {1..5};
do
    ./run.sh
done
echo "Finish experiments in $PWD"

echo "Finished experiments"
