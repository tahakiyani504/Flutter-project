#!/bin/bash

echo "================================="
echo " Building PC Controller Server"
echo "================================="

PROJECT_DIR=$(pwd)

SOURCE="src/main/java/com/example/pccontroller/PCControllerServer.java"
MAIN_CLASS="com.example.pccontroller.PCControllerServer"

BUILD_DIR="build"
CLASS_DIR="$BUILD_DIR/classes"

APP_NAME="PC Controller Server"


echo "Cleaning old build..."

rm -rf "$BUILD_DIR"
rm -rf "$APP_NAME.app"


mkdir -p "$CLASS_DIR"
mkdir -p release


echo "Compiling Java..."

javac \
-d "$CLASS_DIR" \
"$SOURCE"


if [ $? -ne 0 ]; then
    echo "Compilation failed!"
    exit 1
fi


echo "Creating JAR..."

jar cfe \
"$BUILD_DIR/PCControllerServer.jar" \
"$MAIN_CLASS" \
-C "$CLASS_DIR" .


if [ $? -ne 0 ]; then
    echo "Jar creation failed!"
    exit 1
fi


echo "Creating Mac Application..."

jpackage \
--type app-image \
--name "$APP_NAME" \
--input "$BUILD_DIR" \
--main-jar PCControllerServer.jar


if [ $? -ne 0 ]; then
    echo "App creation failed!"
    exit 1
fi


echo "Creating DMG..."

rm -f "release/$APP_NAME.dmg"


hdiutil create \
-volname "$APP_NAME" \
-srcfolder "$APP_NAME.app" \
-ov \
-format UDZO \
"release/$APP_NAME.dmg"


if [ $? -ne 0 ]; then
    echo "DMG creation failed!"
    exit 1
fi


echo "================================="
echo " BUILD COMPLETE!"
echo " DMG:"
echo " release/$APP_NAME.dmg"
echo "================================="