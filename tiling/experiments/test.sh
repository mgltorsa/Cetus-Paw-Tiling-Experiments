#!/bin/bash
#SBATCH --ntasks=1
#SBATCH --nodes=2
#SBATCH --array=1-5%1
#SBATCH --output=test.log
#SBATCH --open-mode=append

. ./setup.sh

# for i in {1..3}
# do
./test-p1.sh
./test-p2.sh
#echo "RUNNING iter-$i TH-$SLURM_ARRAY_TASK_ID"
#echo "1st sleep iter-$i TH-$SLURM_ARRAY_TASK_ID"
#srun sleep 30
#srun --nodes=1 --ntasks=1 --cpus-per-task=4 --exclusive ParallelNonTiled 4 1600 2700 2700 200
#echo "2nd sleep iter-$i TH-$SLURM_ARRAY_TASK_ID"
#srun --nodes=1 --ntasks=1 --cpus-per-task=4 --exclusive ParallelSingleTiled 4 1600 2700 2700 200
#srun sleep 35
#echo "Finished iter-$i TH-$SLURM_ARRAY_TASK_ID"
# done
