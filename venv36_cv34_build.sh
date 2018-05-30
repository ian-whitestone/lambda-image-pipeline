#!/bin/bash


# Setting up build env
sudo yum update -y
sudo yum install -y git cmake gcc-c++ gcc python-devel chrpath
mkdir -p lambda-package/cv2 build/numpy

# Download python 3
sudo yum install python36-devel -y

# Create virtual env
virtualenv -p python3 project
source project/bin/activate


# Build numpy
pip install numpy
cp -rf project/local/lib64/python3.6/site-packages/numpy lambda-package

# Build OpenCV 3.4.1
(
    NUMPY=$PWD/lambda-package/numpy/core/include
    cd build
    wget https://github.com/opencv/opencv/archive/3.4.1.zip
    unzip 3.4.1.zip
    cd opencv-3.4.1
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
        -D PYTHON3_NUMPY_INCLUDE_DIRS="$NUMPY"  \
        -D PYTHON_EXECUTABLE=/home/ec2-user/project/bin/python \
        ..
    make -j`cat /proc/cpuinfo | grep MHz | wc -l`
)

#         -D PYTHON3_INCLUDE_DIR=/home/ec2-user/project/include/python3.6m/ \

cp build/opencv-3.4.1/my-build/lib/python3/cv2.cpython-36m-x86_64-linux-gnu.so lambda-package/cv2/__init__.so
cp -L build/opencv-3.4.1/my-build/lib/*.so.3.4 lambda-package/cv2
strip --strip-all lambda-package/cv2/*
chrpath -r '$ORIGIN' lambda-package/cv2/__init__.so
touch lambda-package/cv2/__init__.py

# pull down template file
curl -L https://raw.githubusercontent.com/ian-whitestone/lambda-image-pipeline/master/lambda-function.py -o lambda-function.py

# Copy template function and zip package
cp lambda-function.py lambda-package/lambda_function.py
cd lambda-package
zip -r ../lambda-package.zip *