#!/bin/sh

# Package LTU Mobile SDK script
# Everything is relative to the current sript folder
pushd $(dirname $BASH_SOURCE[0]) >/dev/null

LTU_PACKAGE_DIR="ltumobile_sdk"
LTU_PACKAGE_TAR="ltumobile_sdk.tar"

# Clean previous packaged SDK:
rm -rf $LTU_PACKAGE_DIR
rm -f $LTU_PACKAGE_TAR

# Build the Framework SDK
./build_sdk.sh

# Copy Framework into a packaging area
mkdir -p $LTU_PACKAGE_DIR
mv ../build/Framework/LTUSDK.framework $LTU_PACKAGE_DIR/LTUSDK.framework

# Copy the README into the packaging area
cp ../../LTUMobileiPhoneSDKREADME.md $LTU_PACKAGE_DIR/README.md

# Build the Apple Docs, this gets put in an "html" subfolder
appledoc -o $LTU_PACKAGE_DIR ../
# Rename html folder to docs
mv $LTU_PACKAGE_DIR/html $LTU_PACKAGE_DIR/docs

# Copy the Example code into the packaging area
mkdir -p $LTU_PACKAGE_DIR/Example
cp -r ../../Example/* $LTU_PACKAGE_DIR/Example

# Tar the packaged framework
tar -cvf $LTU_PACKAGE_TAR $LTU_PACKAGE_DIR/*

popd >/dev/null
