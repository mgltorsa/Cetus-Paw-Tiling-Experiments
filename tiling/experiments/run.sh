#!/bin/bash
#SBATCH --job-name=execution-time-job
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --nodes=1
#SBATCH --exclusive
#SBATCH --mail-type=END,FAIL            # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=mgltorsa@udel.edu   # Where to send mail
#SBATCH --output=results.csv    # Standard output and error log
#SBATCH --open-mode=append

EXECUTION_TIME_PAPI_BINARY_FOLDER=speed-up/bin
PAPI_BINARY_FOLDER=papi/bin
CAVINESS_CACHE=47185920
DARWIN_CACHE=16777216
CACHE=$DARWIN_CACHE 
PAPI=


## Setting up params

MATRIX_MULT_M=1673
MATRIX_VECTOR_MULT_M=2500
MATRIX_VECTOR_MULT_N=3353
JACOBI_M=2897

for j in {1..5}
do
    
    for i in {1..32}
    do
        #Matrix mult
        srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $EXECUTION_TIME_PAPI_BINARY_FOLDER/matrix-multiplication/ParallelNonTiled "$i" "$CACHE" $MATRIX_MULT_M &
        wait
        srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $EXECUTION_TIME_PAPI_BINARY_FOLDER/matrix-multiplication/ParallelTiled "$i" "$CACHE" $MATRIX_MULT_M &
        wait
        srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $EXECUTION_TIME_PAPI_BINARY_FOLDER/matrix-multiplication/ParallelSingleTiled "$i" "$CACHE" $MATRIX_MULT_M &
        wait
        #vector
        srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $EXECUTION_TIME_PAPI_BINARY_FOLDER/vector-multiplication/ParallelNonTiled "$i" "$CACHE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N &
        wait
        srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $EXECUTION_TIME_PAPI_BINARY_FOLDER/vector-multiplication/ParallelTiled "$i" "$CACHE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N &
        wait
        srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $EXECUTION_TIME_PAPI_BINARY_FOLDER/vector-multiplication/ParallelSingleTiled "$i" "$CACHE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N &
        wait
        #jacobi
        srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $EXECUTION_TIME_PAPI_BINARY_FOLDER/jacobi/ParallelNonTiled "$i" "$CACHE" $JACOBI_M &
        wait
        srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $EXECUTION_TIME_PAPI_BINARY_FOLDER/jacobi/ParallelTiled "$i" "$CACHE" $JACOBI_M &
        wait
        srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $EXECUTION_TIME_PAPI_BINARY_FOLDER/jacobi/ParallelSingleTiled "$i" "$CACHE" $JACOBI_M &
        wait
    done
    
    
    if [[ -n "$PAPI" ]]; then
        TYPE=0
        
        for i in {1..32}; do
            #Matrix mult
            srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $PAPI_BINARY_FOLDER/matrix-multiplication/ParallelSingleTiled "$i" "$CACHE" "$TYPE" $MATRIX_MULT_M &
            wait

            srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $PAPI_BINARY_FOLDER/matrix-multiplication/ParallelNonTiled "$i" "$CACHE" "$TYPE" $MATRIX_MULT_M &
            wait
            
            srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $PAPI_BINARY_FOLDER/matrix-multiplication/ParallelTiled "$i" "$CACHE" "$TYPE" $MATRIX_MULT_M &
                        
            wait
            
            
            srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $PAPI_BINARY_FOLDER/vector-multiplication/ParallelSingleTiled "$i" "$CACHE" "$TYPE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N &

            wait

            srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $PAPI_BINARY_FOLDER/vector-multiplication/ParallelNonTiled "$i" "$CACHE" "$TYPE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N &

            wait

            srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $PAPI_BINARY_FOLDER/vector-multiplication/ParallelTiled "$i" "$CACHE" "$TYPE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N &
            
            wait
                        
            srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $PAPI_BINARY_FOLDER/jacobi/ParallelTiled "$i" "$CACHE" "$TYPE" $JACOBI_M &
            
            wait

            srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $PAPI_BINARY_FOLDER/jacobi/ParallelNonTiled "$i" "$CACHE" "$TYPE" $JACOBI_M &

            wait

            srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $PAPI_BINARY_FOLDER/jacobi/ParallelSingleTiled "$i" "$CACHE" "$TYPE" $JACOBI_M &
            
            wait
            
        done
        
        TYPE=1
        for i in {1..32}; do
            #Matrix mult
            srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $PAPI_BINARY_FOLDER/matrix-multiplication/ParallelSingleTiled "$i" "$CACHE" "$TYPE" $MATRIX_MULT_M &

            wait

            srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $PAPI_BINARY_FOLDER/matrix-multiplication/ParallelNonTiled "$i" "$CACHE" "$TYPE" $MATRIX_MULT_M &
            
            wait

            srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $PAPI_BINARY_FOLDER/matrix-multiplication/ParallelTiled "$i" "$CACHE" "$TYPE" $MATRIX_MULT_M &
                        
            wait
            
            srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $PAPI_BINARY_FOLDER/vector-multiplication/ParallelSingleTiled "$i" "$CACHE" "$TYPE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N &

            wait

            srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $PAPI_BINARY_FOLDER/vector-multiplication/ParallelNonTiled "$i" "$CACHE" "$TYPE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N &

            wait

            srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $PAPI_BINARY_FOLDER/vector-multiplication/ParallelTiled "$i" "$CACHE" "$TYPE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N &
            
            wait
                        
            srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $PAPI_BINARY_FOLDER/jacobi/ParallelTiled "$i" "$CACHE" "$TYPE" $JACOBI_M &
            
            wait

            srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $PAPI_BINARY_FOLDER/jacobi/ParallelNonTiled "$i" "$CACHE" "$TYPE" $JACOBI_M &

            wait

            srun --nodes=1 --ntasks=1 --cpus-per-task=$i --exclusive $PAPI_BINARY_FOLDER/jacobi/ParallelSingleTiled "$i" "$CACHE" "$TYPE" $JACOBI_M &
            
            wait
            
            
        done
        
    fi
    
done

