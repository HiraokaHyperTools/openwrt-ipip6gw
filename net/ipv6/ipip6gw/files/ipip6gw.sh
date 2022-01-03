#!/bin/sh
# ipip6.sh - ipip6 tunnel backend
# Copyright (c) 2013 OpenWrt.org
# Copyright (c) 2021 kenjiuno

[ -n "$INCLUDE_ONLY" ] || {
	. /lib/functions.sh
	. /lib/functions/network.sh
	. ../netifd-proto.sh
	init_proto "$@"
}

proto_ipip6gw_setup() {
	local cfg="$1"
	local remoteip

	local df ipaddr peeraddr tunlink ttl tos zone mtu
	json_get_vars df ipaddr peeraddr tunlink ttl tos zone mtu

	[ -z "$peeraddr" ] && {
		proto_notify_error "$cfg" "MISSING_PEER_ADDRESS"
		proto_block_restart "$cfg"
		return
	}

	remoteip=$(resolveip -t 10 -6 "$peeraddr")

	if [ -z "$remoteip" ]; then
		proto_notify_error "$cfg" "PEER_RESOLVE_FAIL"
		return
	fi

	for ip in $remoteip; do
		peeraddr=$ip
		break
	done

	( proto_add_host_dependency "$cfg" "$peeraddr" "$tunlink" )

	[ -z "$ipaddr" ] && {
		local wanif="$tunlink"
		if [ -z $wanif ] && ! network_find_wan wanif; then
			proto_notify_error "$cfg" "NO_WAN_LINK"
			return
		fi

		if ! network_get_ipaddr ipaddr "$wanif"; then
			proto_notify_error "$cfg" "NO_WAN_LINK"
			return
		fi
	}

	proto_init_update "ipip6gw-$cfg" 1
	if [ -n "$tun_localip" -a -n "$tun_remoteip"]; then
		proto_add_ipv4_address "$tun_localip" "" "" "$tun_remoteip"
	fi

	for allowed_ip in ${tun_routes}; do
		case "${allowed_ip}" in
			*.*/*)
				proto_add_ipv4_route "${allowed_ip%%/*}" "${allowed_ip##*/}"
				;;
			*.*)
				proto_add_ipv4_route "${allowed_ip%%/*}" "32"
				;;
		esac
	done

	json_add_string mode ipip6
	json_add_int mtu "${mtu:-1280}"
	json_add_int ttl "${ttl:-64}"
	[ -n "$tos" ] && json_add_string tos "$tos"
	json_add_string local "$ipaddr"
	json_add_string remote "$peeraddr"
	[ -n "$tunlink" ] && json_add_string link "$tunlink"
	json_add_boolean df "${df:-1}"

	proto_close_tunnel

	proto_add_data
	[ -n "$zone" ] && json_add_string zone "$zone"
	proto_close_data

	proto_send_update "$cfg" || sleep 1
}

proto_ipip6gw_teardown() {
	local cfg="$1"
}

proto_ipip6gw_init_config() {
	no_device=1
	available=1

	proto_config_add_int "mtu"
	proto_config_add_int "ttl"
	proto_config_add_string "tos"
	proto_config_add_string "tunlink"
	proto_config_add_string "zone"
	proto_config_add_string "ipaddr"
	proto_config_add_string "peeraddr"
	proto_config_add_boolean "df"
}

[ -n "$INCLUDE_ONLY" ] || {
	add_protocol ipip6gw
}
