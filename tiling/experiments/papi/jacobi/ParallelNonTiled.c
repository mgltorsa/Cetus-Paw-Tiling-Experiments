#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <omp.h>
#include <papi.h>
#include <papi_libs.h>

int main(int argc, char const *argv[])
{
	int n = 300;

	int cores = atoi(argv[1]);
	int cacheSize = atoi(argv[2]);
	
	//PAPI Measurements
	int eventType = atoi(argv[3]);
	int eventSet = createEmptyEventSet();
    int event = getEvent(eventType);
	char *eventLabel = getEventLabel(eventType);


	if (cores > 0)
	{
		omp_set_num_threads(cores);
	}

	if (argc > 4)
	{
		n = atoi(argv[4]);
	}


	float **a = (float **)calloc(n , sizeof(float *));
	float **b = (float **)calloc(n , sizeof(float *));


	if (a == NULL || b == NULL)
	{
		printf("jacobi,parallel-non-tiled,%d,%s,%d,%d,mem-allocation-error\n", cores, eventLabel, n, n);
		return 1;
	}

	int z, p;

	for (z = 0; z < n; z++)
	{
		a[z] = (float *)calloc(n , sizeof(float));
		b[z] = (float *)calloc(n , sizeof(float));
	}

	for (z = 0; z < n; z++)
	{
		for (p = 0; p < n; p++)
		{
			a[z][p] = rand() * 1000;
			b[z][p] = rand() * 1000;
		}
	}

	int i, j;
	int _ret_val_0;
	
	initAndMeasure(&eventSet, event);
	
	#pragma loop name main #0
	#pragma cetus private(i, j)
	#pragma cetus parallel
	#pragma omp parallel for private(i, j)
	for (i = 1; i < (n - 1); i++)
	{
		#pragma loop name main #0 #0
		#pragma cetus private(j)
		for (j = 1; j < (n - 1); j++)
		{
			a[i][j] = (0.2 * ((((b[j][i] + b[j - 1][i]) + b[j][i - 1]) + b[j + 1][i]) + b[j][i + 1]));
		}
	}

	long_long measurement = stopMeasure(eventSet);

    for (z = 0; z < n; z++)
    {
        free(a[z]);
        free(b[z]);
    }

    free(a);
    free(b);

    printf("jacobi,parallel-non-tiled,%d,%s,%d,%d,%lld\n", cores, eventLabel, n, n, measurement);

	_ret_val_0 = 0;
	return _ret_val_0;
}
