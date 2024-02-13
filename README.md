# Mageia container templates

A lightweight template for easy deployments.

Allows building of LXC, Incus and Docker images.

## Status

[![Build LXC
image](https://github.com/Chiogros/image-mageia/actions/workflows/build-lxc-image.yaml/badge.svg)](https://github.com/Chiogros/image-mageia/actions/workflows/build-lxc-image.yaml)
[![Build Incus
image](https://github.com/Chiogros/image-mageia/actions/workflows/build-incus-image.yaml/badge.svg)](https://github.com/Chiogros/image-mageia/actions/workflows/build-incus-image.yaml)
[![Build Docker
image](https://github.com/Chiogros/image-mageia/actions/workflows/build-docker-image.yaml/badge.svg)](https://github.com/Chiogros/image-mageia/actions/workflows/build-docker-image.yaml)

## Installation and usage

Stable generated images are available on
[`Releases`](https://github.com/Chiogros/image-mageia/tags) page.

Testing generated images are available on
[`Actions`](https://github.com/Chiogros/image-mageia/actions) page.

### LXC

#### Proxmox

On WebUI, you can import Mageia's `rootfs.tar.xz` by going to:
`Storage > CT Templates > Upload`

You can then create a new container.

#### LXC CLI

TDB

### Incus

#### CLI

``` Sh
$ incus image import incus.tar.xz disk.qcow2
```

#### QEMU

- GUI `virt-manager`: add `disk.qcow2` as a **SATA** device and set the
  machine in **UEFI**.

- CLI `qemu` tool:

``` Sh
$ qemu-system-x86_64
```

#### VirtualBox

1.  Convert `qcow2` to `vdi`:

``` Sh
qemu-img convert -f qcow2 -O vdi disk.qcow2 disk.vdi
```

2.  In VirtualBox, create an empty VM.
3.  Add the previously generated `disk.vdi` as a **SATA** device.

### Docker

You can import Mageia's `docker.tar.xz` in registry:

``` Sh
$ docker import ./docker.tar.xz mageia:<version>
```

Then test the image:

``` Sh
$ docker run -it mageia:<version> bash
```

## Development

Multiple stages are needed to go from an empty filesystem to a
ready-to-go Mageia.

1.  Craft minimal system: install core (and some extra) packages needed
    for the newly built system
2.  Compress filesystem read-only: reduce built system size
3.  Build for target: target specific modifications (e.g. needed
    packages for VM), metadata, filesystem edits

As `urpmi` is used to install the needed packages, it is adviced to
build image from a Mageia (virtual) machine. It should not be too hard
to allow building from another host package manager.

Building process is made available through the Makefile.

### Craft minimal system

Makefile target: `minimal-fs`

Steps:

- Initialize the RPM database for Mageia in a directory
- Add Mageia repositories in host package manager source lists
- Install OS specific packages: `mageia-release-Default`,
  `mageia-release-common`, `lsb-release`
- Install basic packages: `urpmi`, `locales`, `systemd`, ...

### Compress filesystem read-only

Makefile target: `squash-fs`

Output is a `.sqfs` file.

### Build for target

Makefile target: `build`

[Distrobuilder](https://linuxcontainers.org/distrobuilder/introduction/)
needs an image config file: `mageia.yaml`.

`mageia.yaml` describes:

- Image metadata: OS, version, arch
- Extra packages to install -\> TBD
- Scripts to execute inside the new system
- Targets: vm, container, cloud, ...default

`Distrobuilder` is used for:

1.  Applying system modifications: basic config, set locale, fix
    symlinks, ...
2.  Packing for LXC: produce `rootfs` and `meta` data files, plus
    `qcow2` for Incus
