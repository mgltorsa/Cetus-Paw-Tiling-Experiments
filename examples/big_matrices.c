#include <math.h>
#include <stdio.h>
#include <stdlib.h>

// #define N 1000000

// int a[N];
// int b[N];
// int c[N][N];
// int d[N][N];



int main(int argc, char const *argv[])
{
    
    // int n = N;
    // int m = N;
    int i,j,k;

    // #pragma omp parallel for private(i, j, k)
    // for (i = 0; i < n; i++)
    // {

    //     for (j = 0; j < m; j++)
    //     {

    //         for (k = 0; k < n; k++)
    //         {

    //             d[i][j] = d[i][j] + a[i][k] * b[k][j];
    //         }
    //     }
    // }

    // a[2]= 3312;


    // printf("gg %d",big[2]);
    // printf("gg2 %d",big[N-1]);
    
    int m = 2805;
    int n= 2805;
    int cacheSize = 47185920;
    int gg =m*n*n;

    printf("Multiply: %d\n", gg);
    if(gg>100000) {
        int dd=(((8*m)*n)+((4*n)*n));
        int cc = (cacheSize>dd);
        printf("Multiply: %d\n", cc);
    }
    
    return 0;
}
