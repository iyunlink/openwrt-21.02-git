#!/bin/sh
# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright (C) 2013 OpenWrt.org

set -ex
[ $# -eq 4 ] || {
    echo "SYNTAX: $0 <file> <bootfs image> <recfs image> <rootfs image>"
    exit 1
}

OUTPUT="$1"
BOOTFS="$2"
RECFS="$3"
ROOTFS="$4"
BOOTFSSIZE=10
RECFSSIZE=10
ROOTFSSIZE=7000

cp $ROOTFS $ROOTFS.tmp
padjffs2 $ROOTFS.tmp

head=4
sect=63

set $(ptgen -o $OUTPUT -h $head -s $sect -l 1024 -t c -p 10M -t c -p 10M -t 83 -p ${ROOTFSSIZE}M)

BOOTOFFSET="$(($1 / 512))"
BOOTSIZE="$(($2 / 512))"
RECOFFSET="$(($3 / 512))"
RECSIZE="$(($4 / 512))"
ROOTFSOFFSET="$(($5 / 512))"
ROOTFSSIZE="$(($6 / 512))"

dd bs=512 if="$BOOTFS" of="$OUTPUT" seek="$BOOTOFFSET" conv=notrunc
dd bs=512 if="$RECFS" of="$OUTPUT" seek="$RECOFFSET" conv=notrunc
dd bs=512 if="$ROOTFS.tmp" of="$OUTPUT" seek="$ROOTFSOFFSET" conv=notrunc
rm $ROOTFS.tmp
