INSTALL_TARGET_PROCESSES = SpringBoard
override _THEOS_TARGET_SWIFT_VERSION_PATH = ../swift # so that ld won't use rpath to /usr/lib/libswift/stable

DEBUG = 1
ARCHS = arm64
TARGET = iphone:clang:13.2:12.4

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = saisaki
saisaki_FILES = Tweak.xm $(wildcard ../banner/*)
_THEOS_INTERNAL_LDFLAGS += -dead_strip -L\$(DEVELOPER_DIR)/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift-5.0/iphoneos -F\$(DEVELOPER_DIR)/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/System/Library/Frameworks

include $(THEOS_MAKE_PATH)/tweak.mk

BUNDLE_NAME = saisaki-resources
$(BUNDLE_NAME)_RESOURCE_DIRS = ../Resources
$(BUNDLE_NAME)_INSTALL_PATH = /Library/Application Support

include $(THEOS_MAKE_PATH)/bundle.mk
