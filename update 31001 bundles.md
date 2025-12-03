# update dsc 31001 bundles

```bash
# TODO: apparently 12.7.6 bins are unstable with 12.5 kexts?

version='12.5 (21G72)'
pushd "$version"

amyFolder='/Volumes/Backup 9/Unfiled/open/root/misc/versions'

dsceList=()
for bundle in AMDMTLBronzeDriver.bundle AMDRadeonX4000GLDriver.bundle AMDShared.bundle AMDRadeonX5000MTLDriver.bundle AMDRadeonX5000GLDriver.bundle AMDRadeonX5000Shared.bundle AMDRadeonX6000MTLDriver.bundle AMDRadeonX6000GLDriver.bundle AMDRadeonX6000Shared.bundle AMDRadeonVADriver.bundle AMDRadeonVADriver2.bundle AppleIntelBDWGraphicsMTLDriver.bundle AppleIntelBDWGraphicsGLDriver.bundle AppleIntelBDWGraphicsVADriver.bundle AppleIntelBDWGraphicsVAME.bundle AppleIntelSKLGraphicsMTLDriver.bundle AppleIntelSKLGraphicsGLDriver.bundle AppleIntelSKLGraphicsVADriver.bundle AppleIntelSKLGraphicsVAME.bundle AppleIntelGraphicsShared.bundle
do
	# entirely on-disk
	
	if [[ $bundle != AppleIntelBDWGraphicsVADriver.bundle && $bundle != AppleIntelBDWGraphicsVAME.bundle && $bundle != AppleIntelSKLGraphicsVADriver.bundle && $bundle != AppleIntelSKLGraphicsVAME.bundle ]]
	then
		dsceList+=/System/Library/Extensions/$bundle
	fi
	
	cp -R "$amyFolder/$version/root/System/Library/Extensions/$bundle" .
done

dsce "$amyFolder/$version/root/System/Library/dyld/dyld_shared_cache_x86_64" $dsceList
cp -R Out/System/Library/Extensions/ .
rm -r Out

```
