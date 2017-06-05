#!/bin/sh

BIN="$(cd $(dirname $0) && /bin/pwd)"

TMP_UNZIP="${BIN}/unzipped"

BUILD="${BIN}/build"
BUILD_ANDROID="${BUILD}/android"
BUILD_IOS="${BUILD}/ios"
BUILD_DEFAULT="${BUILD}/default"

MAIO_EXTENSION="${BIN}/MaioExtension"
MAIO_EXTENSION_DEFAULT="${BIN}/MaioExtensionDefault"

ANDROID_JAR="${BIN}/MaioAdobeAirExtensionBase/adobeairextension/build/intermediates/bundles/debug/classes.jar"
IOS_LIB="${BIN}/IOSMaioExtension/IOSMaioExtension/build/release/libIOSMaioExtension.a"

# actual extension
echo "> Copying extension base"
unzip $MAIO_EXTENSION/bin/MaioExtension.swc -d $TMP_UNZIP
cp -f $TMP_UNZIP/library.swf $BUILD_ANDROID
cp -f $TMP_UNZIP/library.swf $BUILD_IOS
rm -rf $TMP_UNZIP
cp -f $MAIO_EXTENSION/bin/MaioExtension.swc $BUILD

# default extension
echo "> Copying default extension"
unzip $MAIO_EXTENSION_DEFAULT/bin/MaioExtensionDefault.swc -d $TMP_UNZIP
cp -f $TMP_UNZIP/library.swf $BUILD_DEFAULT
rm -rf $TMP_UNZIP

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

# generate ANE
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

echo "> Copying library to root"
cp -f $BUILD/MaioExtension.ane $BIN

echo "> DONE ☕"