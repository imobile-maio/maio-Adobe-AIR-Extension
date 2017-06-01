#!/bin/sh

BUILD="./build"
BUILD_ANDROID="${BUILD}/android"
BUILD_IOS="${BUILD}/ios"
BUILD_DEFAULT="${BUILD}/default"
MAIO_EXTENSION="./MaioExtension"
MAIO_EXTENSION_DEFAULT="MaioExtensionDefault"
ANDROID_JAR="./MaioAdobeAirExtensionBase/adobeairextension/build/intermediates/bundles/debug/classes.jar"
IOS_LIB="./IOSMaioExtension/IOSMaioExtension/build/release/libIOSMaioExtension.a"

# actual extension
echo "> Copying extension base"
unzip $MAIO_EXTENSION/bin/MaioExtension.swc -d ./unzipped
sudo cp -f ./unzipped/library.swf $BUILD_ANDROID
sudo cp -f ./unzipped/library.swf $BUILD_IOS
rm -rf ./unzipped
sudo cp -f $MAIO_EXTENSION/bin/MaioExtension.swc $BUILD

# default extension
echo "> Copying default extension"
unzip $MAIO_EXTENSION_DEFAULT/bin/MaioExtensionDefault.swc -d ./unzipped
sudo cp -f ./unzipped/library.swf $BUILD_DEFAULT
rm -rf ./unzipped

# android extension
if [ ! -e $ANDROID_JAR ]; then
    echo "> No update to Android extension"
else
    echo "> Copying android extension"
    mv -f $ANDROID_JAR $BUILD_ANDROID/MaioExtension.jar
fi

# ios extension
if [ ! -e $IOS_LIB ]; then
    echo "> No update to iOS extension"
else
    echo "> Copying iOS extension"
    mv -f $IOS_LIB $BUILD_IOS/libIOSMaioExtension.a
fi

cd $BUILD
echo "> Building"
adt -package -target ane MaioExtension.ane extension.xml -swc MaioExtension.swc \
    -platform Android-ARM \
        -platformoptions android_options.xml \
        -C android . \
    -platform iPhone-ARM \
        -platformoptions ios_options.xml \
        -C ios . \
    -platform default \
        -C default .

echo "> DONE ☕"