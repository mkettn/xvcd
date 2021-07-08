O=.

all:
	@echo "Select appropriate target for your platform and make it:"
	@echo "make raspi"
	@echo "make raspi-vpn"
	@echo "make macos"
	@echo "make slc6"
	@echo "make centos7"

raspi:
	$(MAKE) -C src O=$(O) USE_GETIFADDRS=wlan0

raspi-vpn:
	$(MAKE) -C src O=$(O) USE_GETIFADDRS=tap0

macos:
	$(MAKE) -C src O=$(O) USE_GETIFADDRS=en0

slc6:
	$(MAKE) -C src O=$(O) USE_GETIFADDRS=eth0

centos7:
	$(MAKE) -C src O=$(O) USE_GETIFADDRS=em1


PREFIX?=/usr/local/bin

install: src/xvcdbb src/xvcdmp src/xvcdbcp
	install $^ $(PREFIX)
.PHONY: install
