#include <stdio.h>
#include <stdlib.h>
#include <omp.h>
#include <math.h>

int main(int argc, char const *argv[])
{
    int n = 300, m = n;

    int cores = atoi(argv[1]);
    int cacheSize = atoi(argv[2]);

    // int cores = 4;
    // int cacheSize = 8 * 1024 * 1024;

    if (cores > 0)
    {
        omp_set_num_threads(cores);
    }

    if (argc > 3)
    {
        n = atoi(argv[3]);
    }

    m = n;

    if (argc > 4)
    {
        m = atoi(argv[4]);
    }

    int balancedTileSize = (sqrt((double)(cacheSize * 0.7 / 4)) / cores);

    if (argc > 5)
    {
        balancedTileSize = atoi(argv[5]);
    }

    float **a = (float **)calloc(n, sizeof(float *));
    float **b = (float **)calloc(n, sizeof(float *));
    float **d = (float **)calloc(n, sizeof(float *));

    if (a == NULL || b == NULL || d == NULL)
    {
        printf("matrix-mult,parallel-paw-single-tiled-v2-no-fs,%d,speed-up,%d,%d,mem-allocation-error\n", cores, n, m);
        return 1;
    }

    int z, p;

    for (z = 0; z < n; z++)
    {
        a[z] = (float *)calloc(m, sizeof(float));
        b[z] = (float *)calloc(m, sizeof(float));
        d[z] = (float *)calloc(m, sizeof(float));
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
    int _ret_val_0;

    int jj;
    int jTile = balancedTileSize;
    double start = omp_get_wtime();
    #pragma loop name main #1
    #pragma cetus private(i, j, jj, k)
    for ((jj = 0); jj < m; jj += jTile)
    {
        #pragma loop name main #1 #0
        #pragma cetus private(i, j, k)
        #pragma cetus parallel
        #pragma omp parallel for private(i, j, k)
        for (i = 0; i < n; i++)
        {
            #pragma loop name main #1 #0 #0
            #pragma cetus private(j, k)
            for ((j = jj); j < ((((-1 + jTile) + jj) < m) ? ((-1 + jTile) + jj) : m); j++)
            {
                float sum = 0.0;
                #pragma loop name main #1 #0 #0 #0
                #pragma cetus private(k)
                for (k = 0; k < n; k++)
                {
                    sum += ((a[i][k] * b[k][j]));
                }
                d[i][j]=sum;
            }
        }
    }

    double end = omp_get_wtime();
    double time = end - start;

    for (z = 0; z < n; z++)
    {
        free(a[z]);
        free(b[z]);
        free(d[z]);
    }

    free(a);
    free(b);
    free(d);

    printf("matrix-mult,parallel-paw-single-tiled-v2-no-fs,%d,speed-up,%d,%d,%d,%f\n", cores, n, m, balancedTileSize, time);
    _ret_val_0 = 0;
    return _ret_val_0;
}
