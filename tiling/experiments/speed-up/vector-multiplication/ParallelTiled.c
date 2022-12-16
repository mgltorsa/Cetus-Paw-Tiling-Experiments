#include <stdlib.h>
#include <stdio.h>
#include <omp.h>

int main(int argc, char const * argv[])
{
	int n = 300;

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


	float *a = (float *)calloc(n * n , sizeof(float *));
	float *b = (float *)calloc(n , sizeof(float *));
	float *c = (float *)calloc(n , sizeof(float *));

	if (a == NULL || b == NULL || c == NULL)
	{
		printf("vector-mult,parallel-paw-tiled,%d,speed-up,%d,%d,mem-allocation-error\n", cores, n, n);
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

	double start = omp_get_wtime();

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
    	int balancedTileSize = ((cacheSize/32)/cores);
		int ii;
		int iTile = balancedTileSize;
		int jj;
		int jTile = balancedTileSize;
		#pragma cetus parallel 
		#pragma cetus private(i, ii, j, jj) 
		{
			float * reduce = (float * )malloc(n*sizeof (float));
			int reduce_span_0;
			for (reduce_span_0=0; reduce_span_0<n; reduce_span_0 ++ )
			{
				reduce[reduce_span_0]=0;
			}
			#pragma loop name main#1 
			#pragma omp parallel for private(i, ii, j, jj) reduction()
			#pragma cetus for  
			for ((ii=0); ii<n; ii+=iTile)
			{
				#pragma loop name main#1#0 
				#pragma cetus private(i, j, jj) 
				/* #pragma cetus reduction(+: c[i])  */
				for ((jj=0); jj<n; jj+=jTile)
				{
					#pragma loop name main#1#0#0 
					#pragma cetus private(i, j) 
					for ((i=ii); i<((((-1+iTile)+ii)<n) ? ((-1+iTile)+ii) : n); i ++ )
					{
						#pragma loop name main#1#0#0#0 
						#pragma cetus private(j) 
						/* #pragma cetus reduction(+: c[i])  */
						for ((j=jj); j<((((-1+jTile)+jj)<n) ? ((-1+jTile)+jj) : n); j ++ )
						{
							reduce[i]+=(a[(i*n)+j]*b[j]);
						}
					}
				}
			}
			#pragma cetus critical  
			{
				for (reduce_span_0=0; reduce_span_0<n; reduce_span_0 ++ )
				{
					c[reduce_span_0]+=reduce[reduce_span_0];
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
	_ret_val_0=0;
	return _ret_val_0;
}
