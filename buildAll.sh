#!/bin/bash

# rom name (change this for what rom your building)
os=potato

echo "ANDROID2468's build script for "$os" OS"

# Functions 

# ARB (Anti-rollback) check for devices with the ARB of 0
arb_0 () {
    echo "ARB (Anti-rollback) check " | tee -a log_$1.txt
    echo "md5 for venus.mbn" | tee -a log_$1.txt
    md5sum out/target/product/$1/system/etc/firmware/venus.mbn | tee -a log_$1.txt
    echo "d1f6fe863643b1e8d1e597762474928c should be the md5 (ARB 0f 0)" | tee -a log_$1.txt
}

# ARB (Anti-rollback) check for devices with the ARB of 2
arb_2 () {
    echo "ARB (Anti-rollback) check " | tee -a log_$1.txt
    echo "md5 for venus.mbn" | tee -a log_$1.txt
    md5sum out/target/product/$1/system/etc/firmware/venus.mbn | tee -a log_$1.txt
    echo "78e5cf520d0de4a413ef1cfa7bbbe713 should be the md5 (ARB of 2)" | tee -a log_$1.txt
}

# cleans the build env after each  build
clean_build () {
    echo "cleaning up the build environment"
    prebuilts/misc/linux-x86/ccache/ccache -C
    prebuilts/misc/linux-x86/ccache/ccache -M 50G
    cp -r out/target/product/$1 Roms/$1 | tee -a log_$1.txt
    if [[ -d Roms/$1 ]]; then
    	rm -rf out 
    	echo "The rom for $1 is in the Roms folder " | tee -a log_$1.txt
    fi
}


# removing old builds
echo "deleting The out directory"
rm -rf out
rm -rf Roms

# build setup
mkdir Roms
source build/envsetup.sh

# removing old build logs
echo "removing old build logs"
rm -f log_vs986_usu.txt
rm -f log_h815.txt
rm -f log_h815_usu.txt
rm -f log_h811.txt
rm -f log_h812_usu.txt
rm -f log_h810_usu.txt

# vs986_usu
echo "starting build for vs986_usu" | tee -a log_vs986_usu.txt
breakfast "$os"_vs986_usu-userdebug | tee -a log_vs986_usu.txt
brunch "$os"_vs986_usu-userdebug | tee -a log_vs986_usu.txt
arb_2 vs986_usu
clean_build vs986_usu

# h810_usu
echo "starting build for h810_usu" | tee -a log_h810_usu.txt
breakfast "$os"_h810_usu-userdebug | tee -a log_h810_usu.txt
brunch "$os"_h810_usu-userdebug | tee -a log_h810_usu.txt
arb_2 h810_usu
clean_build h810_usu

# h811
echo "starting build for h811" | tee -a log_h811.txt
breakfast "$os"_h811-userdebug | tee -a log_h811.txt
brunch "$os"_h811-userdebug | tee -a log_h811.txt
arb_2 h811
clean_build h811

# sleep for 30 min
echo "letting computer cool down for 30 mins"
sleep 30m

# h812_usu
echo "starting build for h812" | tee -a log_h812_usu.txt
breakfast "$os"_h812_usu-userdebug | tee -a log_h812_usu.txt
brunch "$os"_h812_usu-userdebug | tee -a log_h812_usu.txt
arb_2 h812_usu
clean_build h812_usu

# h815
echo "starting build for h815" | tee -a log_h815.txt
breakfast "$os"_h815-userdebug | tee -a log_h815.txt
brunch "$os"_h815-userdebug | tee -a log_h815.txt
arb_0 h815
clean_build h815

# h815_usu
echo "starting build for h815_usu" | tee -a log_h815_usu.txt
breakfast "$os"_h815_usu-userdebug | tee -a log_h815_usu.txt
brunch "$os"_h815_usu-userdebug | tee -a log_h815_usu.txt
arb_0 h815_usu
clean_build h815_usu

echo "Done!"