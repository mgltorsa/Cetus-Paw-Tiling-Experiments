#include <stdio.h>
#include <stdlib.h>
#include <omp.h>

int main(int argc, char const *argv[])
{

	int n = 5;

	int cores = atoi(argv[1]);
	int cacheSize = atoi(argv[2]);

	if (cores > 0)
	{
		omp_set_num_threads(cores);
	}

	if (argc > 3)
	{
		n = atoi(argv[3]);
	}


	float *a = (float *)calloc(n*n, sizeof(float *));
	float *b = (float *)calloc(n, sizeof(float *));
	float *c = (float *)calloc(n, sizeof(float *));

	if (a == NULL || b == NULL || c == NULL)
	{
		printf("vector-mult,parallel-non-tiled,%d,speed-up,%d,%d,mem-allocation-error\n", cores, n, n);
		return 1;
	}

	int p = 0;
	int z = 0;
	for (p = 0; p < n; p++)
	{

		for (z = 0; z < n; z++)
		{
			a[p*n + z] = rand() * 1000;
		}
		
		b[p] = rand() * 1000;
		c[p] = rand() * 1000;
	}

	int i, j;
	int _ret_val_0;

	double start = omp_get_wtime();

	#pragma loop name main #0
	#pragma cetus private(i, j)
	#pragma cetus parallel
	#pragma omp parallel for private(i, j)
	for (i = 0; i < n; i++)
	{
		#pragma loop name main #0 #0
		#pragma cetus private(j)
		/* #pragma cetus reduction(+: c[i])  */
		for (j = 0; j < n; j++)
		{
			c[i] += (a[(i * n) + j] * b[j]);
		}
	}

 	double end = omp_get_wtime();
    double time = end - start;

	free(a);
    free(b);
    free(c);

	printf("vector-mult,parallel-non-tiled,%d,speed-up,%d,%d,%f\n", cores, n, n, time);

	_ret_val_0 = 0;
	return _ret_val_0;
}
