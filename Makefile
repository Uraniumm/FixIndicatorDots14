ARCHS = arm64 arm64e
TARGET := iphone:clang:14.4:latest
INSTALL_TARGET_PROCESSES = SpringBoard
THEOS_DEVICE_IP = 192.168.1.242

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = CryptoClock

CryptoClock_FILES = Tweak.xm
CryptoClock_CFLAGS = -fobjc-arc
CryptoClock_EXTRA_FRAMEWORKS += Cephei

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += cryptoclockprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
