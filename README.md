# Mageia-LXC

## Steps
1. [Build Distrobuilder](https://github.com/lxc/distrobuilder#installing-from-source)
2. Set mapped UID/GID
3. Set config files
4. Build Mageia container
5. Add container to LXC
6. Start container

## Build Mageia container
```Bash
# distrobuilder build-lxc ./mageia/scheme.yaml
```

## Add container to LXC
```Bash
lxc-create -n mageia -t local -- --metadata meta.tar.xz --fstree rootfs.tar.xz
```

## Start container
```Bash
# lxc-start -n mageia -F -f .config/lxc/default.conf
bash-5.1# 
```
