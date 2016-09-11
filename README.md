# DIGITS 4.0 on TITAN X PASCAL

I ran into trouble using the official Nvidia Digits docker build. 

So I combined information from the following sources to create this Dockerfile.

1. CUDA 8: https://github.com/NVIDIA/nvidia-docker/blob/master/ubuntu-14.04/cuda/8.0/runtime/Dockerfile

2.  CAFFE: https://github.com/BVLC/caffe/blob/master/docker/standalone/gpu/Dockerfile

3.  CAFFE & CUDA 8 ISSUES: https://github.com/NVIDIA/nvidia-docker/issues/165

4.  DIGITS 4: https://github.com/NVIDIA/nvidia-docker/blob/master/ubuntu-14.04/digits/4.0/Dockerfile