#!/bin/sh

# The folder this script is located in:
pushd $(dirname $BASH_SOURCE[0]) >/dev/null
LTU_SDK_SCRIPT=$(pwd)
popd >/dev/null

# The SDK root is the parent folder the SDK Script is located in
LTU_SDK_ROOT=$(dirname $LTU_SDK_SCRIPT)

# LTU SDK Framework Name
LTU_SDK_NAME="LTUSDK"

# Binary name that the xcode project produces, this will be renamed to the LTU_SDK_NAME
LTU_SDK_BINARY_NAME="libLTUSDK-lib.a"

# Build path
LTU_SDK_BUILD_PATH="${LTU_SDK_ROOT}/build/Framework"

# Clean existing Build
if [ -d "$LTU_SDK_BUILD_PATH" ]
then
  echo "LTU SDK: Cleaning LTU SDK build folder: $LTU_SDK_BUILD_PATH"
  rm -rf "$LTU_SDK_BUILD_PATH"
fi

# Build the Framework bundle directory structure
echo "LTU SDK: Setting up Framework directories..."
LTU_SDK_FRAMEWORK_DIR=$LTU_SDK_BUILD_PATH/$LTU_SDK_NAME.framework
mkdir -p $LTU_SDK_FRAMEWORK_DIR/Versions/A/Headers

# Compile the Binaries
echo "LTU SDK: Compiling the binaries"
# Must run the xcodebuild inside the root folder where the project resides
pushd $LTU_SDK_ROOT >/dev/null
xcodebuild \
  SYMROOT=$LTU_SDK_BUILD_PATH \
  clean build
popd >/dev/null

# Copy files to the Framework Structure
echo "LTU SDK: Copy Built files to Framework"
cp $LTU_SDK_BUILD_PATH/Release-iphoneos/Headers/*.h $LTU_SDK_FRAMEWORK_DIR/Versions/A/Headers
cp $LTU_SDK_BUILD_PATH/Release-iphoneos/$LTU_SDK_BINARY_NAME $LTU_SDK_FRAMEWORK_DIR/Versions/A/LTUSDK

# Create symlinks for the Framework structure
pushd $LTU_SDK_FRAMEWORK_DIR >/dev/null
ln -s ./Versions/A/Headers ./Headers
ln -s ./Versions/A/Resources ./Resources
ln -s ./Versions/A/$LTU_SDK_NAME ./$LTU_SDK_NAME
cd ./Versions
ln -s ./A ./Current
popd >/dev/null
