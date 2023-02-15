
#include <stdio.h>
#include <sys/time.h>
#include <stdlib.h>
#include <math.h>

int main(int argc, char *argv[])
{

    int n = 300, m = n;

    if (argc > 0)
    {
        n = atoi(argv[1]);
    }

    m = n;

    if (argc > 1)
    {
        m = atoi(argv[2]);
    }

    float **a = (float **)calloc(n, sizeof(float *));
    float **b = (float **)calloc(n, sizeof(float *));
    float **d = (float **)calloc(n, sizeof(float *));

    if (a == NULL || b == NULL || d == NULL)
    {
        printf("matrix-mult,non-tiled,%d,speed-up,%d,%d,mem-allocation-error\n", 0, n, m);
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

    struct timeval start;
    gettimeofday(&start, 0);

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

    struct timeval end;
    gettimeofday(&end, 0);
    long seconds = end.tv_sec - start.tv_sec;
    long microseconds = end.tv_usec - start.tv_usec;
    double time = seconds + microseconds*1e-6;

    for (z = 0; z < n; z++)
    {
        free(a[z]);
        free(b[z]);
        free(d[z]);
    }

    free(a);
    free(b);
    free(d);

    printf("matrix-mult,non-tiled,%d,speed-up,%d,%d,%d,%f\n", 0, n, m, 0, time);

    return 0;
}
