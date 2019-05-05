#!/bin/bash

#set -e

# install depend rpms for tarball
yum install SDL2 autogen-libopts boost-system boost-thread brlapi brltty celt051 corosync corosynclib cyrus-sasl flite glusterfs glusterfs-api glusterfs-cli glusterfs-fuse glusterfs-libs gnutls-dane gnutls-utils libatomic_ops libcacard libfdt libibverbs libiscsi libnfs libqb librados2 librbd1 librdmacm libwsman1 lzop netcf-libs numad radvd sheepdog snappy spice-server tslib usbredir virglrenderer vte3 yajl -y

#yum install kernel-kvm-host-core kernel-kvm-host-modules kernel-kvm-host-modules-extra linux-kvm-guest libvirt libvirt-daemon virt-manager virt-viewer qemu-system-mips openssh-askpass  -y
yum install  libvirt-daemon virt-manager virt-viewer  openssh-askpass  -y

wget tarball.tar.gz
tar vxf tarball.tar.gz
cd tarball
tar vxf kernel-kvm-host.tar.gz -C /
tar vxf kernel-kvm-guest.tar.gz -C /
tar vxf qemu.tar.gz -C /
tar vxf libvirt.tar.gz -C /
