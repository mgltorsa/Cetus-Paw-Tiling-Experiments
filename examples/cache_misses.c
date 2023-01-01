#include <stdlib.h>
#include <stdio.h>
#include <papi.h>
#include <papi_libs.h>

int main(int argc, char const *argv[])
{
    int eventSet = PAPI_NULL;
    int event = PAPI_L3_TCM;

    int n = 1000;
    int ar[32][16];

    initAndMeasure(&eventSet, event);

    int r = ar[0][0];

    r=ar[1][0];
    // for (int i = 1; i < 32; i++)
    // {
    //     ar[i] = ar[i - 1];
    // }

    long_long val = stopMeasure(eventSet);
    printf("Got: %llu\n", val);

    int eventSet2 = PAPI_NULL;

    initAndMeasure(&eventSet2, event);

    r = ar[2][1];

    r=ar[3][1];
    // for (int i = 1; i < 32; i++)
    // {
    //     ar[i] = ar[i - 1];
    // }

    val = stopMeasure(eventSet2);
    printf("Got: %llu\n", val);

    int m = 2805;
    n=2805;
    int cacheSize = 47185920;
    int gg =(((m*n)*n)<=100000);
    int cc = (cacheSize>(((8*m)*n)+((4*n)*n)));
    
    printf("Multiply: %d\n", gg)
    printf("Multiply: %d\n", cc)
    return 0;
}