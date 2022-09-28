#include "omp.h"
#include "stdio.h"

int main(int argc, char const *argv[])
{

    int thId, nThreads = 0;

    double threadsTime[omp_get_max_threads()];

    int maxThreads = sizeof threadsTime / sizeof threadsTime[0];
    for (int i = 0; i < maxThreads; i++)
    {
        threadsTime[i] = 0;
    }

    double start = omp_get_wtime();

#pragma omp parallel
    {        
        if (nThreads == 0)
        {
            nThreads = omp_get_num_threads();
            printf("There are %d threads\n", nThreads);
        }

        int thId = omp_get_thread_num();
        printf("Thread: %d \n", thId);

        double thStart = omp_get_wtime();

        int sum = 0;
        for (int i = 0; i < 100000; i++)
        {
            sum += i;
        }

        double thEnd = omp_get_wtime();

        double thTime = thEnd - thStart;
        threadsTime[thId] += thTime;
        printf("Thread %d time: %f \n", thId, thTime);
    }

    double end = omp_get_wtime();
    double time = end - start;
    printf("Total time ( %.15f ) - ( %.15f ): %.15f\n", start, end, time);

    for (int i = 0; i < nThreads; i++)
    {
        double thTime = threadsTime[i];
        printf("Thread: %d - Rate usage: %f\n", i, (thTime / time) * 100);
    }

    return 0;
}
