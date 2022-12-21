#!/bin/bash
#SBATCH --job-name=execution-time-job
#SBATCH --ntasks=2
#SBATCH --cpus-per-task=32
#SBATCH --nodes=2
#SBATCH --exclusive
#SBATCH --mail-type=END,FAIL            # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=mgltorsa@udel.edu   # Where to send mail
#SBATCH --output=../results.csv    # Standard output and error log
#SBATCH --open-mode=append
#SBATCH --array=1,4,8,12

BINARY_FOLDER=bin

. ./../setup.sh

STEP=64
for tileSize in $( eval echo {16..$MATRIX_MULT_M..$STEP})
do
    
    #Matrix mult
    srun --nodes=1 --ntasks=1 --cpus-per-task=$SLURM_ARRAY_TASK_ID --exclusive $BINARY_FOLDER/matrix-multiplication/ParallelNonTiled "$i" "$CACHE" $MATRIX_MULT_M $MATRIX_MULT_M $tileSize &
    srun --nodes=1 --ntasks=1 --cpus-per-task=$SLURM_ARRAY_TASK_ID --exclusive $BINARY_FOLDER/matrix-multiplication/ParallelTiled "$i" "$CACHE" $MATRIX_MULT_M $MATRIX_MULT_M $tileSize &
    wait
    srun --nodes=1 --ntasks=1 --cpus-per-task=$SLURM_ARRAY_TASK_ID --exclusive $BINARY_FOLDER/matrix-multiplication/ParallelSingleTiled "$i" "$CACHE" $MATRIX_MULT_M $MATRIX_MULT_M $tileSize &
    # #vector
    # srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $BINARY_FOLDER/vector-multiplication/ParallelNonTiled "$i" "$CACHE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N &
    wait
    # srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $BINARY_FOLDER/vector-multiplication/ParallelTiled "$i" "$CACHE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N &
    # srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $BINARY_FOLDER/vector-multiplication/ParallelSingleTiled "$i" "$CACHE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N &
    # wait
    # #jacobi
    # srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $BINARY_FOLDER/jacobi/ParallelNonTiled "$i" "$CACHE" $JACOBI_M &
    # srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $BINARY_FOLDER/jacobi/ParallelTiled "$i" "$CACHE" $JACOBI_M &
    # wait
    # srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $BINARY_FOLDER/jacobi/ParallelSingleTiled "$i" "$CACHE" $JACOBI_M &
    # wait
    
done
