#include <stdlib.h>
#include <stdio.h>
#include <math.h>

#define MIN(x, y) (((x) < (y)) ? (x) : (y))

// RAW TILE SIZE FROM The Cache Performance and Optimization of Blocked Algorithms
// Monica S. Lam, Edward E. Rothberg and Michael E. Wolf

long findB(long N, long C)
{
    long addr, di, dj, maxWidth;
    maxWidth = MIN(N, C);
    addr = N / 2;
    while (1 != 0)
    {
        addr = addr + C;
        if(addr<=0) {
            printf("OHH");
        }
        di = addr / N;
        dj = abs((addr % N) - (N / 2));
        if (di >= MIN(maxWidth, dj))
        {
            return MIN(maxWidth, di);
        }
        maxWidth = MIN(maxWidth, dj);
    }
}

int computeSize(int size)
{
}

int main()
{
    long cache = (4 * 1024 * 1024)/4; // 4MiB in integers;
    // int N = (1673 * 1673 * 3);
    long N = 2 * cache;
    long I = N * N * N;
    long P = 4;
    long T = findB(N, cache);

    int gg = P * T;
    long S = I / (ceil(I / (P * T)) * P);
    printf("T: %d\n", T);
    printf("S: %d\n", S);
}