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

# ARM64: Add CPU model name in proc cpuinfo
wget -P target/linux/generic/pending-5.4 https://github.com/immortalwrt/immortalwrt/raw/master/target/linux/generic/hack-5.4/312-arm64-cpuinfo-Add-model-name-in-proc-cpuinfo-for-64bit-ta.patch
# autocore
sed -i 's/DEPENDS:=@(.*/DEPENDS:=@(TARGET_armsr/armv8||TARGET_bcm53xx||TARGET_ipq40xx||TARGET_ipq806x||TARGET_ipq807x||TARGET_mvebu||TARGET_rockchip||TARGET_armvirt) \\/g' package/lean/autocore/Makefile
# Add cputemp.sh
cp -rf $GITHUB_WORKSPACE/PATCH/new/script/cputemp.sh ./package/base-files/files/bin/cputemp.sh

