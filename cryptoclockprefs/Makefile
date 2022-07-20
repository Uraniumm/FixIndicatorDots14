TARGET := iphone:clang:14.4:latest

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = CryptoClockprefs

CryptoClockprefs_FILES = CYCRootListController.m
CryptoClockprefs_FRAMEWORKS = UIKit
CryptoClockprefs_PRIVATE_FRAMEWORKS = Preferences
CryptoClockprefs_INSTALL_PATH = /Library/PreferenceBundles
CryptoClockprefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk
