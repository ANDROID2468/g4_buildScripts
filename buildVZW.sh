#!/bin/bash

# rom name (change this for what rom your building)
os=lineage

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
    #cp out/target/product/$1 Roms/$1 | tee -a log_$1.txt
    #rm -rf out | tee -a log_$1.txt
    #echo "The rom, "$os" OS for $1 is in the Roms folder " | tee -a log_$1.txt
}


# removing old builds
echo "deleting The out directory"
rm -rf out

# build setup

source build/envsetup.sh

# removing old build logs
echo "removing old build logs"
rm -f log_vs986_usu.txt

# vs986_usu
clean_build
echo "starting build for vs986_usu" | tee -a log_vs986_usu.txt
breakfast "$os"_vs986_usu-userdebug | tee -a log_vs986_usu.txt
brunch "$os"_vs986_usu-userdebug | tee -a log_vs986_usu.txt
arb_2 vs986_usu
clean_build



echo "Done!"