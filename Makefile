export ARCHS = arm64 arm64e
export TARGET = iphone:clang::13.1.3

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Mooncake

Mooncake_FILES = $(wildcard *.x *.xm *.m *.mm)
Mooncake_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += mooncakeprefs
include $(THEOS_MAKE_PATH)/aggregate.mk

after-install::
	install.exec "sbreload"
