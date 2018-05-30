#!/bin/bash

# Setting up build env
sudo yum update -y
sudo yum install -y git cmake gcc-c++ gcc python-devel chrpath
mkdir -p lambda-package/cv2 build/numpy

# Build numpy
pip install --install-option="--prefix=$PWD/build/numpy" numpy
cp -rf build/numpy/lib64/python2.7/site-packages/numpy lambda-package

# Build OpenCV 3.2
(
    NUMPY=$PWD/lambda-package/numpy/core/include
    cd build
    wget https://github.com/opencv/opencv/archive/3.2.0.zip
    unzip 3.2.0.zip
    cd opencv-3.2.0
    mkdir my-build
    cd my-build
    cmake                                       \
        -D CMAKE_BUILD_TYPE=RELEASE             \
        -D WITH_TBB=ON                          \
        -D WITH_IPP=ON                          \
        -D WITH_V4L=ON                          \
        -D ENABLE_AVX=ON                        \
        -D ENABLE_SSSE3=ON                      \
        -D ENABLE_SSE41=ON                      \
        -D ENABLE_SSE42=ON                      \
        -D ENABLE_POPCNT=ON                     \
        -D ENABLE_FAST_MATH=ON                  \
        -D BUILD_EXAMPLES=OFF                   \
        -D BUILD_TESTS=OFF                      \
        -D BUILD_PERF_TESTS=OFF                 \
        -D PYTHON2_NUMPY_INCLUDE_DIRS="$NUMPY"  \
        ..
    make -j`cat /proc/cpuinfo | grep MHz | wc -l`
)

cp build/opencv-3.2.0/my-build/lib/cv2.so lambda-package/cv2/__init__.so
cp -L build/opencv-3.2.0/my-build/lib/*.so.3.2 lambda-package/cv2
strip --strip-all lambda-package/cv2/*
chrpath -r '$ORIGIN' lambda-package/cv2/__init__.so
touch lambda-package/cv2/__init__.py

# manually put in template.py!!

# Copy template function and zip package
cp template.py lambda-package/lambda_function.py
cd lambda-package
zip -r ../lambda-package.zip *