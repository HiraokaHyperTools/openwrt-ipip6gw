#
# Copyright (C) 2013 OpenWrt.org
# Copyright (C) 2021 kenjiuno
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=ipip6gw
PKG_VERSION:=0.1
PKG_RELEASE:=11
PKG_LICENSE:=GPL-2.0
PKG_MAINTAINER:=kenjiuno

include $(INCLUDE_DIR)/package.mk

define Package/ipip6gw
  SECTION:=net
  CATEGORY:=Network
  DEPENDS:=@IPV6 +kmod-ip6-tunnel +resolveip
  TITLE:=ipip6gw configuration support
  MAINTAINER:=kenjiuno <ku@digitaldolphins.jp>
  PKGARCH:=all
endef

define Package/ipip6gw/description
Provides support for ipip6gw in /etc/config/network.
endef

define Build/Compile
endef

define Build/Configure
endef

define Package/ipip6gw/install
	$(INSTALL_DIR) $(1)/lib/netifd/proto
	$(INSTALL_BIN) ./files/ipip6gw.sh $(1)/lib/netifd/proto/ipip6gw.sh
	$(INSTALL_DIR) $(1)/www/luci-static/resources/protocol/
	$(INSTALL_BIN) ./files/ipip6gw.js $(1)/www/luci-static/resources/protocol/ipip6gw.js
endef

$(eval $(call BuildPackage,ipip6gw))
