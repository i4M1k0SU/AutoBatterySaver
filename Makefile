ARCHS = armv7 armv7s arm64
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = AutoBatterySaver
AutoBatterySaver_FILES = Tweak.xm
PACKAGE_VERSION = $(THEOS_PACKAGE_BASE_VERSION)
include $(THEOS_MAKE_PATH)/tweak.mk


SUBPROJECTS += autobatterysaverprefs
include $(THEOS_MAKE_PATH)/aggregate.mk

before-stage::
	find . -name ".DS_STORE" -delete
#after-install::
#install.exec "killall -9 SpringBoard"
