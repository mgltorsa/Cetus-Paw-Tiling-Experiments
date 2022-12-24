#include <stdlib.h>
#include <stdio.h>
#include <omp.h>
#include <math.h>
#include <papi.h>
#include <papi_libs.h>

int main(int argc, char const * argv[])
{
	int m = 300, n=300;

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
		m = atoi(argv[4]);
	}

	n = m;

	if (argc > 5)
	{
		n = atoi(argv[5]);
	}

	float *a = (float *)calloc(m * n, sizeof(float *));
	float *b = (float *)calloc(n , sizeof(float *));
	float *c = (float *)calloc(m , sizeof(float *));


	if (a == NULL || b == NULL || c == NULL)
	{
		printf("vector-mult,parallel-paw-tiled,%d,%s,%d,%d,mem-allocation-error\n", cores, eventLabel, m, n);
		return 1;
	}

	int p = 0;
	int z = 0;
	for (p = 0; p < n; p++)
	{
		for (z = 0; z < m; z++)
		{
			a[z*n + p] = rand() * 1000;
		}
		
		b[p] = rand() * 1000;
	}

	int i, j;
	int _ret_val_0;

	//PAPI init measurement
	//getting works performance here. Check
	// initAndMeasure(&eventSet, event);
	int balancedTileSize = (sqrt( (double) (cacheSize*0.7/4) )/cores);

	if (argc > 6)
	{
		balancedTileSize = atoi(argv[6]);
	}

	if (((m*n)<=100000)&&(cacheSize>(((4*m)+(4*n))+((4*m)*n))))
	{
		#pragma loop name main#0 
		#pragma cetus private(i, j) 
		#pragma cetus parallel 
		for (i=0; i<m; i ++ )
		{
			#pragma loop name main#0#0 
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
		int ii;
		int iTile = balancedTileSize;
		int jj;
		int jTile = balancedTileSize;
		initAndMeasure(&eventSet, event);
		#pragma cetus parallel 
		#pragma cetus private(i, ii, j, jj) 
		{
			float * reduce = (float * )malloc(m*sizeof (float));
			int reduce_span_0;
			for (reduce_span_0=0; reduce_span_0<m; reduce_span_0 ++ )
			{
				reduce[reduce_span_0]=0;
			}
			#pragma loop name main#1 
			#pragma omp parallel for private(i, ii, j, jj)
			#pragma cetus for  
			for (ii=0; ii<m; ii+=iTile)
			{
				#pragma loop name main#1#0 
				#pragma cetus private(i, j, jj) 
				/* #pragma cetus reduction(+: c[i])  */
				for (jj=0; jj<n; jj+=jTile)
				{
					#pragma loop name main#1#0#0 
					#pragma cetus private(i, j) 
					for (i=ii; i<((((-1+iTile)+ii)<m) ? ((-1+iTile)+ii) : m); i ++ )
					{
						#pragma loop name main#1#0#0#0 
						#pragma cetus private(j) 
						/* #pragma cetus reduction(+: c[i])  */
						for (j=jj; j<((((-1+jTile)+jj)<n) ? ((-1+jTile)+jj) : n); j ++ )
						{
							reduce[i]+=(a[(i*n)+j]*b[j]);
						}
					}
				}
			}
			#pragma cetus critical  
			{
				for (reduce_span_0=0; reduce_span_0<m; reduce_span_0 ++ )
				{
					c[reduce_span_0]+=reduce[reduce_span_0];
				}
			}
		}
	}

    long_long measurement = stopMeasure(eventSet);


	free(a);
	free(b);
	free(c);

	printf("vector-mult,parallel-paw-tiled,%d,%s,%d,%d,%d,%lld\n", cores, eventLabel, m, n, balancedTileSize, measurement);
	_ret_val_0=0;
	return _ret_val_0;
}
