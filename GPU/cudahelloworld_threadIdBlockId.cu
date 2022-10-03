#include <stdio.h>
#include <stdlib.h> 
#include "cuda.h"
#include "cuda_runtime.h"

__global__ void print_from_gpu(void) {
	printf("Thread [%d,%d] From device\r\n", threadIdx.x,blockIdx.x); 
}

int main(void) { 
	printf("Print from Host!\r\n"); 
	print_from_gpu<<<2,2>>>();
	cudaDeviceSynchronize();
return 0; 
}