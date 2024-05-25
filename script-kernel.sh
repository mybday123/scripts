#!/bin/bash
set -e

msger()
{
	while getopts ":n:e:" opt
	do
		case "${opt}" in
			n) printf "[*] $2 \n" ;;
			e) printf "[×] $2 \n"; return 1 ;;
		esac
	done
}

cdir()
{
	cd "$1" 2>/dev/null || msger -e "The directory $1 doesn't exists !"
}

KERNEL_DIR="$(pwd)"
BASEDIR="$(basename "$KERNEL_DIR")"

clone() {
	git clone --depth=1 https://gitlab.com/Panchajanya1999/azure-clang.git clang-llvm
	TC_DIR=$KERNEL_DIR/clang-llvm

	# git clone --depth 1 --no-single-branch https://github.com/mybday123/AnyKernel3.git
}

exports()
{
	SUBARCH=$ARCH
	PATH=$TC_DIR/bin/:$PATH
	PROCS=$(nproc --all)

	export  ARCH=arm64
 	export  SUBARCH PATH PROCS 
}

compile() {
	make O=out floral-new_defconfig
	make O=out CC=clang CROSS_COMPILE=aarch64-linux-gnu- CROSS_COMPILE_ARM32=arm-linux-gnueabi- AR=llvm-ar OBJDUMP=llvm-objdump STRIP=llvm-strip NM=llvm-nm OBJCOPY=llvm-objcopy -j$(nproc --all)
}
clone
exports
compile
