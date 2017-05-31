#!/bin/sh

BUILD="../build"
BUILD_DEFUALT="../build/default"

unzip ./bin/MaioExtensionDefault.swc -d ./unzipped
sudo cp -f ./unzipped/library.swf $BUILD_DEFUALT

rm -rf ./unzipped

cd ../build
adt -package -target ane MaioExtension.ane extension.xml -swc MaioExtension.swc -platform Android-ARM -platformoptions android_options.xml -C android . -platform default -C default .