export ARCHS = arm64 arm64e
export TARGET = iphone:clang::13.1.3
export GO_EASY_ON_ME = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Mooncake

Mooncake_FILES = $(wildcard *.xm *.x *.m)
Mooncake_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += mooncakeprefs
include $(THEOS_MAKE_PATH)/aggregate.mk

after-install::
	install.exec "killall -9 SpringBoard"
