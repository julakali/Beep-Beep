THEOS_PACKAGE_DIR_NAME = debs
TARGET =: clang
ARCHS = arm64 armv7 armv7s

DEBUG = 0
GO_EASY_ON_ME = 1
LDFLAGS += -Wl,-segalign,0x4000

include theos/makefiles/common.mk

TWEAK_NAME = BeepBeep

BeepBeep_FILES = Tweak.xm
BeepBeep_FRAMEWORKS = UIKit AudioToolbox AVFoundation

BeepBeep_CFLAGS += -DVERBOSE
BeepBeep_LDFLAGS += -lAccessibility
BeepBeep_CFLAGS += -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk

after-install::
	install.exec "killall -9 SpringBoard"
	
sync: stage
	rsync -e "ssh -p 2222" -avz .theos/_/Library/MobileSubstrate/DynamicLibraries/* root@127.0.0.1:/Library/MobileSubstrate/DynamicLibraries/
	ssh root@127.0.0.1 -p 2222 killall SpringBoard

SUBPROJECTS += beepbeep


