#!/bin/bash

if [ -d ./dmg_files ]; then
	rm -rf ./dmg_files 
fi

mkdir ./dmg_files
cd ./dmg_files

cp -rf ../Build/Products/Debug/miband-unlocker.app ./
ln -s /Applications ./Applications

cd ..

version=`/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" "./miband-unlocker/Info.plist"`
timestamp=`date +%Y%m%d%H%M%S`

hdiutil create -volname miband-unlocker \
	-srcfolder ./dmg_files -ov -format UDZO \
	miband-unlocker-${version}.${timestamp}.dmg

rm -rf ./dmg_files
