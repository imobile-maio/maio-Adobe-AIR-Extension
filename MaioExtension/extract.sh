#!/bin/sh

BULD="../build"
BUILD_ANDROID="../build/android"
BUILD_DEFUALT="../build/default"

unzip ./bin/MaioExtension.swc -d ./unzipped
sudo cp -f ./unzipped/library.swf $BUILD_ANDROID
sudo cp -f ./unzipped/library.swf $BUILD_DEFUALT

rm -rf ./unzipped

sudo cp -f ./bin/MaioExtension.swc ${BULD}