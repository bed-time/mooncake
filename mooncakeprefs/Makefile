export ARCHS = arm64 arm64e
export TARGET = iphone:clang::13.1.3
export GO_EASY_ON_ME = 1

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = mooncakeprefs

mooncakeprefs_FILES = mcpRootListController.m
mooncakeprefs_FRAMEWORKS = UIKit
mooncakeprefs_PRIVATE_FRAMEWORKS = Preferences
mooncakeprefs_INSTALL_PATH = /Library/PreferenceBundles
mooncakeprefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk
