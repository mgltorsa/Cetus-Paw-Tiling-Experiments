#!/bin/bash

BINARY_FOLDER=bin
LOOP_INTER_BINARY_FOLDER=bin/loop-inter

TYPE=0


for i in {1..8}; do
    #Matrix mult
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $BINARY_FOLDER/matrix-multiplication/ParallelSingleTiled "$i" "$CACHE" "$TYPE" $MATRIX_MULT_M
    
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $BINARY_FOLDER/matrix-multiplication/ParallelTiled "$i" "$CACHE" "$TYPE" $MATRIX_MULT_M

    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $BINARY_FOLDER/matrix-multiplication/ParallelNonTiled "$i" "$CACHE" "$TYPE" $MATRIX_MULT_M
    
    #vector
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $BINARY_FOLDER/vector-multiplication/ParallelSingleTiled "$i" "$CACHE" "$TYPE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N
    
    
    
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $BINARY_FOLDER/vector-multiplication/ParallelNonTiled "$i" "$CACHE" "$TYPE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N
    
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $BINARY_FOLDER/vector-multiplication/ParallelTiled "$i" "$CACHE" "$TYPE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N

    
    
    #jacobi
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $BINARY_FOLDER/jacobi/ParallelTiled "$i" "$CACHE" "$TYPE" $JACOBI_M
    
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $BINARY_FOLDER/jacobi/ParallelSingleTiled "$i" "$CACHE" "$TYPE" $JACOBI_M
      
    

    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $BINARY_FOLDER/jacobi/ParallelNonTiled "$i" "$CACHE" "$TYPE" $JACOBI_M
    
    #loop-inter (LP)
    
    #LP-Matrix mult
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $LOOP_INTER_BINARY_FOLDER/matrix-multiplication/ParallelSingleTiled "$i" "$CACHE" "$TYPE" $MATRIX_MULT_M
    
    
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $LOOP_INTER_BINARY_FOLDER/matrix-multiplication/ParallelTiled "$i" "$CACHE" "$TYPE" $MATRIX_MULT_M
    

    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $LOOP_INTER_BINARY_FOLDER/matrix-multiplication/ParallelNonTiled "$i" "$CACHE" "$TYPE" $MATRIX_MULT_M
    
    
    
    #LP-vector
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $LOOP_INTER_BINARY_FOLDER/vector-multiplication/ParallelSingleTiled "$i" "$CACHE" "$TYPE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N
    
    
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $LOOP_INTER_BINARY_FOLDER/vector-multiplication/ParallelNonTiled "$i" "$CACHE" "$TYPE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N
    
    
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $LOOP_INTER_BINARY_FOLDER/vector-multiplication/ParallelTiled "$i" "$CACHE" "$TYPE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N

    #LP-jacobi
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $LOOP_INTER_BINARY_FOLDER/jacobi/ParallelTiled "$i" "$CACHE" "$TYPE" $JACOBI_M
    
    
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $LOOP_INTER_BINARY_FOLDER/jacobi/ParallelSingleTiled "$i" "$CACHE" "$TYPE" $JACOBI_M
      
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $LOOP_INTER_BINARY_FOLDER/jacobi/ParallelNonTiled "$i" "$CACHE" "$TYPE" $JACOBI_M
    
done

TYPE=1
for i in {1..8}; do
    #Matrix mult
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $BINARY_FOLDER/matrix-multiplication/ParallelNonTiled "$i" "$CACHE" "$TYPE" $MATRIX_MULT_M
    
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $BINARY_FOLDER/matrix-multiplication/ParallelTiled "$i" "$CACHE" "$TYPE" $MATRIX_MULT_M
    
    
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $BINARY_FOLDER/matrix-multiplication/ParallelSingleTiled "$i" "$CACHE" "$TYPE" $MATRIX_MULT_M
    
    #vector
    
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $BINARY_FOLDER/vector-multiplication/ParallelNonTiled "$i" "$CACHE" "$TYPE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N
    
    
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $BINARY_FOLDER/vector-multiplication/ParallelTiled "$i" "$CACHE" "$TYPE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N
    
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $BINARY_FOLDER/vector-multiplication/ParallelSingleTiled "$i" "$CACHE" "$TYPE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N
    
    
    
    #jacobi
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $BINARY_FOLDER/jacobi/ParallelNonTiled "$i" "$CACHE" "$TYPE" $JACOBI_M
    
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $BINARY_FOLDER/jacobi/ParallelTiled "$i" "$CACHE" "$TYPE" $JACOBI_M
    
    
    
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $BINARY_FOLDER/jacobi/ParallelSingleTiled "$i" "$CACHE" "$TYPE" $JACOBI_M
    
    #loop-inter (LP)
    
    #LP-Matrix mult
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $LOOP_INTER_BINARY_FOLDER/matrix-multiplication/ParallelSingleTiled "$i" "$CACHE" "$TYPE" $MATRIX_MULT_M
    
    
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $LOOP_INTER_BINARY_FOLDER/matrix-multiplication/ParallelTiled "$i" "$CACHE" "$TYPE" $MATRIX_MULT_M
    

    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $LOOP_INTER_BINARY_FOLDER/matrix-multiplication/ParallelNonTiled "$i" "$CACHE" "$TYPE" $MATRIX_MULT_M
    
    
    
    #LP-vector
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $LOOP_INTER_BINARY_FOLDER/vector-multiplication/ParallelSingleTiled "$i" "$CACHE" "$TYPE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N
    
    
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $LOOP_INTER_BINARY_FOLDER/vector-multiplication/ParallelNonTiled "$i" "$CACHE" "$TYPE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N
    
    
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $LOOP_INTER_BINARY_FOLDER/vector-multiplication/ParallelTiled "$i" "$CACHE" "$TYPE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N

    #LP-jacobi
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $LOOP_INTER_BINARY_FOLDER/jacobi/ParallelTiled "$i" "$CACHE" "$TYPE" $JACOBI_M
    
    
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $LOOP_INTER_BINARY_FOLDER/jacobi/ParallelSingleTiled "$i" "$CACHE" "$TYPE" $JACOBI_M
      
    srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $LOOP_INTER_BINARY_FOLDER/jacobi/ParallelNonTiled "$i" "$CACHE" "$TYPE" $JACOBI_M
    
done
