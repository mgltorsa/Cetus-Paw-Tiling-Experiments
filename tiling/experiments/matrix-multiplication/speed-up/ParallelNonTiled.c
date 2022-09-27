
#include <stdio.h>
#include <stdlib.h>
#include <omp.h>

int main(int argc, char *argv[])
{

    int n = 20, m = n; 
    
    if (argc > 2)
    {
        n = atoi(argv[1]);
    }

    m = n;

    if (argc > 3)
    {
        m = atoi(argv[2]);
    }

    int a[n][n], b[n][m], d[n][m];

    int i, j, k;

    int thId, nThreads;


    double start = omp_get_wtime();

    #pragma omp parallel
    {
        int thId = omp_get_thread_num();
        #pragma omp for private(i, j, k)
        for (i = 0; i < n; i++)
        {

            for (j = 0; j < m; j++)
            {

                for (k = 0; k < n; k++)
                {

                    d[i][j] = d[i][j] + a[i][k] * b[k][j];
                }
            }
        }

        #pragma omp barrier
        if (thId == 0)
        {
            nThreads = omp_get_num_threads();
        }
    }

    double end = omp_get_wtime();
    double time = end - start;

    printf("matrix-mult,speed-up,%d,%f\n", nThreads, time);

    return 0;
}
