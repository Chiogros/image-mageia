DIST = mageia
DIST_VER = 9
CT_NAME := $(DIST)$(DIST_VER)
CT_PATH := $(shell pwd)/$(CT_NAME)
LSB_VER = 3.1-5

ROOTFS = rootfs
OUT = out

distrobuilder = distrobuilder
brctl = brctl

minimal-fs:
	mkdir -v $(CT_NAME)

	$(info Crafting basic filesystem...)
	rpm --rebuilddb --root=$(CT_PATH)

	$(info Installing base RPMs...)
	rpm --root=$(CT_PATH) --nodeps -ivh http://ftp.free.fr/mirrors/mageia.org/distrib/$(DIST_VER)/x86_64/media/core/release/mageia-release-Default-$(DIST_VER)-2.mga$(DIST_VER).x86_64.rpm
	rpm --root=$(CT_PATH) --nodeps -ivh http://ftp.free.fr/mirrors/mageia.org/distrib/$(DIST_VER)/x86_64/media/core/release/mageia-release-common-$(DIST_VER)-2.mga$(DIST_VER).x86_64.rpm
	rpm --root=$(CT_PATH) --nodeps -ivh http://ftp.free.fr/mirrors/mageia.org/distrib/$(DIST_VER)/x86_64/media/core/release/lsb-release-$(LSB_VER).mga$(DIST_VER).noarch.rpm

	$(info Configuring repositories...)
	urpmi.addmedia --distrib http://ftp.free.fr/mirrors/mageia.org/distrib/$(DIST_VER)/x86_64 --urpmi-root $(CT_PATH)

	$(info Installing minimal system...)
	urpmi basesystem-minimal urpmi locales locales-en dhcp-client curl systemd --auto --no-recommends --urpmi-root $(CT_PATH) --root $(CT_PATH)

squash-fs:
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
