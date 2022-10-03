#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "cuda.h"
#include "cuda_runtime.h"

#define n 10000000

__global__ void vecAdd(float *a, float *b, float *c, int L)
{

    int id = blockIdx.x*blockDim.x+threadIdx.x;
    if (id < L)
        c[id] = a[id] + b[id];
}

int main()
{
    float *h_a;
    float *h_b;
    float *h_c;
 
    float *d_a;
    float *d_b;
    float *d_c;
 
    size_t bytes = n*sizeof(float);

    h_a = (float*)malloc(bytes);
    h_b = (float*)malloc(bytes);
    h_c = (float*)malloc(bytes);

    cudaMalloc(&d_a, bytes);
    cudaMalloc(&d_b, bytes);
    cudaMalloc(&d_c, bytes);
 
    int i;
    for( i = 0; i < n; i++ ) {
        h_a[i] = (float)i;
        h_b[i] = (float)i;
    }

    cudaMemcpy( d_a, h_a, bytes, cudaMemcpyHostToDevice);
    cudaMemcpy( d_b, h_b, bytes, cudaMemcpyHostToDevice);
 
    int blockSize, gridSize;
    blockSize = 1024;
    gridSize = (int)ceil((float)n/blockSize);
 
    vecAdd<<<gridSize, blockSize>>>(d_a, d_b, d_c, n);

    cudaMemcpy( h_c, d_c, bytes, cudaMemcpyDeviceToHost );
 
	printf("h_c[i] = %f\r\n",h_c[n-1]);
	
    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);

    free(h_a);
    free(h_b);
    free(h_c);
    return 0;
}