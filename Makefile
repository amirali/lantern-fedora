SHELL = bash

VERSION = 6.7.9
ARCH = $(shell uname -i)

.PHONY: install clean

install:
ifneq ($(shell id -u),0)
	@echo Run 'make install' as root
	exit 1
endif

ifeq ($(ARCH),x86_64)
	wget https://s3.amazonaws.com/lantern/lantern-installer-$(VERSION)-64-bit.deb
	ar vx lantern-installer-$(VERSION)-64-bit.deb
else ifeq ($(ARCH),i686)
	wget https://s3.amazonaws.com/lantern/lantern-installer-$(VERSION)-32-bit.deb
	ar vx lantern-installer-$(VERSION)-32-bit.deb
else
	@echo The architecture is not 32 or 64 bit
	exit 1
endif
	
	tar xvf data.tar.gz
	
	cp -r usr /

	dnf install libappindicator-gtk3 libpcap libpcap-devel -y

ifeq ($(ARCH),x86_64)
	ln -s /usr/lib64/libpcap.so.1 /usr/lib64/libpcap.so.0.8
else
	ln -s /usr/lib/libpcap.so.1 /usr/lib/libcap.so.0.8
endif

	@echo Lantern installed sucessfully


clean:
	@rm -r usr data.tar.gz control.tar.gz lantern-installer-$(VERSION)-*-bit.deb debian-binary


remove:
	@rm -r /usr/bin/lantern /usr/lib/lantern/ /usr/share/applications/lantern.desktop /usr/share/doc/lantern/ /usr/share/icons/hicolor/128x128/apps/lantern.png
	@echo Lantern removed sucessfully
