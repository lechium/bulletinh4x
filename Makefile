INSTALL_TARGET_PROCESSES = PineBoard ReProvision
ARCHS = arm64
TARGET = appletv
target ?= appletv:clang:10.2.2:10.0
export GO_EASY_ON_ME=1
export SDKVERSION=12.1
DEBUG=0
THEOS_DEVICE_IP=guest-room.local
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = bh4x

bh4x_FILES = Tweak.xm
bh4x_CFLAGS = -fobjc-arc
bh4x_PRIVATE_FRAMEWORKS = PineBoardServices

include $(THEOS_MAKE_PATH)/tweak.mk

after-stage::
	#cp $(THEOS_STAGING_DIR)/Library/MobileSubstrate/DynamicLibraries/bulletinh4x.*  ../Package/Library/MobileSubstrate/DynamicLibraries/
SUBPROJECTS += breh
include $(THEOS_MAKE_PATH)/aggregate.mk
