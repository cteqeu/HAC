// Working with CUDA Runtime API
// Information :https://docs.nvidia.com/cuda/cuda-runtime-api/structcudaDeviceProp.html

#include "stdio.h"
#include "cuda.h"
#include "cuda_runtime.h"

int main()
{
	int deviceIdx = 0;
	cudaSetDevice(deviceIdx);
	
	cudaDeviceProp deviceProp;
	cudaGetDeviceProperties(&deviceProp, deviceIdx);
	printf("GPU is %s, index set is %d\n",deviceProp.name, deviceIdx);
  return 0;
}