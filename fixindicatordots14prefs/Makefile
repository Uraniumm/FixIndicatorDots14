TARGET := iphone:clang:14.4:14.4

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = FixIndicatorDots14Prefs

FixIndicatorDots14Prefs_FILES = FIDRootListController.m
FixIndicatorDots14Prefs_FRAMEWORKS = UIKit
FixIndicatorDots14Prefs_PRIVATE_FRAMEWORKS = Preferences
FixIndicatorDots14Prefs_INSTALL_PATH = /Library/PreferenceBundles
FixIndicatorDots14Prefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk
