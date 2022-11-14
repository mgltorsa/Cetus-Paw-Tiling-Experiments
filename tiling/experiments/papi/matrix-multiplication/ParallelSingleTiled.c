#include <stdio.h>
#include <stdlib.h>
#include <omp.h>
#include <papi.h>
#include <papi_libs.h>

int main(int argc, char const * argv[])
{
	int n = 300, m = n;

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

    m = n;

    if (argc > 5)
    {
        m = atoi(argv[5]);
    }

	initAndMeasure(&eventSet, event);

    float **a = (float **)calloc(n, sizeof(float *));
    float **b = (float **)calloc(n, sizeof(float *));
    float **d = (float **)calloc(n, sizeof(float *));


    if (a == NULL || b == NULL || d == NULL)
    {
        printf("matrix-mult,parallel-paw-single-tiled,%d,%s,%d,%d,mem-allocation-error\n", cores, eventLabel, n, m);
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
	int _ret_val_0;

    //getting works performance here. Check
	// initAndMeasure(&eventSet, event);

	if (((m*n)*n)<=100000)
	{
		#pragma cetus private(i, j, k) 
		#pragma cetus parallel 
		#pragma omp parallel for if((10000<(((1L+(3L*n))+((3L*m)*n))+(((3L*m)*n)*n)))) private(i, j, k)
		for (i=0; i<n; i ++ )
		{
			#pragma cetus private(j, k) 
			for (j=0; j<m; j ++ )
			{
				#pragma cetus private(k) 
				for (k=0; k<n; k ++ )
				{
					d[i][j]=(d[i][j]+(a[i][k]*b[k][j]));
				}
			}
		}
	}
	else
	{
		int balancedTileSize = (((m*n)*n)/(cores*(((m*n)*n)/(cores*(cacheSize/128)))));
		int jj;
		int jTile = balancedTileSize;
		#pragma loop name main#1 
		#pragma cetus private(i, j, jj, k) 
		#pragma cetus parallel 
		#pragma omp parallel for private(i, j, jj, k)
		for ((jj=0); jj<m; jj+=jTile)
		{
			#pragma loop name main#1#0 
			#pragma cetus private(i, j, k) 
			for (i=0; i<n; i ++ )
			{
				#pragma loop name main#1#0#0 
				#pragma cetus private(j, k) 
				for ((j=jj); j<((((-1+jTile)+jj)<m) ? ((-1+jTile)+jj) : m); j ++ )
				{
					#pragma loop name main#1#0#0#0 
					#pragma cetus private(k) 
					for (k=0; k<n; k ++ )
					{
						d[i][j]=(d[i][j]+(a[i][k]*b[k][j]));
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
        free(d[z]);
    }

    free(a);
    free(b);
    free(d);


    printf("matrix-mult,parallel-paw-single-tiled,%d,%s,%d,%d,%lld\n", cores, eventLabel, n,m,measurement);
	_ret_val_0=0;
	return _ret_val_0;
}
