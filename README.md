# Mageia container templates

Build LXC, Incus and Docker images of [Mageia](https://www.mageia.org).

## Status

[![LXC](https://github.com/Chiogros/image-mageia/actions/workflows/build-lxc-image.yaml/badge.svg)](https://github.com/Chiogros/image-mageia/actions/workflows/build-lxc-image.yaml)
[![Incus](https://github.com/Chiogros/image-mageia/actions/workflows/build-incus-image.yaml/badge.svg)](https://github.com/Chiogros/image-mageia/actions/workflows/build-incus-image.yaml)
[![Docker](https://github.com/Chiogros/image-mageia/actions/workflows/build-docker-image.yaml/badge.svg)](https://github.com/Chiogros/image-mageia/actions/workflows/build-docker-image.yaml)

## Installation and usage

Releases version names are set as follow:
- 1<sup>st</sup> digit: official Mageia version
- 2<sup>nd</sup> digit: major image release
- 3<sup>rd</sup> digit: minor image release

> e.g. v9.1.1: image release 1.1.0 for Mageia 9

Stable images are available on
[`Releases`](https://github.com/Chiogros/image-mageia/tags) page.

Testing images are available on
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
$ qemu-img convert -f qcow2 -O vdi disk.qcow2 disk.vdi
```

2.  In VirtualBox, create an empty VM with **EFI** enabled.
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

Want to learn more about how the images are created?

Take a look at the [contributing guide](CONTRIBUTING.md).
