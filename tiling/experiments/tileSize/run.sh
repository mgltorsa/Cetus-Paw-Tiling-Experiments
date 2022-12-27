#!/bin/bash

BINARY_FOLDER=bin
LOOP_INTER_BINARY_FOLDER=bin/loop-inter


STEP=64
for tileSize in $( eval echo {16..$MATRIX_MULT_M..$STEP})
do
    for i in {1..8..3}
    do
        #Matrix mult
        srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $BINARY_FOLDER/matrix-multiplication/ParallelNonTiled "$i" "$CACHE" $MATRIX_MULT_M $MATRIX_MULT_M $tileSize
        srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $BINARY_FOLDER/matrix-multiplication/ParallelTiled "$i" "$CACHE" $MATRIX_MULT_M $MATRIX_MULT_M $tileSize
        srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $BINARY_FOLDER/matrix-multiplication/ParallelSingleTiled "$i" "$CACHE" $MATRIX_MULT_M $MATRIX_MULT_M $tileSize
        #vector
        srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $BINARY_FOLDER/vector-multiplication/ParallelNonTiled "$i" "$CACHE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N
        srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $BINARY_FOLDER/vector-multiplication/ParallelTiled "$i" "$CACHE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N
        srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $BINARY_FOLDER/vector-multiplication/ParallelSingleTiled "$i" "$CACHE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N
        #jacobi
        srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $BINARY_FOLDER/jacobi/ParallelNonTiled "$i" "$CACHE" $JACOBI_M
        srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $BINARY_FOLDER/jacobi/ParallelTiled "$i" "$CACHE" $JACOBI_M
        srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $BINARY_FOLDER/jacobi/ParallelSingleTiled "$i" "$CACHE" $JACOBI_M
        
        #Loop interchange
        #LP-Matrix mult
        srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $LOOP_INTER_BINARY_FOLDER/matrix-multiplication/ParallelNonTiled "$i" "$CACHE" $MATRIX_MULT_M $MATRIX_MULT_M $tileSize
        srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $LOOP_INTER_BINARY_FOLDER/matrix-multiplication/ParallelTiled "$i" "$CACHE" $MATRIX_MULT_M $MATRIX_MULT_M $tileSize
        srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $LOOP_INTER_BINARY_FOLDER/matrix-multiplication/ParallelSingleTiled "$i" "$CACHE" $MATRIX_MULT_M $MATRIX_MULT_M $tileSize
        #LP-vector
        srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $LOOP_INTER_BINARY_FOLDER/vector-multiplication/ParallelNonTiled "$i" "$CACHE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N
        srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $LOOP_INTER_BINARY_FOLDER/vector-multiplication/ParallelTiled "$i" "$CACHE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N
        srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $LOOP_INTER_BINARY_FOLDER/vector-multiplication/ParallelSingleTiled "$i" "$CACHE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N
        #LP-jacobi
        srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $LOOP_INTER_BINARY_FOLDER/jacobi/ParallelNonTiled "$i" "$CACHE" $JACOBI_M
        srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $LOOP_INTER_BINARY_FOLDER/jacobi/ParallelTiled "$i" "$CACHE" $JACOBI_M
        srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $LOOP_INTER_BINARY_FOLDER/jacobi/ParallelSingleTiled "$i" "$CACHE" $JACOBI_M
    done
done
