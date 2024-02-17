#!/bin/bash

CONTAINER_NAME="mageia8"
ROOTFS=rootfs
OUT=out

if [ "$UID" -ne 0 ]
then
	echo "You must run it as root."
	exit 1
fi

echo "Stopping and destroying old stuff..."
lxc-stop "${CONTAINER_NAME}" 2> /dev/null
lxc-destroy "${CONTAINER_NAME}" 2> /dev/null
rm -rf ${ROOTFS} ${OUT} 2> /dev/null
mkdir ${OUT}

echo "Building root FS..."
distrobuilder build-dir mageia.yaml ${ROOTFS}
echo "Packing container..."
distrobuilder pack-lxc  mageia.yaml ${ROOTFS} ${OUT}

echo "Creating network bridge..."
#brctl addbr lxcbr0
brctl addbr vmbr0

echo "Adding container to LXC..."
lxc-create --name "${CONTAINER_NAME}" --template local -- --fstree ${OUT}/rootfs.tar.xz --metadata ${OUT}/meta.tar.xz
echo "Starting container..."
#lxc-start -n "${CONTAINER_NAME}" -F
#lxc-start -n "${CONTAINER_NAME}"
