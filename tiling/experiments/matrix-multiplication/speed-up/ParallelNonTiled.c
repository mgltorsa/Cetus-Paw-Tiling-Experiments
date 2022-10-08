
#include <stdio.h>
#include <stdlib.h>
#include <omp.h>

int main(int argc, char *argv[])
{

    int n = 1000, m = n;

    int cores = 0;

    if(argc > 1) {
        cores=atoi(argv[1]);
    }

    if(cores >0) {
        omp_set_num_threads(cores);
    }

    if (argc > 2)
    {
        n = atoi(argv[2]);
    }

    m = n;

    if (argc > 3)
    {
        m = atoi(argv[3]);
    }

    int a[n][n], b[n][m], d[n][m];

    int i, j, k;


    double start = omp_get_wtime();

    #pragma omp parallel for private(i, j, k)
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

    double end = omp_get_wtime();
    double time = end - start;

    printf("matrix-mult,parallel-non-tiled,%d,speed-up,%f\n", cores, time);

    return 0;
}
