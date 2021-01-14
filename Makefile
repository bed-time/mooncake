export THEOS_DEVICE_IP = 192.168.0.19

export ARCHS = arm64 arm64e
export TARGET = iphone:clang::13.1.3
export GO_EASY_ON_ME = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Mooncake

Mooncake_FILES = Tweak.xm
Mooncake_CFLAGS = -fobjc-arc

Mooncake_EXTRA_FRAMEWORKS += Cephei

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += mooncakeprefs
include $(THEOS_MAKE_PATH)/aggregate.mk

after-install::
	install.exec "killall -9 SpringBoard"
