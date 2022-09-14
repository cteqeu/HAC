
#include "stdio.h"
#include "cuda.h"
#include "cuda_runtime.h"

__global__ void kernel()
{
    printf("threadIdx.x : %d\n", threadIdx.x);

}

int main()
{
  printf("In Host...\n");
  printf("Starting Kernel on device...\n");
  kernel<<<1,10>>>();
  cudaDeviceSynchronize();
  return 0;
}
