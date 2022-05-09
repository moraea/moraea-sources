#!/bin/zsh

set -e
cd "$(dirname "$0")"

rm -rf Build
mkdir Build

input=('/Applications/Install macOS Monterey'*'.app/Contents/SharedSupport/SharedSupport.dmg')
hdiutil attach -noverify "$input"

ssMount='/Volumes/Shared Support'
unzip "$ssMount/com_apple_MobileAsset_MacSoftwareUpdate/"*.zip -d Build/Zip

hdiutil eject "$ssMount"

hdiutil mount -noverify Build/Zip/AssetData/usr/standalone/update/ramdisk/x86_64SURamDisk.dmg
ramdiskMount=("/Volumes/"*".x86_64SURamDisk")
sudo cp -a "$ramdiskMount" Build/Ramdisk
hdiutil eject "$ramdiskMount"

mkdir Build/Payload
cd Build/Payload
for archive in ../Zip/AssetData/payloadv2/payload.0??
do
	sudo aa extract -i "$archive"
done
cd ../..

versionPlist="$PWD/Build/Payload/System/Library/CoreServices/SystemVersion.plist"

version="$(defaults read "$versionPlist" ProductVersion)"
build="$(defaults read "$versionPlist" ProductBuildVersion)"

major="$(echo "$version" | cut -d '.' -f 1)"
rm -rf $major*

# TODO: not sure if there is a way to get the beta number
# but it's not in the SystemVersion plist
echo "$input" | grep beta > /dev/null && betaString=' beta'

output="$version$betaString ($build)"
mkdir "$output"

cp Build/Ramdisk/System/Library/PrivateFrameworks/SkyLight.framework/Versions/A/SkyLight "$output"
cp Build/Ramdisk/System/Library/Frameworks/QuartzCore.framework/Versions/A/QuartzCore "$output"
cp Build/Ramdisk/System/Library/Frameworks/IOSurface.framework/Versions/A/IOSurface "$output"
cp Build/Ramdisk/System/Library/PrivateFrameworks/IOAccelerator.framework/Versions/A/IOAccelerator "$output"
cp Build/Ramdisk/System/Library/Frameworks/CoreDisplay.framework/Versions/A/CoreDisplay "$output"

cp Build/Ramdisk/usr/lib/system/libsystem_kernel.dylib "$output"
cp -R Build/Payload/System/Library/Extensions/IO80211FamilyLegacy.kext/Contents/PlugIns/AirPortBrcmNIC.kext "$output"
cp Build/Zip/AssetData/boot/Firmware/usr/standalone/i386/boot.efi "$output"
cp -R Build/Payload/System/Library/Extensions/IOPlatformPluginFamily.kext/Contents/PlugIns/X86PlatformPlugin.kext "$output"
cp Build/Payload/usr/sbin/bluetoothd "$output"
cp Build/Payload/usr/sbin/BlueTool "$output"
cp -R Build/Payload/System/Library/Frameworks/WebKit.framework/Versions/A/XPCServices/com.apple.WebKit.WebContent.xpc "$output"

sudo rm -rf Build