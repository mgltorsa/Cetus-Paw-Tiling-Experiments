#include "omp.h"
#include "stdio.h"

int main(int argc, char const *argv[])
{

    int thId, nThreads, nProc;

    double start = omp_get_wtime();
#pragma omp parallel
    {

        int thId = omp_get_thread_num();
        printf("Thread: %d \n", thId);
        // int threadsNum = omp_get_num_threads();
        // printf("Threads: %d \n", threadsNum);
        // double threadsTime[4];
        // for (int i = 0; i < 4; i++)
        // {
        //     double threadStart = omp_get_wtime();
        //     int threadNum = omp_get_thread_num();
        //     printf("Thread: %d \n", threadNum);
        //     double threadTime = omp_get_wtime() - threadStart;
        //     printf("Thread Time: %d \n", threadTime);
        // }

#pragma omp barrier

        if (thId == 0)
        {
            nThreads = omp_get_num_threads();
            printf("There are %d threads\n", nThreads);

            nProc = omp_get_num_procs();
            printf("There are %d procs\n", nProc);
        }
    }

    double end = omp_get_wtime();
    double time = end - start;
    printf("Total time ( %.15f ) - ( %.15f ): %.15f\n", start, end, time);

    return 0;
}
