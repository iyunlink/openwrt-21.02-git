#
# Copyright (c) 2014 The Linux Foundation. All rights reserved.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=aw9523b
PKG_VERSION:=2022-03-01-1026
PKG_RELEASE:=1


PKG_BUILD_DIR:=$(KERNEL_BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define KernelPackage/aw9523b
  CATEGORY:=LINK4ALL
  DEPENDS:=
  TITLE:=aw9523b driver
  FILES:= $(PKG_BUILD_DIR)/gpio-aw9523.ko
  AUTOLOAD:=$(call AutoLoad,10,gpio-aw9523)
endef

define KernelPackage/aw9523b/Description
This package contains a driver for gpio-aw9523
endef

define Build/Prepare
	$(CP) src/* $(PKG_BUILD_DIR)
	$(call Build/Prepare/Default)
endef


MAKE_OPTS:= \
	$(KERNEL_MAKE_FLAGS) \
	M="$(PKG_BUILD_DIR)"

define Build/Compile
	$(MAKE) -C "$(LINUX_DIR)" \
		$(MAKE_OPTS) \
		modules
endef

$(eval $(call KernelPackage,aw9523b))

