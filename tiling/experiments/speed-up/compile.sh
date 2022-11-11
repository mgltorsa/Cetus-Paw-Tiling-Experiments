
#Matrix
gcc -g -fopenmp matrix-multiplication/ParallelNonTiled.c -o matrix-multiplication/ParallelNonTiled
gcc -g -fopenmp matrix-multiplication/ParallelTiled.c -o matrix-multiplication/ParallelTiled
gcc -g -fopenmp matrix-multiplication/ParallelSingleTiled.c -o matrix-multiplication/ParallelSingleTiled

#Vector
gcc -g -fopenmp vector-multiplication/ParallelNonTiled.c -o vector-multiplication/ParallelNonTiled
gcc -g -fopenmp vector-multiplication/ParallelTiled.c -o vector-multiplication/ParallelTiled
gcc -g -fopenmp vector-multiplication/ParallelSingleTiled.c -o vector-multiplication/ParallelSingleTiled


#Jacobi
gcc -g -fopenmp jacobi/ParallelNonTiled.c -o jacobi/ParallelNonTiled
gcc -g -fopenmp jacobi/ParallelTiled.c -o jacobi/ParallelTiled