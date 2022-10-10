#include <stdio.h>
#include <omp.h>

int main(int argc, char const * argv[])
{
	int n = 300, m = n;

    int cores = 0;

    if(argc > 1) {
        cores=atoi(argv[1]);
    }

    if(cores >0) {
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
	
	float **a = (float **)malloc(n * sizeof(float *));
    float **b = (float **)malloc(n * sizeof(float *));
    float **d = (float **)malloc(n * sizeof(float *));

	if(a==NULL || b==NULL || d==NULL) {
		printf("ERROR an array was null");
		return 1;
	}

 	for (int z = 0; z < n; z++)
    {
        a[z] = (float *)malloc(m * sizeof(float));
        b[z] = (float *)malloc(m * sizeof(float));
        d[z] = (float *)malloc(m * sizeof(float));
    }

	for (int z = 0; z < n; z++)
    {
        for (int p = 0; p < n; p++)
        {
            a[z][p] = rand()*1000;
            b[z][p] = rand()*1000;
            d[z][p] = rand()*1000;
        }        
    }

	int i, j, k;
	int _ret_val_0;


    double start = omp_get_wtime();

	if (((m*n)*n)<=100000)
	{
		#pragma loop name main#0 
		#pragma cetus private(i, j, k) 
		for (i=0; i<n; i ++ )
		{
			#pragma loop name main#0#0 
			#pragma cetus private(j, k) 
			for (j=0; j<m; j ++ )
			{
				#pragma loop name main#0#0#0 
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
		int balancedTileSize = (((m*n)*n)/(4*(((m*n)*n)/4000)));
		int kk;
		int kTile = balancedTileSize;
		#pragma loop name main#1 
		#pragma cetus private(i, j, k, kk) 
		for (i=0; i<n; i ++ )
		{
			#pragma loop name main#1#0 
			#pragma cetus private(j, k, kk) 
			for (kk=0; kk<n; kk+=kTile)
			{
				#pragma loop name main#1#0#0 
				#pragma cetus private(j, k) 
				for (j=0; j<m; j ++ )
				{
					#pragma loop name main#1#0#0#0 
					#pragma cetus private(k) 
					#pragma cetus parallel 
					#pragma omp parallel for if((10000<((1L+(-3L*kk))+(3L*((((-1001L+kTile)+kk)<0L) ? ((-1L+kTile)+kk) : 1000L))))) private(k)
					for (k=kk; k<((((-1+kTile)+kk)<n) ? ((-1+kTile)+kk) : n); k ++ )
					{
						d[i][j]=(d[i][j]+(a[i][k]*b[k][j]));
					}
				}
			}
		}
	}

	double end = omp_get_wtime();
    double time = end - start;

	for (int z = 0; z < n; z++)
    {
        free(a[z]);
        free(b[z]);
        free(d[z]);
    }

    free(a);
    free(b);
    free(d);


    printf("matrix-mult,parallel-paw-tiled,%d,speed-up,%d,%d,%f\n", cores,n,m,time);

	_ret_val_0=0;
	return _ret_val_0;
}
