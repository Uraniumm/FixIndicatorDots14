TARGET := iphone:clang:latest:7.0
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = FixIndicatorDots14

FixIndicatorDots14_FILES = Tweak.xm
FixIndicatorDots14_CFLAGS = -fobjc-arc
FixIndicatorDots14_EXTRA_FRAMEWORKS += Cephei

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += fixindicatordots14prefs
include $(THEOS_MAKE_PATH)/aggregate.mk
