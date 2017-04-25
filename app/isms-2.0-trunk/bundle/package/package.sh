#!/bin/sh
#
# Script to build the package (Both PXL and installer) for iSMS.
# Credited to vnsea project
#
# Usage: package.sh <version> <iphone-firmware-version>
if [ $# -ne 2 ]; then
	echo "Usage: package.sh <version> <iphone-firmware-version>"
	exit
fi

#if script is invoked by make, the current directory is the $TOP folder, so change it
cd ./bundle/package

# Setup variables
if [ -n "$RELEASE" ]; then
	TARGET=build/release
	FULL_VERSION=$1
	PLIST_TEMPLATE=./installer/plists/isms-release.plist.template
	PLIST=../../${TARGET}/isms-release.plist
else
	TARGET=build/snapshot
	timestamp=`date +%m%d%H%M`
	FULL_VERSION=$1-${timestamp}
	PLIST_TEMPLATE=./installer/plists/isms-snapshot.plist.template
	PLIST=../../${TARGET}/isms-snapshot.plist
fi

PACKAGE_FILE="isms-${FULL_VERSION}.zip"

# clean up from last build if have any
rm -rf app icon.png springboard

# copy icon file //TODO
cp ../app/icon.png .

# copy latest build into the app directory
#mkdir app
cp -r ../app app
find app -name .svn -exec rm -rf '{}' ';' -prune
find app -name Thumbs.db -exec rm -rf '{}' ';' -prune

cp -r ../springboard springboard
find springboard -name .svn -exec rm -rf '{}' ';' -prune
find springboard -name Thumbs.db -exec rm -rf '{}' ';' -prune

# copy the binaries
#if [ ! -d ./build/$2]; then
#	mkdir ./build/$2
#fi
cp -f ../../build/bin/* ./app/

# delete previous package with the same name
if [ -e "../../${TARGET}/$PACKAGE_FILE" ]; then
	echo "Deleting old package file $PACKAGE_FILE"
	rm -f $PACKAGE_FILE
fi

# create the package file
zip -q -r $PACKAGE_FILE icon.png app springboard ./pxl/PxlPkg.plist

# create the installer list
echo Generating plist with ${FULL_VERSION},${PACKAGE_FILE},${PLIST_TEMPLATE},${PLIST}
./installer/plistgen.sh $FULL_VERSION $PACKAGE_FILE ${PLIST_TEMPLATE} ${PLIST}

mv $PACKAGE_FILE ../../${TARGET}

# clean up in clean target
rm -fr app springboard icon.png

echo "$PACKAGE_FILE" is built successfully
