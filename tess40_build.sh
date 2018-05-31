#!/bin/bash
## Source: https://stackoverflow.com/questions/33588262/tesseract-ocr-on-aws-lambda-via-virtualenv
sudo yum install -y

# Compile leptonica
cd ~
sudo yum install clang -y
sudo yum install libpng-devel libtiff-devel zlib-devel libwebp-devel libjpeg-turbo-devel -y
wget https://github.com/DanBloomberg/leptonica/releases/download/1.75.1/leptonica-1.75.1.tar.gz
tar -xzvf leptonica-1.75.1.tar.gz
cd leptonica-1.75.1
./configure && make && sudo make install


# Compile autoconf-archive
## Unfortunately, since some weeks tesseract needs autoconf-archive,
## which is not available for amazon AIMs, so you'd need to compile it on your own:
cd ~
wget http://mirror.switch.ch/ftp/mirror/gnu/autoconf-archive/autoconf-archive-2017.09.28.tar.xz
tar -xvf autoconf-archive-2017.09.28.tar.xz
cd autoconf-archive-2017.09.28
./configure && make && sudo make install
sudo cp m4/* /usr/share/aclocal/

# Compile tesseract
cd ~
sudo yum install git-core libtool pkgconfig -y
git clone --depth 1  https://github.com/tesseract-ocr/tesseract.git tesseract-ocr
cd tesseract-ocr
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig
./autogen.sh
./configure
make
sudo make install

# Get all needed files and zip
cd ~
mkdir tesseract-standalone
cd tesseract-standalone
cp /usr/local/bin/tesseract .
mkdir lib
cp /usr/local/lib/libtesseract.so.4 lib/
cp /usr/local/lib/liblept.so.5 lib/
cp /usr/lib64/libjpeg.so.62 lib/
cp /usr/lib64/libwebp.so.4 lib/
cp /usr/lib64/libstdc++.so.6 lib/
mkdir tessdata
cd tessdata
wget https://github.com/tesseract-ocr/tessdata_fast/raw/master/osd.traineddata
wget https://github.com/tesseract-ocr/tessdata_fast/raw/master/eng.traineddata

# additionally any other language you want to use, e.g. `deu` for Deutsch
mkdir configs
cp /usr/local/share/tessdata/configs/pdf configs/
cp /usr/local/share/tessdata/pdf.ttf .
cd ..
zip -r ~/tesseract-standalone.zip *

# pull down template files
cd ~
git clone https://github.com/ian-whitestone/lambda-image-pipeline.git
cp lambda-image-pipeline/test.png .
cp lambda-image-pipeline/ocr-function.py .

# add other files to zip file
zip -ur tesseract-standalone.zip test.png
zip -ur tesseract-standalone.zip ocr-function.py