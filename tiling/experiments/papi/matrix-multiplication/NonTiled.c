
#include <stdio.h>
#include <sys/time.h>
#include <stdlib.h>
#include <math.h>
#include <papi.h>
#include <papi_libs.h>

int main(int argc, char *argv[])
{

    //PAPI Measurements
	int eventType = atoi(argv[1]);
	int eventSet = createEmptyEventSet();
    int event = getEvent(eventType);
	char *eventLabel = getEventLabel(eventType);

    int n = 300, m = n;

    if (argc > 1)
    {
        n = atoi(argv[2]);
    }

    m = n;

    if (argc > 2)
    {
        m = atoi(argv[3]);
    }

    float **a = (float **)calloc(n, sizeof(float *));
    float **b = (float **)calloc(n, sizeof(float *));
    float **d = (float **)calloc(n, sizeof(float *));

    if (a == NULL || b == NULL || d == NULL)
    {
        printf("matrix-mult,non-tiled,%d,%s,%d,%d,mem-allocation-error\n", 0, eventLabel, n, m);
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



    initAndMeasure(&eventSet, event);

    for (i = 0; i < n; i++)
    {

        for (j = 0; j < m; j++)
        {

            float sum =0.0;

            for (k = 0; k < n; k++)
            {

                sum += a[i][k] * b[k][j];
            }
            d[i][j] = sum;
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

    printf("matrix-mult,non-tiled,%d,%s,%d,%d,%d,%lld\n", 0, eventLabel, n, m, 0, measurement);

    return 0;
}
