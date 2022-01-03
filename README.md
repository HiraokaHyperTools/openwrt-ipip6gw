# ipip6 package feed

## Description

This is an ipip6gw package feed containing community maintained package.

## Usage

To use these packages, add the following line to the feeds.conf
in the OpenWrt buildroot:

```
src-git ipip6gw https://github.com/HiraokaHyperTools/openwrt-ipip6gw.git
```

This feed should be included and enabled by default in the OpenWrt buildroot. To install all its package definitions, run:

```
./scripts/feeds update ipip6gw
./scripts/feeds install ipip6gw
```

The ipip6 package should now appear in menuconfig.

This will make package `bin/packages/mipsel_24kc/ipip6gw/ipip6gw.1-4_all.ipk` or such.

```
make package/ipip6/compile
```
