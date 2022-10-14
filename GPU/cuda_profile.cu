#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "cuda.h"
#include "cuda_runtime.h"


__global__ void gpu_testfunction(float *a, float *b, float *c, int n)
{
	int id = blockIdx.x * blockDim.x+threadIdx.x;
	if (id < n)
	{
		a[id]=id;
		b[id]=id*id;
		c[id]=a[id]+b[id];
	}
}

__global__ void gpu_testfunction_uni_mem(float *a, float *b, float *c, int n)
{
	int id = blockIdx.x * blockDim.x+threadIdx.x;
	if (id < n)
	{
		a[id]=id;
		b[id]=id*id;
		c[id]=a[id]+b[id];
	}
}

float *cpu_testfunction(float *a, float *b, int n)
{
	float *c;
    int i=0;
	size_t bytes = n*sizeof(float);
	c = (float*)malloc(bytes);
	
    for(i=0; i<n; i++){
        a[i]=i;
        b[i]=i*i;
    }
    
    for(i=0; i<n; i++){
        c[i] = a[i] + b[i];
    }
	return c;
}

int main( int argc, char *argv[] )
{
    
    int n = 100000;
    
    float *a;
    float *b;
    float *c;
    
    float *d_a;
    float *d_b;
    float *d_c;
	
	float *a_um;
	float *b_um;
	float *c_um;
	
    size_t bytes = n*sizeof(float);
    
    a = (float*)malloc(bytes);
    b = (float*)malloc(bytes);
    c = (float*)malloc(bytes);
    
	cudaMalloc(&d_a, bytes);
    cudaMalloc(&d_b, bytes);
    cudaMalloc(&d_c, bytes);
	
	cudaMallocManaged(&a_um, bytes);
	cudaMallocManaged(&b_um, bytes);
	cudaMallocManaged(&c_um, bytes);
	
	c=cpu_testfunction(a,b,n);

    float control = 0;
	int i=0;
    for(i=0; i<n; i++) {
        control += c[i];
    }
	
    printf("cpu control: \t\t%f\n", control);
    
	cudaMemcpy(d_a, a, bytes, cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, b, bytes, cudaMemcpyHostToDevice);
	
	int blockSize, gridSize;

    blockSize = 1024;

    gridSize = (int)ceil((float)n/blockSize);
 
    gpu_testfunction<<<gridSize, blockSize>>>(d_a, d_b, d_c, n);
 
    cudaMemcpy(c, d_c, bytes, cudaMemcpyDeviceToHost );

    control = 0;
    i=0;
    for(i=0; i<n; i++) {
        control += c[i];
    }
    printf("gpu control: \t\t%f\n", control);
	
	gpu_testfunction_uni_mem<<<gridSize, blockSize>>>(a_um, b_um, c_um, n);
	cudaDeviceSynchronize();

    control = 0;
    i=0;
    for(i=0; i<n; i++) {
        control += c[i];
    }
    printf("gpu um control: \t%f\n", control);

    free(a);
    free(b);
    free(c);
	
	cudaFree(d_a);
	cudaFree(d_b);
	cudaFree(d_c);
	
	cudaFree(a_um);
	cudaFree(b_um);
	cudaFree(c_um);
    
    return 0;
}