#!/bin/bash

OUTPUT="$(pwd)/images"
BUILD_VERSION="22.03.3"
BOARD_NAME="mediatek"
BOARD_SUBNAME="mt7622"
BUILDER="https://downloads.openwrt.org/releases/${BUILD_VERSION}/targets/${BOARD_NAME}/${BOARD_SUBNAME}/openwrt-imagebuilder-${BUILD_VERSION}-${BOARD_NAME}-${BOARD_SUBNAME}.Linux-x86_64.tar.xz"
KERNEL_PARTSIZE=20 #Kernel-Partitionsize in MB
ROOTFS_PARTSIZE=28000 #Rootfs-Partitionsize in MB

BASEDIR=$(realpath "$0" | xargs dirname)

# download image builder
if [ ! -f "${BUILDER##*/}" ]; then
	wget "$BUILDER"
	tar xJvf "${BUILDER##*/}"
fi

[ -d "${OUTPUT}" ] || mkdir "${OUTPUT}"

cd openwrt-*/

# clean previous images
make clean

# Packages are added if no prefix is given, '-packaganame' does not integrate a package
sed -i "s/CONFIG_TARGET_KERNEL_PARTSIZE=.*/CONFIG_TARGET_KERNEL_PARTSIZE=$KERNEL_PARTSIZE/g" .config
sed -i "s/CONFIG_TARGET_ROOTFS_PARTSIZE=.*/CONFIG_TARGET_ROOTFS_PARTSIZE=$ROOTFS_PARTSIZE/g" .config

make image PROFILE="bananapi_bpi-r64" \
           PACKAGES="block-mount kmod-fs-ext4 kmod-usb-storage blkid mount-utils swap-utils e2fsprogs fdisk luci dnsmasq bash lsblk" \
           FILES="${BASEDIR}/files/" \
            BIN_DIR="$OUTPUT"



