TARGET := iphone:clang:latest:7.0

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = mooncakeprefs

mooncakeprefs_FILES = mcpRootListController.m
mooncakeprefs_FRAMEWORKS = UIKit
mooncakeprefs_EXTRA_FRAMEWORKS += Cephei CepheiPrefs
mooncakeprefs_PRIVATE_FRAMEWORKS = Preferences
mooncakeprefs_INSTALL_PATH = /Library/PreferenceBundles
mooncakeprefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk
