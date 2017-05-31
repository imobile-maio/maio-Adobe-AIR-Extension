#!/bin/sh

BUILD="./build"
BUILD_ANDROID="${BUILD}/android"
BUILD_DEFAULT="${BUILD}/default"
MAIO_EXTENSION="./MaioExtension"
MAIO_EXTENSION_DEFAULT="MaioExtensionDefault"
ANDROID_JAR="./MaioAdobeAirExtensionBase/adobeairextension/build/intermediates/bundles/debug/classes.jar"

# actual extension
echo "copying extension base"
unzip $MAIO_EXTENSION/bin/MaioExtension.swc -d ./unzipped
sudo cp -f ./unzipped/library.swf $BUILD_ANDROID
rm -rf ./unzipped
sudo cp -f $MAIO_EXTENSION/bin/MaioExtension.swc $BUILD

# default extension
echo "copying default extension"
unzip $MAIO_EXTENSION_DEFAULT/bin/MaioExtensionDefault.swc -d ./unzipped
sudo cp -f ./unzipped/library.swf $BUILD_DEFAULT
rm -rf ./unzipped

# android extension

if [ ! -e $ANDROID_JAR ]; then
    echo "no update to android extension"
else
    echo "copying android extension"
    mv -f $ANDROID_JAR $BUILD_ANDROID/MaioExtension.jar
fi

cd $BUILD
echo "building"
adt -package -target ane MaioExtension.ane extension.xml -swc MaioExtension.swc \
    -platform Android-ARM \
        -platformoptions android_options.xml \
        -C android . \
    -platform default \
        -C default .