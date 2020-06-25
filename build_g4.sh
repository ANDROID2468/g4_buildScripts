#!/bin/bash

# rom name (change this for what rom your building)
model="${1}"
os=potato

echo "ANDROID2468's build script for "$os" OS"

if [ "${model}" = "" ];
then
    echo "What tablet do you have?"
    read -p 'vs986_usu, h811, h812, h815, h815_usu, h810, etc: ' model
fi

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
}


# removing old builds
echo "deleting The out directory"
rm -rf out
# removing old build logs
echo "removing old build logs"
rm -f log_"$model".txt

# build
clean_build
echo "starting build for "$model"" | tee -a log_vs986_usu.txt
breakfast "$os"_vs986_usu-userdebug | tee -a log_vs986_usu.txt
brunch "$os"_"$model"-userdebug | tee -a log_vs986_usu.txt

# ARB check
if [ "${model}" = "h815" ];
then
    arb_0 $model
elif [ "${model}" = "h815_usu" ];
then
    arb_0 $model
else
    arb_2 $model
fi
