include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = AutoBatterySaverPrefs
AutoBatterySaverPrefs_FILES = ABSRootListController.swift
AutoBatterySaverPrefs_INSTALL_PATH = /Library/PreferenceBundles
AutoBatterySaverPrefs_FRAMEWORKS = UIKit
AutoBatterySaverPrefs_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/AutoBatterySaverPrefs.plist$(ECHO_END)
