#include <stdlib.h>
#include <stdio.h>
#include <omp.h>
#include <papi.h>
#include <papi_libs.h>

int main(int argc, char const * argv[])
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

	if (argc > 3)
	{
		n = atoi(argv[3]);
	}

	initAndMeasure(&eventSet, event);

	float *a = (float *)calloc(n * n, sizeof(float *));
	float *b = (float *)calloc(n , sizeof(float *));
	float *c = (float *)calloc(n , sizeof(float *));


	if (a == NULL || b == NULL || c == NULL)
	{
		printf("vector-mult,parallel-paw-single-tiled,%d,%s,%d,%d,mem-allocation-error\n", cores, eventLabel, n, n);
		return 1;
	}

	int p = 0;
	for (p = 0; p < n; p++)
	{
		for (int z = 0; z < n; z++)
		{
			a[p*n + z] = rand() * 1000;
		}
		
		b[p] = rand() * 1000;
		c[p] = rand() * 1000;
	}

	int i, j;
	int _ret_val_0;

	//PAPI init measurement
	//getting works performance here. Check
	// initAndMeasure(&eventSet, event);
	
	if ((n*n)<=100000)
	{
		#pragma cetus private(i, j) 
		#pragma cetus parallel 
		#pragma omp parallel for private(i, j)
		for (i=0; i<n; i ++ )
		{
			#pragma cetus private(j) 
			/* #pragma cetus reduction(+: c[i])  */
			for (j=0; j<n; j ++ )
			{
				c[i]+=(a[(i*n)+j]*b[j]);
			}
		}
	}
	else
	{
		int balancedTileSize = ((cacheSize/96)+(-1*((cacheSize/96)%cores)));
		int jj;
		int jTile = balancedTileSize;
		#pragma loop name main#1 
		#pragma cetus private(i, j, jj) 
		#pragma cetus reduction(+: c[i]) 
		for ((jj=0); jj<n; jj+=jTile)
		{
			#pragma loop name main#1#0 
			#pragma cetus private(i, j) 
			#pragma cetus parallel 
			#pragma omp parallel for private(i, j)
			for (i=0; i<n; i ++ )
			{
				#pragma loop name main#1#0#0 
				#pragma cetus private(j) 
				#pragma cetus reduction(+: c[i]) 
				for ((j=jj); j<((((-1+jTile)+jj)<n) ? ((-1+jTile)+jj) : n); j ++ )
				{
					c[i]+=(a[(i*n)+j]*b[j]);
				}
			}
		}
	}

    long_long measurement = stopMeasure(eventSet);


	free(a);
	free(b);
	free(c);

	printf("vector-mult,parallel-paw-single-tiled,%d,%s,%d,%d,%lld\n", cores, eventLabel, n, n, measurement);
	_ret_val_0=0;
	return _ret_val_0;
}
