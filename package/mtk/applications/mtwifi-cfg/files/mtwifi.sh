#!/bin/sh
#
# Copyright (C) 2023, hanwckf <hanwckf@vip.qq.com>
#

append DRIVERS "mtwifi"
. /lib/functions/system.sh

detect_mtwifi() {
	local idx ifname
	local band hwmode htmode htbsscoex ssid dbdc_main
	if [ -d "/sys/module/mt_wifi" ]; then
		dev_list="$(l1util list)"
		mac="$(mtd_get_mac_binary Factory 0x4)"
		gmac="$(macaddr_add $mac 1)"
		for dev in $dev_list; do
			config_get type ${dev} type
			[ "$type" = "mtwifi" ] || {
				ifname="$(l1util get ${dev} main_ifname)"
				idx="$(l1util get ${dev} subidx)"
				if [ $idx -eq 1 ]; then
					band="2g"
					hwmode="11g"
					htmode="HE40"
					htbsscoex="1"
					suffix="$(echo ${mac:11:8} | tr 'a-z' 'A-Z' |tr -d ':')"
					ssid="M81-2G-${suffix}"
					dbdc_main="0"
					idx=2
					nw="wwan"
				else
					band="5g"
					hwmode="11a"
					htmode="HE80"
					htbsscoex="0"
					
					suffix="$(echo ${gmac:11:8} | tr 'a-z' 'A-Z' |tr -d ':')"
					ssid="M81-5G-${suffix}"
					dbdc_main="1"
					idx=3
					nw="wwan1"
				fi
				uci -q batch <<-EOF
					set wireless.${dev}=wifi-device
					set wireless.${dev}.type=mtwifi
					set wireless.${dev}.phy=${ifname}
					set wireless.${dev}.hwmode=${hwmode}
					set wireless.${dev}.band=${band}
					set wireless.${dev}.dbdc_main=${dbdc_main}
					set wireless.${dev}.channel=auto
					set wireless.${dev}.txpower=100
					set wireless.${dev}.htmode=${htmode}
					set wireless.${dev}.country=CN
					set wireless.${dev}.mu_beamformer=1
					set wireless.${dev}.noscan=${htbsscoex}
					set wireless.${dev}.serialize=1

					set wireless.default_${dev}=wifi-iface
					set wireless.default_${dev}.device=${dev}
					set wireless.default_${dev}.network=lan
					set wireless.default_${dev}.mode=ap
					set wireless.default_${dev}.ssid=${ssid}
					set wireless.default_${dev}.encryption=psk2
					set wireless.default_${dev}.key='12345678'

					set wireless.wifinet${idx}=wifi-iface 
					set wireless.wifinet${idx}.device=${dev}
					set wireless.wifinet${idx}.mode='sta'
					set wireless.wifinet${idx}.network=${nw}
					set wireless.wifinet${idx}.key='12345678'
					set wireless.wifinet${idx}.ssid="M81_$(echo ${band} | tr 'a-z' 'A-Z')"
					set wireless.wifinet${idx}.encryption='psk'
					set wireless.wifinet${idx}.disabled='1'
EOF
				uci -q commit wireless
			}
		done
# 		uci -q batch <<-USER_CUSTOM
# 			set wireless.MT7981_1_2.htmode='HE80'
# 			set wireless.default_MT7981_1_1.encryption='psk2'
# 			set wireless.default_MT7981_1_1.key='12345678'
# 			set wireless.default_MT7981_1_2.encryption='psk2'
# 			set wireless.default_MT7981_1_2.key='12345678'
# 			set wireless.wifinet2=wifi-iface 
# 			set wireless.wifinet2.device='MT7981_1_1'
# 			set wireless.wifinet2.mode='sta'
# 			set wireless.wifinet2.network='wwan'
# 			set wireless.wifinet2.key='12345678'
# 			set wireless.wifinet2.ssid='M81_2.4G'
# 			set wireless.wifinet2.encryption='psk'
# 			set wireless.wifinet2.disabled='1'
# 			set wireless.wifinet3=wifi-iface 
# 			set wireless.wifinet3.device='MT7981_1_2'
# 			set wireless.wifinet3.mode='sta'
# 			set wireless.wifinet3.network='wwan1'
# 			set wireless.wifinet3.key='12345678'
# 			set wireless.wifinet3.ssid='M81_5.8G'
# 			set wireless.wifinet3.encryption='psk'
# 			set wireless.wifinet3.disabled='1'
# USER_CUSTOM
# 		uci -q commit wireless
	fi
}
