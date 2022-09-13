
#include "stdio.h"
#include "cuda.h"
#include "cuda_runtime.h"

__global__ void kernel()
{
  printf("Hello From CUDA Device\n");
}

int main()
{
  printf("In Host...\n");
  printf("Starting Kernel on device...\n");
  kernel<<<10,10>>>();
  cudaDeviceSynchronize();
  return 0;
}
