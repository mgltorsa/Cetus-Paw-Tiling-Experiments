#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <omp.h>
#include <papi.h>
#include <papi_libs.h>

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

	float **a = (float **)calloc(n , sizeof(float *));
	float **b = (float **)calloc(n , sizeof(float *));


	//PAPI Measurements
	int eventType = atoi(argv[2]);
	int eventSet = createEmptyEventSet();
    int event = getEvent(eventType);
	char *eventLabel = getEventLabel(eventType);

	if (a == NULL || b == NULL)
	{
		printf("jacobi,parallel-non-tiled,%d,%s,%d,%d,mem-allocation-error\n", cores, eventLabel, n, m);
		return 1;
	}

	int z, p;

	for (z = 0; z < n; z++)
	{
		a[z] = (float *)calloc(m , sizeof(float));
		b[z] = (float *)calloc(m , sizeof(float));
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

    printf("jacobi,parallel-non-tiled,%d,%s,%d,%d,%lld\n", cores, eventLabel, n, m, measurement);

	_ret_val_0 = 0;
	return _ret_val_0;
}
