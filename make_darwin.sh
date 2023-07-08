#!/bin/bash

# This code is written and maintained by Zhenrong WANG
# mailto: zhenrongwang@live.com (*preferred*) | wangzhenrong@hpc-now.com
# The founder of Shanghai HPC-NOW Technologies Co., Ltd (website: https://www.hpc-now.com)
# This code is distributed under the license: GNU Public License - v2.0
# Bug report: info@hpc-now.com

hpcopr_version_code=`cat ./hpcopr/now_macros.h | grep CORE_VERSION_CODE | awk -F"\"" '{print $2}'`
installer_version_code=`cat ./installer/installer.h | grep INSTALLER_VERSION_CODE | awk -F"\"" '{print $2}'`

if [ ! -n "$1" ]; then
	echo "[ -INFO- ] Please specify either 'build', 'delete', or 'clear' when running this command."
	echo "|          build  - (re)build the binaries"
    echo "|          delete - delete the previous binaries"
    echo "|          clear  - remove the 'build' folder"
	echo "[ -DONE- ] Exit now."
    exit 1
elif [ "$1" = "build" ]; then
    echo "[ START: ] Building the binaries now ..."
    echo "[ -INFO- ] Please build hpcmgr with GNU/Linux, not macOS."
    mkdir -p ./build
    rm -rf ./build/*
    clang ./hpcopr/*.c -Wall -o ./build/hpcopr-dwn-${hpcopr_version_code}.exe
    clang -c ./hpcopr/general_funcs.c -o ./installer/gfuncs.o
    rm -rf ./installer/libgfuncs.a
    ar -rc ./installer/libgfuncs.a ./installer/gfuncs.o
    rm -rf ./installer/gfuncs.o
    clang ./installer/installer.c ./installer/libgfuncs.a -Wall -o ./build/installer-dwn-${installer_version_code}.exe
#    clang ./now-crypto/now-crypto.c -Wall -lm -o ./build/now-crypto-dwn.exe
    clang ./now-crypto/now-crypto-v2.c -Wall -lm -o ./build/now-crypto-dwn.exe
    chmod +x ./build/*
    mv ./installer/libgfuncs.a ./build/
elif [ "$1" = "delete" ]; then
    echo "[ START: ] Deleting the binaries now ..."
    rm -rf ./build/*
elif [ "$1" = "clear" ]; then
    echo "[ START: ] Removing the build folder now ..."
    rm -rf ./build
else
    echo "[ -INFO- ] Please specify either 'build', 'delete', or 'clear' when running this command."
	echo "|          build  - (re)build the binaries"
    echo "|          delete - delete the previous binaries"
    echo "|          clear  - remove the 'bin' folder"
	echo "[ -DONE- ] Exit now."
    exit 1
fi
echo "[ -DONE- ] Please check the console output for building results."