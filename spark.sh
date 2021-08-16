#!/bin/bash

# User Defined Stuff

folder="/home2/spark"
rom_name="Spark-"*"-alioth-"*.zip
gapps_command="WITH_GAPPS"
with_gapps="yes"
build_type="userdebug"
device_codename="alioth"
use_brunch="yes"
OUT_PATH="$folder/out/target/product/${device_codename}"
lunch="spark"
user="sukeerat"
tg_username="Henlo"

# make_clean="yes"
# make_clean="no"
make_clean="installclean"

# Rom being built

ROM=${OUT_PATH}/${rom_name}

# Folder specifity

cd "$folder"
echo -e "\rBuild starting thank you for waiting"

# Ccache

echo -e ${blu}"CCACHE is enabled for this build"${txtrst}
export CCACHE_EXEC=$(which ccache)
export USE_CCACHE=1
ccache -M 75G

# Time to build

source build/envsetup.sh
export WITH_GMS=true
export SKIP_ABI_CHECKS=true
export TARGET_USES_BLUR=true
export CCACHE_DIR=/home2/spark/ccache
export SPARK_BUILD_TYPE=OFFICIAL
export OVERRIDE_QCOM_HARDWARE_VARIANT=sm8250
export TARGET_FACE_UNLOCK_SUPPORTED=true

if [ "$with_gapps" = "yes" ];
then
export "$gapps_command"=true
export TARGET_GAPPS_ARCH=arm64
fi

if [ "$with_gapps" = "no" ];
then
export "$gapps_command"=false
fi

# Clean build

if [ "$make_clean" = "yes" ];
then
rm -rf ${OUT_PATH}
wait
echo -e ${cya}"OUT dir from your repo deleted"${txtrst};
fi

if [ "$make_clean" = "installclean" ];
then
rm -rf ${OUT_PATH}
wait
echo -e ${cya}"Images deleted from OUT dir"${txtrst};
fi

rm -rf ${OUT_PATH}/*.zip
lunch ${lunch}_${device_codename}-${build_type}
mka spark -j$(nproc --all) 
