#!/bin/bash
#SBATCH --job-name=papi-experiments-job
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=32
#SBATCH --nodes=4
#SBATCH --array=16-2016:64%4
#SBATCH --exclusive
#SBATCH --mail-type=END,FAIL            # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=mgltorsa@udel.edu   # Where to send mail

BINARY_FOLDER=bin
LOOP_INTER_BINARY_FOLDER=bin/loop-inter

. ./../setup.sh


TILE_SIZE=$SLURM_ARRAY_TASK_ID

TYPE=0


for i in {1..12..3}; 
do
    CORES=$CORES
    #Matrix mult
    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $BINARY_FOLDER/matrix-multiplication/ParallelSingleTiled "$CORES" "$CACHE" "$TYPE" $MATRIX_MULT_M $MATRIX_MULT_M $TILE_SIZE
    wait
    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $BINARY_FOLDER/matrix-multiplication/ParallelTiled "$CORES" "$CACHE" "$TYPE" $MATRIX_MULT_M $MATRIX_MULT_M $TILE_SIZE
    wait
    

    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $BINARY_FOLDER/matrix-multiplication/ParallelNonTiled "$CORES" "$CACHE" "$TYPE" $MATRIX_MULT_M $MATRIX_MULT_M $TILE_SIZE
    wait
    #vector
    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $BINARY_FOLDER/vector-multiplication/ParallelSingleTiled "$CORES" "$CACHE" "$TYPE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N $TILE_SIZE
    wait
    
    
    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $BINARY_FOLDER/vector-multiplication/ParallelNonTiled "$CORES" "$CACHE" "$TYPE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N $TILE_SIZE
    wait
    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $BINARY_FOLDER/vector-multiplication/ParallelTiled "$CORES" "$CACHE" "$TYPE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N $TILE_SIZE
    wait
    
    
    #jacobi
    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $BINARY_FOLDER/jacobi/ParallelTiled "$CORES" "$CACHE" "$TYPE" $JACOBI_M $TILE_SIZE
    wait
    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $BINARY_FOLDER/jacobi/ParallelSingleTiled "$CORES" "$CACHE" "$TYPE" $JACOBI_M $TILE_SIZE
    wait
    

    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $BINARY_FOLDER/jacobi/ParallelNonTiled "$CORES" "$CACHE" "$TYPE" $JACOBI_M $TILE_SIZE
    wait
    #loop-inter (LP)
    
    #LP-Matrix mult
    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $LOOP_INTER_BINARY_FOLDER/matrix-multiplication/ParallelSingleTiled "$CORES" "$CACHE" "$TYPE" $MATRIX_MULT_M $MATRIX_MULT_M $TILE_SIZE
    wait
    
    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $LOOP_INTER_BINARY_FOLDER/matrix-multiplication/ParallelTiled "$CORES" "$CACHE" "$TYPE" $MATRIX_MULT_M $MATRIX_MULT_M $TILE_SIZE
    wait

    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $LOOP_INTER_BINARY_FOLDER/matrix-multiplication/ParallelNonTiled "$CORES" "$CACHE" "$TYPE" $MATRIX_MULT_M $MATRIX_MULT_M $TILE_SIZE
    wait
    
    
    #LP-vector
    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $LOOP_INTER_BINARY_FOLDER/vector-multiplication/ParallelSingleTiled "$CORES" "$CACHE" "$TYPE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N $TILE_SIZE
    wait
    
    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $LOOP_INTER_BINARY_FOLDER/vector-multiplication/ParallelNonTiled "$CORES" "$CACHE" "$TYPE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N $TILE_SIZE
    wait
    
    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $LOOP_INTER_BINARY_FOLDER/vector-multiplication/ParallelTiled "$CORES" "$CACHE" "$TYPE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N $TILE_SIZE
    wait
    #LP-jacobi
    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $LOOP_INTER_BINARY_FOLDER/jacobi/ParallelTiled "$CORES" "$CACHE" "$TYPE" $JACOBI_M $TILE_SIZE
    wait
    
    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $LOOP_INTER_BINARY_FOLDER/jacobi/ParallelSingleTiled "$CORES" "$CACHE" "$TYPE" $JACOBI_M $TILE_SIZE
    wait
    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $LOOP_INTER_BINARY_FOLDER/jacobi/ParallelNonTiled "$CORES" "$CACHE" "$TYPE" $JACOBI_M $TILE_SIZE
    wait
done

TYPE=1
for i in {1..12..3}; do
    #Matrix mult
    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $BINARY_FOLDER/matrix-multiplication/ParallelNonTiled "$CORES" "$CACHE" "$TYPE" $MATRIX_MULT_M $MATRIX_MULT_M $TILE_SIZE
    wait
    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $BINARY_FOLDER/matrix-multiplication/ParallelTiled "$CORES" "$CACHE" "$TYPE" $MATRIX_MULT_M $MATRIX_MULT_M $TILE_SIZE
    wait
    
    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $BINARY_FOLDER/matrix-multiplication/ParallelSingleTiled "$CORES" "$CACHE" "$TYPE" $MATRIX_MULT_M $MATRIX_MULT_M $TILE_SIZE
    wait
    #vector
    
    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $BINARY_FOLDER/vector-multiplication/ParallelNonTiled "$CORES" "$CACHE" "$TYPE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N $TILE_SIZE
    wait
    
    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $BINARY_FOLDER/vector-multiplication/ParallelTiled "$CORES" "$CACHE" "$TYPE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N $TILE_SIZE
    wait
    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $BINARY_FOLDER/vector-multiplication/ParallelSingleTiled "$CORES" "$CACHE" "$TYPE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N $TILE_SIZE
    wait
    
    
    #jacobi
    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $BINARY_FOLDER/jacobi/ParallelNonTiled "$CORES" "$CACHE" "$TYPE" $JACOBI_M $TILE_SIZE
    wait
    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $BINARY_FOLDER/jacobi/ParallelTiled "$CORES" "$CACHE" "$TYPE" $JACOBI_M $TILE_SIZE
    wait
    
    
    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $BINARY_FOLDER/jacobi/ParallelSingleTiled "$CORES" "$CACHE" "$TYPE" $JACOBI_M $TILE_SIZE
    wait
    #loop-inter (LP)
    
    #LP-Matrix mult
    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $LOOP_INTER_BINARY_FOLDER/matrix-multiplication/ParallelSingleTiled "$CORES" "$CACHE" "$TYPE" $MATRIX_MULT_M $MATRIX_MULT_M $TILE_SIZE
    wait
    
    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $LOOP_INTER_BINARY_FOLDER/matrix-multiplication/ParallelTiled "$CORES" "$CACHE" "$TYPE" $MATRIX_MULT_M $MATRIX_MULT_M $TILE_SIZE
    wait

    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $LOOP_INTER_BINARY_FOLDER/matrix-multiplication/ParallelNonTiled "$CORES" "$CACHE" "$TYPE" $MATRIX_MULT_M $MATRIX_MULT_M $TILE_SIZE
    wait
    
    
    #LP-vector
    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $LOOP_INTER_BINARY_FOLDER/vector-multiplication/ParallelSingleTiled "$CORES" "$CACHE" "$TYPE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N $TILE_SIZE
    wait
    
    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $LOOP_INTER_BINARY_FOLDER/vector-multiplication/ParallelNonTiled "$CORES" "$CACHE" "$TYPE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N $TILE_SIZE
    wait
    
    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $LOOP_INTER_BINARY_FOLDER/vector-multiplication/ParallelTiled "$CORES" "$CACHE" "$TYPE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N $TILE_SIZE
    wait
    #LP-jacobi
    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $LOOP_INTER_BINARY_FOLDER/jacobi/ParallelTiled "$CORES" "$CACHE" "$TYPE" $JACOBI_M $TILE_SIZE
    wait
    
    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $LOOP_INTER_BINARY_FOLDER/jacobi/ParallelSingleTiled "$CORES" "$CACHE" "$TYPE" $JACOBI_M $TILE_SIZE
    wait
    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $LOOP_INTER_BINARY_FOLDER/jacobi/ParallelNonTiled "$CORES" "$CACHE" "$TYPE" $JACOBI_M $TILE_SIZE
    wait
done
