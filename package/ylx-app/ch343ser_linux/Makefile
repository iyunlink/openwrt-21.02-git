#
# Copyright (C) 2008-2012 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=usb-serial-ch343ser
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk

define KernelPackage/usb-serial-ch343ser
	SUBMENU:=USB Support
	TITLE:=CH343 USB to Dual Serial converter
	FILES:=$(PKG_BUILD_DIR)/usb-serial-ch343ser.ko
	DEPENDS:=+kmod-usb-core
	AUTOLOAD:=$(call AutoLoad,30,usb-serial-ch343ser,1)
	KCONFIG:=
endef

define KernelPackage/usb-serial-ch343ser/description
	Drives CH343 USB to Dual Serial converter. 
endef

MAKE_OPTS:= \
	ARCH="$(LINUX_KARCH)" \
	CROSS_COMPILE="$(TARGET_CROSS)" \
	CXXFLAGS="$(TARGET_CXXFLAGS)" \
	M="$(PKG_BUILD_DIR)" \
	$(EXTRA_KCONFIG)

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./src/driver/* $(PKG_BUILD_DIR)/
endef

define Build/Compile
	$(MAKE) -C "$(LINUX_DIR)" \
		$(MAKE_OPTS) \
		modules
endef

$(eval $(call KernelPackage,usb-serial-ch343ser))
