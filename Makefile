DIST = mageia
DIST_VER = 9
ROOTFS = rootfs
OUT = out

CT_NAME := $(DIST)$(DIST_VER)
CT_PATH := $(shell pwd)/$(CT_NAME)

distrobuilder = /usr/local/bin/distrobuilder
brctl = brctl

minimal-fs:
	[ -d "$(CT_PATH)" ] || sudo mkdir -v $(CT_PATH)

	$(info Initializing RPM database...)
	sudo rpm --rebuilddb --root=$(CT_PATH)

	$(info Configuring repositories...)
	sudo urpmi.addmedia --distrib http://ftp.free.fr/mirrors/mageia.org/distrib/$(DIST_VER)/x86_64 --urpmi-root $(CT_PATH)

	$(info Installing minimal system...)
	sudo urpmi basesystem-minimal urpmi mageia-release-Default mageia-release-common lsb-release systemd locales locales-en xz dhcp-client curl --auto --no-recommends --urpmi-root $(CT_PATH)

squash-fs:
	$(info Squashing FS...)
	sudo mksquashfs $(CT_PATH) $(DIST).sqfs

build-lxc: $(DIST).yaml
	$(info Packing container...)
	sudo $(distrobuilder) build-lxc $(DIST).yaml $(OUT)

build-incus: $(DIST).yaml
	$(info Packing container...)
	sudo $(distrobuilder) build-incus $(DIST).yaml $(OUT) --type=split --vm

build-docker: $(DIST).yaml
	$(info Packing container...)
	sudo unsquashfs $(DIST).sqfs
	sudo tar -C squashfs-root -c . -f docker.tar.xz --xz

clean:
	[ -d "$(OUT)" ] && rm -rf $(OUT)
	[ -f "$(DIST).sqfs" ] && rm "$(DIST).sqfs"
