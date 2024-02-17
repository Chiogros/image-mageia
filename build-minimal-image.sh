#!/bin/bash
# Alexandre BOUIJOUX
# Tip: see your distrib's wiki systemd-nspawn page for steps to create a minimal system.

DIST_NAME=$(cat /etc/os-release | cut -d ' ' -f 1)
TGT_DIST="Mageia"
ROOTFS="$PWD/$TGT_DIST"

if [ "$DIST_NAME" != "$TGT_DIST" ]
then
	echo "You must run this script on a $TGT_DIST" >&2
	exit 1
fi

echo "Creating rootfs..."
mkdir "$ROOTFS"
rpm --rebuilddb --root="$ROOTFS"

echo "Installing base RPMs..."
rpm --root="$ROOTFS" --nodeps -ivh http://ftp.free.fr/mirrors/mageia.org/distrib/8/x86_64/media/core/release/mageia-release-Default-8-3.mga8.x86_64.rpm
rpm --root="$ROOTFS" --nodeps -ivh http://ftp.free.fr/mirrors/mageia.org/distrib/8/x86_64/media/core/release/mageia-release-common-8-3.mga8.x86_64.rpm
rpm --root="$ROOTFS" --nodeps -ivh http://ftp.free.fr/mirrors/mageia.org/distrib/8/x86_64/media/core/release/lsb-release-3.1-2.mga8.noarch.rpm

echo "Configuring $TGT_DIST repositories..."
urpmi.addmedia --distrib http://ftp.free.fr/mirrors/mageia.org/distrib/8/x86_64 --urpmi-root "$ROOTFS"

echo "Installing minimal system..."
urpmi basesystem-minimal urpmi locales locales-en systemd --auto --no-recommends --urpmi-root "$ROOTFS" --root "$ROOTFS" 
