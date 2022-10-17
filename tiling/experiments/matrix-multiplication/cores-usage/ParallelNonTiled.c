
#include <stdio.h>
#include <omp.h>

int main(int argc, char const *argv[])
{

    int n = 300, m = n;

    int cores = 0;

    if (argc > 1)
    {
        cores = atoi(argv[1]);
    }

    if (cores > 0)
    {
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

    float **a = (float **)malloc(n * sizeof(float *));
    float **b = (float **)malloc(n * sizeof(float *));
    float **d = (float **)malloc(n * sizeof(float *));

    if (a == NULL || b == NULL || d == NULL)
    {
        printf("matrix-mult,parallel-non-tiled,%d,speed-up,%d,%d,mem-allocation-error\n", cores, n, m);
        return 1;
    }

    int z, p;

    for (z = 0; z < n; z++)
    {
        a[z] = (float *)malloc(m * sizeof(float));
        b[z] = (float *)malloc(m * sizeof(float));
        d[z] = (float *)malloc(m * sizeof(float));
    }

    for (z = 0; z < n; z++)
    {
        for (p = 0; p < n; p++)
        {
            a[z][p] = rand() * 1000;
            b[z][p] = rand() * 1000;
            d[z][p] = rand() * 1000;
        }
    }

    int i, j, k;

    int thId, nThreads;

    double start = omp_get_wtime();
    
    #pragma omp parallel
    {
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
    }
    double end = omp_get_wtime();
    double time = end - start;
    printf("%f", time);

    return 0;
}
