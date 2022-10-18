#include <stdlib.h>
#include <stdio.h>

int main(int argc, char const *argv[])
{
	int n = 300;

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

	float *a = (float *)malloc(n * sizeof(float *));
	float *b = (float *)malloc(n * sizeof(float *));
	float *c = (float *)malloc(n * sizeof(float *));

	if (a == NULL || b == NULL || c == NULL)
	{
		printf("vector-mult,parallel-paw-tiled,%d,speed-up,%d,%d,mem-allocation-error\n", cores, n, n);
		return 1;
	}

	int p = 0;
	for (p = 0; p < n; p++)
	{
		a[p] = rand() * 1000;
		b[p] = rand() * 1000;
		c[p] = rand() * 1000;
	}

	int i, j;
	int _ret_val_0;
	double start = omp_get_wtime();
	if ((n * n) <= 100000)
	{
		#pragma loop name main #0
		#pragma cetus private(i, j)
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
	}
	else
	{
		int balancedTileSize = 2728;
		int jj;
		int jTile = balancedTileSize;
		#pragma cetus parallel
		#pragma cetus private(i, j, jj)
		#pragma omp parallel private(i, j, jj)
		{
			int *reduce = (int *)malloc(n * sizeof(int));
			int reduce_span_0;
			for (reduce_span_0 = 0; reduce_span_0 < n; reduce_span_0++)
			{
				reduce[reduce_span_0] = 0;
			}
			#pragma loop name main #1
			#pragma cetus for
			#pragma omp for
			for ((jj = 0); jj < n; jj += jTile)
			{
				#pragma loop name main #1 #0
				#pragma cetus private(i, j)
				for (i = 0; i < n; i++)
				{
					#pragma loop name main #1 #0 #0
					#pragma cetus private(j)
					/* #pragma cetus reduction(+: c[i])  */
					for ((j = jj); j < ((((-1 + jTile) + jj) < n) ? ((-1 + jTile) + jj) : n); j++)
					{
						reduce[i] += (a[(i * n) + j] * b[j]);
					}
				}
			}
				#pragma cetus critical
				#pragma omp critical
			{
				for (reduce_span_0 = 0; reduce_span_0 < n; reduce_span_0++)
				{
					c[reduce_span_0] += reduce[reduce_span_0];
				}
			}
		}
	}

	double end = omp_get_wtime();
	double time = end - start;

	free(a);
	free(b);
	free(c);

	printf("vector-mult,parallel-paw-tiled,%d,speed-up,%d,%d,%f\n", cores, n, n, time);
	_ret_val_0 = 0;
	return _ret_val_0;
}
