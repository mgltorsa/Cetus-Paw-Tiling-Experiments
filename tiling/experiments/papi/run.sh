#!/bin/bash
#SBATCH --job-name=papi-experiments
#SBATCH --ntasks=2
#SBATCH --cpus-per-task=32
#SBATCH --nodes=2
#SBATCH --exclusive
#SBATCH --mail-type=END,FAIL            # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=mgltorsa@udel.edu   # Where to send mail
#SBATCH --output=../results.csv    # Standard output and error log
#SBATCH --open-mode=append

BINARY_FOLDER=bin

. ./../setup.sh

TYPE=0


for i in {1..8}; do
    #Matrix mult
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $BINARY_FOLDER/matrix-multiplication/ParallelSingleTiled "$i" "$CACHE" "$TYPE" $MATRIX_MULT_M &
    
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $BINARY_FOLDER/matrix-multiplication/ParallelTiled "$i" "$CACHE" "$TYPE" $MATRIX_MULT_M &
    
    wait

    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $BINARY_FOLDER/matrix-multiplication/ParallelNonTiled "$i" "$CACHE" "$TYPE" $MATRIX_MULT_M &
    
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $BINARY_FOLDER/vector-multiplication/ParallelSingleTiled "$i" "$CACHE" "$TYPE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N &
    
    wait
    
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $BINARY_FOLDER/vector-multiplication/ParallelNonTiled "$i" "$CACHE" "$TYPE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N &
    
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $BINARY_FOLDER/vector-multiplication/ParallelTiled "$i" "$CACHE" "$TYPE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N &

    wait
    
    
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $BINARY_FOLDER/jacobi/ParallelTiled "$i" "$CACHE" "$TYPE" $JACOBI_M &
    
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $BINARY_FOLDER/jacobi/ParallelSingleTiled "$i" "$CACHE" "$TYPE" $JACOBI_M &
      
    wait

    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $BINARY_FOLDER/jacobi/ParallelNonTiled "$i" "$CACHE" "$TYPE" $JACOBI_M &
    
    wait
    
done

TYPE=1
for i in {1..8}; do
    #Matrix mult
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $BINARY_FOLDER/matrix-multiplication/ParallelNonTiled "$i" "$CACHE" "$TYPE" $MATRIX_MULT_M &
    
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $BINARY_FOLDER/matrix-multiplication/ParallelTiled "$i" "$CACHE" "$TYPE" $MATRIX_MULT_M &
    wait
    
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $BINARY_FOLDER/matrix-multiplication/ParallelSingleTiled "$i" "$CACHE" "$TYPE" $MATRIX_MULT_M &
    
    
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $BINARY_FOLDER/vector-multiplication/ParallelNonTiled "$i" "$CACHE" "$TYPE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N &
    wait
    
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $BINARY_FOLDER/vector-multiplication/ParallelTiled "$i" "$CACHE" "$TYPE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N &
    
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $BINARY_FOLDER/vector-multiplication/ParallelSingleTiled "$i" "$CACHE" "$TYPE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N &
    
    wait
    
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $BINARY_FOLDER/jacobi/ParallelNonTiled "$i" "$CACHE" "$TYPE" $JACOBI_M &
    
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $BINARY_FOLDER/jacobi/ParallelTiled "$i" "$CACHE" "$TYPE" $JACOBI_M &
    
    wait
    
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $BINARY_FOLDER/jacobi/ParallelSingleTiled "$i" "$CACHE" "$TYPE" $JACOBI_M &
    
    wait
done
