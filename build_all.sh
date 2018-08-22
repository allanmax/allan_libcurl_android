#!/bin/bash

for arch in armeabi armeabi-v7a
do
    bash build_curl.sh $arch
    make
    sudo make install
done
