#include <stdlib.h>
#include <stdio.h>
#include <papi.h>
#include <papi_libs.h>

// PAPI_TOT_INS
int events[] = {PAPI_TOT_CYC};
long_long values[] = {0};
char eventLabel[PAPI_MAX_STR_LEN];

int main(int argc, char const *argv[])
{
    int eventSet = PAPI_NULL;
    int event = PAPI_L3_TCM;

    int n = 1000;
    int *ar = (int *)calloc(n, sizeof(int *));

    initAndMeasure(&eventSet, event);

    for (int i = 1; i < n; i++)
    {
        ar[i] = ar[i - 1];
    }

    long_long val = stopMeasure(eventSet);
    printf("Got: %llu\n", val);
    return 0;
}