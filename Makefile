DIST = mageia
DIST_VER = 9
CT_NAME := $(DIST)$(DIST_VER)
CT_PATH := $(shell pwd)/$(CT_NAME)

ROOTFS = rootfs
OUT = out

distrobuilder = distrobuilder
brctl = brctl

minimal-fs:
	mkdir -v $(CT_NAME)

	$(info Initializing RPM database...)
	rpm --rebuilddb --root=$(CT_PATH)

	$(info Configuring repositories...)
	sudo urpmi.addmedia --distrib http://ftp.free.fr/mirrors/mageia.org/distrib/$(DIST_VER)/x86_64 --urpmi-root $(CT_PATH)

	$(info Installing minimal system...)
	sudo urpmi basesystem-minimal urpmi mageia-release-Default mageia-release-common lsb-release systemd locales locales-en xz dhcp-client curl --auto --no-recommends --urpmi-root $(CT_PATH) --root $(CT_PATH)

squash-fs:
	$(info Squashing FS...)
	mksquashfs $(CT_NAME) $(CT_NAME).sqfs

build: $(DIST).yaml
	$(info Building root FS...)
	$(distrobuilder) build-dir $(DIST).yaml $(ROOTFS)

	$(info Packing container...)
	mkdir $(OUT) || true
	$(distrobuilder) pack-lxc $(DIST).yaml $(ROOTFS) $(OUT)

lxc-create:
	lxc-create --name "${CT_NAME}" --template local -- --fstree $(OUT)/rootfs.tar.xz --metadata $(OUT)/meta.tar.xz

lxc-start:
	lxc-start -n $(CT_NAME)

clean:
	lxc-stop $(CT_NAME) || true
	lxc-destroy $(CT_NAME) || true
	rm -rf $(ROOTFS) $(OUT) $(CT_NAME) $(CT_NAME).sqfs
