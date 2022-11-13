#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <omp.h>
#include <papi.h>
#include <papi_libs.h>

int main(int argc, char const *argv[])
{
	int n = 300, m = n;

	int cores = atoi(argv[1]);
	

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

	float **a = (float **)calloc(n, sizeof(float *));
	float **b = (float **)calloc(n, sizeof(float *));

	//PAPI Measurements
	int eventType = atoi(argv[2]);
	int eventSet = createEmptyEventSet();
    int event = getEvent(eventType);
	char *eventLabel = getEventLabel(eventType);

	if (a == NULL || b == NULL)
	{
		printf("jacobi,parallel-paw-tiled,%d,%s,%d,%d,mem-allocation-error\n", cores, eventLabel, n, m);
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

    //getting works performance here. Check
	// initAndMeasure(&eventSet, event);
	
	if (((1 + (-2 * n)) + (n * n)) <= 100000)
	{
		#pragma loop name main #0
		#pragma cetus private(i, j)
		for (i = 1; i < (n - 1); i++)
		{
			#pragma loop name main #0 #0
			#pragma cetus private(j)
			for (j = 1; j < (n - 1); j++)
			{
				a[i][j] = (0.2 * ((((b[j][i] + b[j - 1][i]) + b[j][i - 1]) + b[j + 1][i]) + b[j][i + 1]));
			}
		}
	}
	else
	{
		int balancedTileSize = (((1+(-2*n))+(n*n))/(cores*(((1+(-2*n))+(n*n))/(1365*cores))));
		int ii;
		int iTile = balancedTileSize;
		int jj;
		int jTile = balancedTileSize;
		initAndMeasure(&eventSet, event);
		#pragma loop name main #1
		#pragma cetus private(i, ii, j, jj)
		#pragma cetus parallel
		#pragma omp parallel for private(i, ii, j, jj)
		for (ii = 1; ii < (n - 1); ii += iTile)
		{
			#pragma loop name main #1 #0
			#pragma cetus private(i, j, jj)
			for (jj = 1; jj < (n - 1); jj += jTile)
			{
				#pragma loop name main #1 #0 #0
				#pragma cetus private(i, j)
				for (i = ii; i < ((((-1 + iTile) + ii) < (n - 1)) ? ((-1 + iTile) + ii) : (n - 1)); i++)
				{
					#pragma loop name main #1 #0 #0 #0
					#pragma cetus private(j)
					for (j = jj; j < ((((-1 + jTile) + jj) < (n - 1)) ? ((-1 + jTile) + jj) : (n - 1)); j++)
					{
						a[i][j] = (0.2 * ((((b[j][i] + b[j - 1][i]) + b[j][i - 1]) + b[j + 1][i]) + b[j][i + 1]));
					}
				}
			}
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

    printf("jacobi,parallel-paw-tiled,%d,%s,%d,%d,%lld\n", cores, eventLabel, n, m, measurement);

	_ret_val_0 = 0;
	return _ret_val_0;
}
