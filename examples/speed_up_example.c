#include "omp.h"
#include "stdlib.h"
#include "stdio.h"

int main(int argc, char const *argv[])
{

    int thId, nThreads = 0;

    if (argc > 1)
    {
        omp_set_num_threads(atoi(argv[1]));
    }

    double start = omp_get_wtime();

#pragma omp parallel
    {

        if (nThreads == 0)
        {
            nThreads = omp_get_num_threads();
        }
        int thId = omp_get_thread_num();
        printf("Thread: %d \n", thId);

        int sum = 0;
        for (int i = 0; i < 100000; i++)
        {
            sum += i;
        }
    }

    printf("There are %d threads\n", nThreads);

    double end = omp_get_wtime();
    double time = end - start;
    printf("Total time ( %.15f ) - ( %.15f ): %.15f\n", start, end, time);

    return 0;
}
