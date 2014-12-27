export TARGET=macosx:clang
ARCHS = x86_64
ADDITIONAL_CFLAGS = -fobjc-arc

# Disable dpkg
override PACKAGE_FORMAT := none

include $(THEOS)/makefiles/common.mk

TOOL_NAME = SimpleInjector
SimpleInjector_FILES = main.m task_vaccine/task_vaccine.c
SimpleInjector_FRAMEWORKS = AppKit
SimpleInjector_OBJ_FILES = task_vaccine/build/x86_64/task_vaccine.a

include $(THEOS_MAKE_PATH)/tool.mk

task_vaccine/build/x86_64/task_vaccine.a:
	$(ECHO_NOTHING)cd task_vaccine$(ECHO_END); rake static_64

