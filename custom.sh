#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: Custom.sh
# Description: OpenWrt Custom script
#
# Vlmcsd auto activation enabled
echo srv-host=_vlmcs._tcp.lan,OpenWrt.lan,1688,0,100 >> /etc/dnsmasq.conf

# 解决Kmod相关软件包无法安装问题，刷入系统后使/usr/lib/opkg/status中的hash和安装kmod软件包时出错的hash一致。
sed -i 's/060d4a88a59ff936e5d09f59b94a0195/b70ee1516753f10c063dd361f74167d4/g' /usr/lib/opkg/status

#5.更换lede源码中自带argon主题和design主题
rm -rf feeds/luci/themes/luci-theme-argon && git clone -b 23.05 https://github.com/jerrykuku/luci-theme-argon.git feeds/luci/themes/luci-theme-argon
rm -rf feeds/luci/themes/luci-theme-design && git clone --depth 1 https://github.com/gngpp/luci-theme-design feeds/luci/themes/luci-theme-design
rm -rf feeds/luci/applications/luci-app-design-config && git clone --depth 1 https://github.com/gngpp/luci-app-design-config feeds/luci/applications/luci-app-design-config

#7.修改主机名
sed -i "s/hostname='OpenWrt'/hostname='Advan_AT01'/g" package/base-files/files/bin/config_generate

# ARM64: Add CPU model name in proc cpuinfo
wget -P target/linux/generic/pending-5.4 https://github.com/immortalwrt/immortalwrt/raw/master/target/linux/generic/hack-5.4/312-arm64-cpuinfo-Add-model-name-in-proc-cpuinfo-for-64bit-ta.patch
# autocore
sed -i 's/DEPENDS:=@(.*/DEPENDS:=@(TARGET_bcm27xx||TARGET_bcm53xx||TARGET_ipq40xx||TARGET_ipq806x||TARGET_ipq807x||TARGET_mvebu||TARGET_rockchip||TARGET_armvirt) \\/g' package/lean/autocore/Makefile
# Add cputemp.sh
cp -rf $GITHUB_WORKSPACE/PATCH/new/script/cputemp.sh ./package/base-files/files/bin/cputemp.sh

