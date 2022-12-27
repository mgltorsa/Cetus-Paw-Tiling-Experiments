#!/bin/bash
#SBATCH --job-name=execution-time-job
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --nodes=1
#SBATCH --exclusive
#SBATCH --mail-type=END,FAIL            # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=mgltorsa@udel.edu   # Where to send mail
#SBATCH --output=../results.csv    # Standard output and error log
#SBATCH --open-mode=append
#SBATCH --array=1,4,8,12%1

BINARY_FOLDER=bin
LOOP_INTER_BINARY_FOLDER=bin/loop-inter

. ./../setup.sh

STEP=64
for tileSize in $( eval echo {16..$MATRIX_MULT_M..$STEP})
do
    
    #Matrix mult
    srun --nodes=1 --ntasks=1 --cpus-per-task=$SLURM_ARRAY_TASK_ID --exclusive $BINARY_FOLDER/matrix-multiplication/ParallelNonTiled "$SLURM_ARRAY_TASK_ID" "$CACHE" $MATRIX_MULT_M $MATRIX_MULT_M $tileSize
    srun --nodes=1 --ntasks=1 --cpus-per-task=$SLURM_ARRAY_TASK_ID --exclusive $BINARY_FOLDER/matrix-multiplication/ParallelTiled "$SLURM_ARRAY_TASK_ID" "$CACHE" $MATRIX_MULT_M $MATRIX_MULT_M $tileSize
    srun --nodes=1 --ntasks=1 --cpus-per-task=$SLURM_ARRAY_TASK_ID --exclusive $BINARY_FOLDER/matrix-multiplication/ParallelSingleTiled "$SLURM_ARRAY_TASK_ID" "$CACHE" $MATRIX_MULT_M $MATRIX_MULT_M $tileSize
    #vector
    srun --nodes=1 --ntasks=1 --cpus-per-task=$SLURM_ARRAY_TASK_ID --exclusive $BINARY_FOLDER/vector-multiplication/ParallelNonTiled "$SLURM_ARRAY_TASK_ID" "$CACHE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N $tileSize
    srun --nodes=1 --ntasks=1 --cpus-per-task=$SLURM_ARRAY_TASK_ID --exclusive $BINARY_FOLDER/vector-multiplication/ParallelTiled "$SLURM_ARRAY_TASK_ID" "$CACHE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N $tileSize
    srun --nodes=1 --ntasks=1 --cpus-per-task=$SLURM_ARRAY_TASK_ID --exclusive $BINARY_FOLDER/vector-multiplication/ParallelSingleTiled "$SLURM_ARRAY_TASK_ID" "$CACHE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N $tileSize
    #jacobi
    srun --nodes=1 --ntasks=1 --cpus-per-task=$SLURM_ARRAY_TASK_ID --exclusive $BINARY_FOLDER/jacobi/ParallelNonTiled "$SLURM_ARRAY_TASK_ID" "$CACHE" $JACOBI_M $tileSize
    srun --nodes=1 --ntasks=1 --cpus-per-task=$SLURM_ARRAY_TASK_ID --exclusive $BINARY_FOLDER/jacobi/ParallelTiled "$SLURM_ARRAY_TASK_ID" "$CACHE" $JACOBI_M $tileSize
    srun --nodes=1 --ntasks=1 --cpus-per-task=$SLURM_ARRAY_TASK_ID --exclusive $BINARY_FOLDER/jacobi/ParallelSingleTiled "$SLURM_ARRAY_TASK_ID" "$CACHE" $JACOBI_M $tileSize

    #Loop interchange
    #LP-Matrix mult
    srun --nodes=1 --ntasks=1 --cpus-per-task=$SLURM_ARRAY_TASK_ID --exclusive $LOOP_INTER_BINARY_FOLDER/matrix-multiplication/ParallelNonTiled "$SLURM_ARRAY_TASK_ID" "$CACHE" $MATRIX_MULT_M $MATRIX_MULT_M $tileSize
    srun --nodes=1 --ntasks=1 --cpus-per-task=$SLURM_ARRAY_TASK_ID --exclusive $LOOP_INTER_BINARY_FOLDER/matrix-multiplication/ParallelTiled "$SLURM_ARRAY_TASK_ID" "$CACHE" $MATRIX_MULT_M $MATRIX_MULT_M $tileSize
    srun --nodes=1 --ntasks=1 --cpus-per-task=$SLURM_ARRAY_TASK_ID --exclusive $LOOP_INTER_BINARY_FOLDER/matrix-multiplication/ParallelSingleTiled "$SLURM_ARRAY_TASK_ID" "$CACHE" $MATRIX_MULT_M $MATRIX_MULT_M $tileSize
    #LP-vector
    srun --nodes=1 --ntasks=1 --cpus-per-task=$SLURM_ARRAY_TASK_ID --exclusive $LOOP_INTER_BINARY_FOLDER/vector-multiplication/ParallelNonTiled "$SLURM_ARRAY_TASK_ID" "$CACHE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N $tileSize
    srun --nodes=1 --ntasks=1 --cpus-per-task=$SLURM_ARRAY_TASK_ID --exclusive $LOOP_INTER_BINARY_FOLDER/vector-multiplication/ParallelTiled "$SLURM_ARRAY_TASK_ID" "$CACHE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N $tileSize
    srun --nodes=1 --ntasks=1 --cpus-per-task=$SLURM_ARRAY_TASK_ID --exclusive $LOOP_INTER_BINARY_FOLDER/vector-multiplication/ParallelSingleTiled "$SLURM_ARRAY_TASK_ID" "$CACHE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N $tileSize
    #LP-jacobi
    srun --nodes=1 --ntasks=1 --cpus-per-task=$SLURM_ARRAY_TASK_ID --exclusive $LOOP_INTER_BINARY_FOLDER/jacobi/ParallelNonTiled "$SLURM_ARRAY_TASK_ID" "$CACHE" $JACOBI_M $tileSize
    srun --nodes=1 --ntasks=1 --cpus-per-task=$SLURM_ARRAY_TASK_ID --exclusive $LOOP_INTER_BINARY_FOLDER/jacobi/ParallelTiled "$SLURM_ARRAY_TASK_ID" "$CACHE" $JACOBI_M $tileSize
    srun --nodes=1 --ntasks=1 --cpus-per-task=$SLURM_ARRAY_TASK_ID --exclusive $LOOP_INTER_BINARY_FOLDER/jacobi/ParallelSingleTiled "$SLURM_ARRAY_TASK_ID" "$CACHE" $JACOBI_M $tileSize
done
