# Mageia LXC template
A lightweight template for easy deployments.

## Development
Multiple stages are needed to go from an empty filesystem to a ready-to-go Mageia.
1. Craft minimal system: install core (and some extra) packages needed for the newly built system
2. Compress read-only filesystem: reduce built system size
3. Build for target: target specific modifications (e.g. needed packages for VM), metadata, filesystem edits

As `urpmi` is used to install the needed packages, it is adviced to build image from a Mageia (virtual) machine.
It should not be too hard to allow building from another host package manager.

Building process is made available through the Makefile.

### Craft minimal system
Makefile target: `minimal-fs`

Steps:
- Initialize the RPM database for Mageia in a directory
- Add Mageia repositories in host package manager source lists
- Install OS specific packages: `mageia-release-Default`, `mageia-release-common`, `lsb-release`
- Install basic packages: `urpmi`, `locales`, `systemd`, ...

### Compress read-only filesystem
Makefile target: `squashfs`

Output is a `.sqfs` file.

### Build for target
Makefile target: `build`

[Distrobuilder](https://linuxcontainers.org/distrobuilder/introduction/) needs an image config file: `mageia.yaml`.

`mageia.yaml` describes:
- Image metadata: OS, version, arch  
- Extra packages to install -> TBD
- Scripts to execute inside the new system
- Targets: vm, container, cloud, ...default

`Distrobuilder` is used twice:
1. Apply FS modifications: basic config, set locale, fix symlinks, ...
2. Pack FS for LXC: produce `rootfs` and `meta`data files

## Testing
Generated images are available in [`Releases`](https://github.com/Chiogros/image-mageia-lxc/tags) page.

### Proxmox
Proxmox allows to run LXC containers from publicly available templates, or from an uploaded one.

#### GUI
On WebUI, you can import Mageia's rootfs by going to: `Storage > CT Templates > Upload`

You can then create a new container.

#### CLI
TDB

### LXC
TDB
