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
#SBATCH --array=16-2016:64%1

BINARY_FOLDER=bin
LOOP_INTER_BINARY_FOLDER=bin/loop-inter

. ./../setup.sh


TILE_SIZE=$SLURM_ARRAY_TASK_ID
#STEP=64
#for TILE_SIZE in $( eval echo {16..$MATRIX_MULT_M..$STEP})
#do
for i in {1..12..3}
do
    CORES=$i

    #Matrix mult
    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $BINARY_FOLDER/matrix-multiplication/ParallelNonTiled "$CORES" "$CACHE" $MATRIX_MULT_M $MATRIX_MULT_M $TILE_SIZE
    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $BINARY_FOLDER/matrix-multiplication/ParallelTiled "$CORES" "$CACHE" $MATRIX_MULT_M $MATRIX_MULT_M $TILE_SIZE
    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $BINARY_FOLDER/matrix-multiplication/ParallelSingleTiled "$CORES" "$CACHE" $MATRIX_MULT_M $MATRIX_MULT_M $TILE_SIZE
    #vector
    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $BINARY_FOLDER/vector-multiplication/ParallelNonTiled "$CORES" "$CACHE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N $TILE_SIZE
    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $BINARY_FOLDER/vector-multiplication/ParallelTiled "$CORES" "$CACHE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N $TILE_SIZE
    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $BINARY_FOLDER/vector-multiplication/ParallelSingleTiled "$CORES" "$CACHE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N $TILE_SIZE
    #jacobi
    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $BINARY_FOLDER/jacobi/ParallelNonTiled "$CORES" "$CACHE" $JACOBI_M $TILE_SIZE
    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $BINARY_FOLDER/jacobi/ParallelTiled "$CORES" "$CACHE" $JACOBI_M $TILE_SIZE
    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $BINARY_FOLDER/jacobi/ParallelSingleTiled "$CORES" "$CACHE" $JACOBI_M $TILE_SIZE

    #Loop interchange
    #LP-Matrix mult
    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $LOOP_INTER_BINARY_FOLDER/matrix-multiplication/ParallelNonTiled "$CORES" "$CACHE" $MATRIX_MULT_M $MATRIX_MULT_M $TILE_SIZE
    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $LOOP_INTER_BINARY_FOLDER/matrix-multiplication/ParallelTiled "$CORES" "$CACHE" $MATRIX_MULT_M $MATRIX_MULT_M $TILE_SIZE
    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $LOOP_INTER_BINARY_FOLDER/matrix-multiplication/ParallelSingleTiled "$CORES" "$CACHE" $MATRIX_MULT_M $MATRIX_MULT_M $TILE_SIZE
    #LP-vector
    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $LOOP_INTER_BINARY_FOLDER/vector-multiplication/ParallelNonTiled "$CORES" "$CACHE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N $TILE_SIZE
    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $LOOP_INTER_BINARY_FOLDER/vector-multiplication/ParallelTiled "$CORES" "$CACHE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N $TILE_SIZE
    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $LOOP_INTER_BINARY_FOLDER/vector-multiplication/ParallelSingleTiled "$CORES" "$CACHE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N $TILE_SIZE
    #LP-jacobi
    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $LOOP_INTER_BINARY_FOLDER/jacobi/ParallelNonTiled "$CORES" "$CACHE" $JACOBI_M $TILE_SIZE
    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $LOOP_INTER_BINARY_FOLDER/jacobi/ParallelTiled "$CORES" "$CACHE" $JACOBI_M $TILE_SIZE
    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $LOOP_INTER_BINARY_FOLDER/jacobi/ParallelSingleTiled "$CORES" "$CACHE" $JACOBI_M $TILE_SIZE
done
