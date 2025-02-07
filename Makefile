INSTALL_TARGET_PROCESSES = PineBoard ReProvision
export THEOS=/Users/$(shell whoami)/Projects/theos
ARCHS = arm64
TARGET = appletv
target ?= appletv
export GO_EASY_ON_ME=1
DEBUG=0
THEOS_DEVICE_IP=living-room.local
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = bh4x

bh4x_FILES = Tweak.xm
bh4x_CFLAGS = -fobjc-arc
bh4x_PRIVATE_FRAMEWORKS = PineBoardServices
bh4x_LDFLAGS = -F.

include $(THEOS_MAKE_PATH)/tweak.mk

after-stage::
	#cp $(THEOS_STAGING_DIR)/Library/MobileSubstrate/DynamicLibraries/bulletinh4x.*  ../Package/Library/MobileSubstrate/DynamicLibraries/
#SUBPROJECTS += breh
#include $(THEOS_MAKE_PATH)/aggregate.mk
