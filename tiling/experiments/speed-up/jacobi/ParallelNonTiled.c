#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <omp.h>

int main(int argc, char const *argv[])
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

	float **a = (float **)malloc(n * sizeof(float *));
	float **b = (float **)malloc(n * sizeof(float *));

	if (a == NULL || b == NULL)
	{
		printf("jacobi,parallel-non-tiled,%d,speed-up,%d,%d,mem-allocation-error\n", cores, n, m);
		return 1;
	}

	int z, p;

	for (z = 0; z < n; z++)
	{
		a[z] = (float *)malloc(m * sizeof(float));
		b[z] = (float *)malloc(m * sizeof(float));
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

	double start = omp_get_wtime();
	int _ret_val_0;
	#pragma loop name main #0
	#pragma cetus private(i, j)
	#pragma cetus parallel
	#pragma omp parallel for private(i, j)
	for (i = 1; i < (n - 1); i++)
	{
		#pragma loop name main #0 #0
		#pragma cetus private(j)
		for (j = 1; j < (n - 1); j++)
		{
			a[i][j] = (0.2 * ((((b[j][i] + b[j - 1][i]) + b[j][i - 1]) + b[j + 1][i]) + b[j][i + 1]));
		}
	}

	double end = omp_get_wtime();
    double time = end - start;

    for (z = 0; z < n; z++)
    {
        free(a[z]);
        free(b[z]);
    }

    free(a);
    free(b);

    printf("jacobi,parallel-non-tiled,%d,speed-up,%d,%d,%f\n", cores, n, m, time);

	_ret_val_0 = 0;
	return _ret_val_0;
}
