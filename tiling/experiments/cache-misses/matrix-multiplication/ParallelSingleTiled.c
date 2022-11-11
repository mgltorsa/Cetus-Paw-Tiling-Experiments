#include <stdio.h>
#include <stdlib.h>
#include <omp.h>

int main(int argc, char const * argv[])
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

    float **a = (float **)calloc(n, sizeof(float *));
    float **b = (float **)calloc(n, sizeof(float *));
    float **d = (float **)calloc(n, sizeof(float *));

    if (a == NULL || b == NULL || d == NULL)
    {
        printf("matrix-mult,parallel-paw-single-tiled,%d,speed-up,%d,%d,mem-allocation-error\n", cores, n, m);
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


    double start = omp_get_wtime();

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
		int balancedTileSize = (((m*n)*n)/(cores*(((m*n)*n)/(2048*cores))));
		int jj;
		int jTile = balancedTileSize;
		#pragma cetus private(i, j, jj, k) 
		for ((jj=0); jj<m; jj+=jTile)
		{
			#pragma cetus private(i, j, k) 
			#pragma cetus parallel 
			#pragma omp parallel for private(i, j, k)
			for (i=0; i<n; i ++ )
			{
				#pragma cetus private(j, k) 
				for ((j=jj); j<((((-1+jTile)+jj)<m) ? ((-1+jTile)+jj) : m); j ++ )
				{
					#pragma cetus private(k) 
					for (k=0; k<n; k ++ )
					{
						d[i][j]=(d[i][j]+(a[i][k]*b[k][j]));
					}
				}
			}
		}
	}

    double end = omp_get_wtime();
    double time = end - start;

	for (z = 0; z < n; z++)
    {
        free(a[z]);
        free(b[z]);
        free(d[z]);
    }

    free(a);
    free(b);
    free(d);


    printf("matrix-mult,parallel-paw-single-tiled,%d,speed-up,%d,%d,%f\n", cores,n,m,time);
	_ret_val_0=0;
	return _ret_val_0;
}
