#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <omp.h>
#include <papi.h>
#include <papi_libs.h>

int main(int argc, char const *argv[])
{
	int m = 300;

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


	float **a = (float **)calloc(m, sizeof(float *));
	float **b = (float **)calloc(m, sizeof(float *));


	if (a == NULL || b == NULL)
	{
		printf("jacobi,parallel-paw-tiled,%d,%s,%d,%d,mem-allocation-error\n", cores, eventLabel, m, m);
		return 1;
	}

	int z, p;

	for (z = 0; z < m; z++)
	{
		a[z] = (float *)calloc(m , sizeof(float));
		b[z] = (float *)calloc(m , sizeof(float));
	}

	for (z = 0; z < m; z++)
	{
		for (p = 0; p < m; p++)
		{
			a[z][p] = rand() * 1000;
			b[z][p] = rand() * 1000;
		}
	}

	int i, j;
	int _ret_val_0;

    //getting works performance here. Check
	// initAndMeasure(&eventSet, event);
	int balancedTileSize = ((cacheSize*0.7/4)/cores);
	if ((((1+(-2*m))+(m*m))<=100000)&&(cacheSize>((8*m)*m)))
	{
		#pragma loop name main #0
		#pragma cetus private(i, j)
		for (i = 1; i < (m - 1); i++)
		{
			#pragma loop name main #0 #0
			#pragma cetus private(j)
			for (j = 1; j < (m - 1); j++)
			{
				a[i][j] = (0.2 * ((((b[j][i] + b[j - 1][i]) + b[j][i - 1]) + b[j + 1][i]) + b[j][i + 1]));
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
		#pragma loop name main#1 
		#pragma cetus private(i, ii, j, jj) 
		#pragma cetus parallel 
		#pragma omp parallel for private(i, ii, j, jj)
		for (ii=1; ii<(m-1); ii+=iTile)
		{
			#pragma loop name main#1#0 
			#pragma cetus private(i, j, jj) 
			for (jj=1; jj<(m-1); jj+=jTile)
			{
				#pragma loop name main#1#0#0 
				#pragma cetus private(i, j) 
				for (i=ii; i<((((-1+iTile)+ii)<(m-1)) ? ((-1+iTile)+ii) : (m-1)); i ++ )
				{
					#pragma loop name main#1#0#0#0 
					#pragma cetus private(j) 
					for (j=jj; j<((((-1+jTile)+jj)<(m-1)) ? ((-1+jTile)+jj) : (m-1)); j ++ )
					{
						a[i][j]=(0.2*((((b[j][i]+b[j-1][i])+b[j][i-1])+b[j+1][i])+b[j][i+1]));
					}
				}
			}
		}
	}

	long_long measurement = stopMeasure(eventSet);


    for (z = 0; z < m; z++)
    {
        free(a[z]);
        free(b[z]);
    }

    free(a);
    free(b);

    printf("jacobi,parallel-paw-tiled,%d,%s,%d,%d,%d,%lld\n", cores, eventLabel, m, m, balancedTileSize, measurement);

	_ret_val_0 = 0;
	return _ret_val_0;
}
