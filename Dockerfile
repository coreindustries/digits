# 1. CUDA 8: https://github.com/NVIDIA/nvidia-docker/blob/master/ubuntu-14.04/cuda/8.0/runtime/Dockerfile
# CAFFE: https://github.com/BVLC/caffe/blob/master/docker/standalone/gpu/Dockerfile
# CAFFE & CUDA 8 ISSUES: https://github.com/NVIDIA/nvidia-docker/issues/165
# DIGITS 4: https://github.com/NVIDIA/nvidia-docker/blob/master/ubuntu-14.04/digits/4.0/Dockerfile



# START WITH CUDA 8 (based on Ubuntu 14.04)

# FROM ubuntu:14.04
# MAINTAINER NVIDIA CORPORATION <digits@nvidia.com>

# LABEL com.nvidia.volumes.needed="nvidia_driver"

# RUN apt-get update && apt-get install -y --no-install-recommends \
#         ca-certificates \
#         vim \
#         wget \
#         git \
#         curl && \
#     rm -rf /var/lib/apt/lists/*

# ENV CUDA_VERSION 8.0
# LABEL com.nvidia.cuda.version="8.0"

# ENV CUDA_DOWNLOAD_SUM 58a5f8e6e8bf6515c55fd99e38b1a617142e556c70679cf563f30f972bbdd811

# ENV CUDA_PKG_VERSION 8-0=8.0.27-1
# RUN curl -o cuda-repo.deb -fsSL http://developer.download.nvidia.com/compute/cuda/8.0/direct/cuda-repo-ubuntu1404-8-0-rc_8.0.27-1_amd64.deb && \
#     echo "$CUDA_DOWNLOAD_SUM  cuda-repo.deb" | sha256sum -c --strict - && \
#     dpkg -i cuda-repo.deb && \
#     rm cuda-repo.deb && \
#     apt-get update && apt-get install -y --no-install-recommends \
#         cuda-nvrtc-$CUDA_PKG_VERSION \
#         cuda-nvgraph-$CUDA_PKG_VERSION \
#         cuda-cusolver-$CUDA_PKG_VERSION \
#         cuda-cublas-$CUDA_PKG_VERSION \
#         cuda-cufft-$CUDA_PKG_VERSION \
#         cuda-curand-$CUDA_PKG_VERSION \
#         cuda-cusparse-$CUDA_PKG_VERSION \
#         cuda-npp-$CUDA_PKG_VERSION \
#         cuda-cudart-$CUDA_PKG_VERSION && \
#     ln -s cuda-$CUDA_VERSION /usr/local/cuda && \
#     apt-get remove --purge -y cuda-repo-ubuntu1404-8-0-rc && \
#     rm -rf /var/lib/apt/lists/*

# RUN echo "/usr/local/cuda/lib" >> /etc/ld.so.conf.d/cuda.conf && \
#     echo "/usr/local/cuda/lib64" >> /etc/ld.so.conf.d/cuda.conf && \
#     ldconfig

# RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf && \
#     echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf

# ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
# ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64:${LD_LIBRARY_PATH}



#
# https://github.com/BVLC/caffe/blob/master/docker/standalone/gpu/Dockerfile
#
# FROM nvidia/cuda:7.5-cudnn5-devel-ubuntu14.04
FROM nvidia/cuda:8.0-cudnn5-runtime
MAINTAINER caffe-maint@googlegroups.com

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        cmake \
        git \
        wget \
        vim \
        libatlas-base-dev \
        libboost-all-dev \
        libgflags-dev \
        libgoogle-glog-dev \
        libhdf5-serial-dev \
        libleveldb-dev \
        liblmdb-dev \
        libopencv-dev \
        libprotobuf-dev \
        libsnappy-dev \
        protobuf-compiler \
        python-dev \
        python-numpy \
        python-pip \
        python-scipy && \
    rm -rf /var/lib/apt/lists/*

ENV CAFFE_ROOT=/opt/caffe
WORKDIR $CAFFE_ROOT

# FIXME: clone a specific git tag and use ARG instead of ENV once DockerHub supports this.
ENV CLONE_TAG=master

RUN git clone -b ${CLONE_TAG} --depth 1 https://github.com/BVLC/caffe.git . && \
    for req in $(cat python/requirements.txt) pydot; do pip install $req; done && \
    mkdir build && cd build && \
    # cmake -DUSE_CUDNN=1 .. && \
    cmake -DCUDA_ARCH_NAME=Manual -DCUDA_ARCH_BIN="61" -DCUDA_ARCH_PTX="61" -DUSE_CUDNN=1 .. && \
    make -j"$(nproc)"

ENV PYCAFFE_ROOT $CAFFE_ROOT/python
ENV PYTHONPATH $PYCAFFE_ROOT:$PYTHONPATH
ENV PATH $CAFFE_ROOT/build/tools:$PYCAFFE_ROOT:$PATH
RUN echo "$CAFFE_ROOT/build/lib" >> /etc/ld.so.conf.d/caffe.conf && ldconfig

WORKDIR /workspace
