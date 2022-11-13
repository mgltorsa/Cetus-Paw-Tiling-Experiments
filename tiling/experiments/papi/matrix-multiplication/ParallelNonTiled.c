
#include <stdio.h>
#include <stdlib.h>
#include <omp.h>
#include <papi.h>
#include <papi_libs.h>

int main(int argc, char *argv[])
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

    float **a = (float **)calloc(n, sizeof(float *));
    float **b = (float **)calloc(n, sizeof(float *));
    float **d = (float **)calloc(n, sizeof(float *));

    //PAPI Measurements
	int eventType = atoi(argv[2]);
	int eventSet = createEmptyEventSet();
    int event = getEvent(eventType);
	char *eventLabel = getEventLabel(eventType);

    if (a == NULL || b == NULL || d == NULL)
    {
        printf("matrix-mult,parallel-non-tiled,%d,%s,%d,%d,mem-allocation-error\n", cores, eventLabel, n, m);
        return 1;
    }

    int z, p;

    for (z = 0; z < n; z++)
    {
        a[z] = (float *)calloc(m, sizeof(float));
        b[z] = (float *)calloc(m, sizeof(float));
        d[z] = (float *)calloc(m,  sizeof(float));
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

	initAndMeasure(&eventSet, event);

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

    long_long measurement = stopMeasure(eventSet);


    for (z = 0; z < n; z++)
    {
        free(a[z]);
        free(b[z]);
        free(d[z]);
    }

    free(a);
    free(b);
    free(d);

    printf("matrix-mult,parallel-non-tiled,%d,%s,%d,%d,%lld\n", cores, eventLabel, n, m, measurement);

    return 0;
}
