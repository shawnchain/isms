#===================================================
# iBorer Makefile for iPhone 2.0
# -  By Shawn - $Revision: 249 $
#===================================================

#===================================================
# Name and version
#===================================================
TARGET_NAME = iBorer
TARGET_SUFFIX = dylib
VERSION = 0.1
FIRMWARE_VERSION = 3.1

OUT_DIR = build/iphone-$(FIRMWARE_VERSION)/$(TARGET_NAME).framework
TARGET = $(OUT_DIR)/$(TARGET_NAME).$(TARGET_SUFFIX)

#Release or snapshot ?
ifeq ($(strip $(RELEASE)),1)
        FULL_VERSION = $(VERSION)
else
        FULL_VERSION = $(VERSION)-snapshot
endif

#===================================================
# Toolchain setup
#===================================================
TOOLCHAIN_HOME = /opt/iphone-toolchain
IPHONE_SDK_HOME = /Developer/Platforms/iPhoneOS.platform/Developer

## No heaven anymore since SDK out ?
#HEAVENLY_VERSION = 1.0.2
#HEAVENLY=$(TOOLCHAIN_HOME)/heavenly/$(HEAVENLY_VERSION)
#HEAVENLY_SYSTEM=$(HEAVENLY)/system
#HEAVENLY_INCLUDE=$(HEAVENLY)/include

#===================================================
# Compiler parameter setup
#===================================================
#CC = $(TOOLCHAIN_HOME)/bin/arm-apple-darwin-gcc
CC = $(IPHONE_SDK_HOME)/usr/bin/arm-apple-darwin9-gcc-4.0.1

CFLAGS = -Wall -std=gnu99 -fno-common -fsigned-char -DVERSION='"$(FULL_VERSION)"' -g
CFLAGS += -D_REENTRANT
CFLAGS += -D__IPHONE_OS_VERSION_MIN_REQUIRED=__IPHONE_3_1

ifeq ($(strip $(DEBUG)),1)
	CFLAGS += -DDEBUG
else
	CFLAGS += -O2
endif

INCLUDES = -I$(IPHONE_SDK_HOME)/SDKs/iPhoneOS3.1.sdk/usr/include \
	-I$(IPHONE_SDK_HOME)/usr/include \
	-I$(IPHONE_SDK_HOME)/usr/lib/gcc/arm-apple-darwin9/4.0.1/include \
	-I$(TOOLCHAIN_HOME)/arm-apple-darwin/include-2.0 \
	-F$(IPHONE_SDK_HOME)/SDKs/iPhoneOS3.1.sdk/System/Library/Frameworks
INCLUDES += -Isrc -I../src
CFLAGS += $(INCLUDES)


#===================================================
# Linker parameter setup
#===================================================
LD = $(CC)
LDFLAGS = -lobjc -framework Foundation -framework CoreFoundation
LIBS = -isysroot $(TOOLCHAIN_HOME)/arm-apple-darwin/system-2.0 \
           -F$(IPHONE_SDK_HOME)/SDKs/iPhoneOS3.1.sdk/System/Library/Frameworks \
           -F$(TOOLCHAIN_HOME)/arm-apple-darwin/system-2.0/System/Library/PrivateFrameworks \
           -L$(IPHONE_SDK_HOME)/SDKs/iPhoneOS3.1.sdk/usr/lib \
           -F../build/iphone-$(FIRMWARE_VERSION)
LDFLAGS += $(LIBS)

#===================================================
# Build Targets
#===================================================
all:	lib     test
$(TARGET):	LDFLAGS+=-dynamiclib \
		-framework UIKit \
		-framework iBorer
#		-undefined define_a_way
#		-framework CoreGraphics \
#		-framework LayerKit \
#		-framework PhotoLibrary \
#		-framework GraphicsServices \
#		-framework WebKit \
#		-framework WebCore \
#		-framework Celestial \
#		-framework IOKit

TARGET_OBJS = src/iBorer.o

$(TARGET):	$(TARGET_OBJS)
	$(LD) $(LDFLAGS) -o $@ $^
	@echo --------------------------------------------------------------------------------
	@echo ">>>> $(TARGET_NAME).framework v$(FULL_VERSION) for iPhone($(FIRMWARE_VERSION)) built successfully! <<<<"
	@echo
	@echo


#===================================================
# Tests
#===================================================
TEST = $(OUT_DIR)/$(TARGET_NAME)_$(TARGET_SUFFIX)_test
TEST_OBJS = test/MainTest.o

$(TEST):	LDFLAGS+=-framework UIKit -framework CoreFoundation -framework iBorer
$(TEST):	$(TEST_OBJS)
	$(LD) $(LDFLAGS) -o $@ $^
	@echo --------------------------------------------------------------------------------
	@echo ">>>> Test cases of $(TARGET_NAME) v$(FULL_VERSION) for iPhone($(FIRMWARE_VERSION)) built successfully! <<<<"
	@echo
	@echo


%.o:	%.m
	$(CC) -c $(CFLAGS) $< -o $@

#===================================================
# Alias 
#===================================================
build_prepare:
	@mkdir -p $(OUT_DIR)
lib:	build_prepare   $(TARGET)


#===================================================
# Package & Deploy
#===================================================
package:	all
#	@echo Packaging $(APP_NAME)-$(FULL_VERSION) for iPhone $(FIRMWARE_VERSION)
#	@sh ./bundle/package/package.sh $(APP_NAME) $(FULL_VERSION) $(FIRMWARE_VERSION)
	
test: $(TEST)
#	@TIMESTAMP=`date +%m%d%H%M`
#	PACKAGE=$(APP_NAME)-$(VERSION)-$(TIMESTAMP)-$(FIRMWARE_VERSION).zip
#	@PACKAGE=$(APP_NAME)-$(VERSION)-`date +%m%d%H%M`.zip
#	@echo $(APP_NAME)-$(FULL_VERSION)-`date +%m%d%H%M`.zip
#	@echo $(DEBUG)
	
deploy:	$(package)
#	@echo "TODO - Upload files to repository server"
#	@sh ./bundle/package/deploy.sh $(VERSION) $(FIRMWARE_VERSION)


#===================================================
# DEBUG - IPHONE_IP=x.x.x.x make iphone-deploy
#===================================================
IPHONE_DEPLOY_PATH=/Library/Framework/iBorer.framework
IPHONE_USER=root

iphone-deploy:	$(APP)
ifneq ($(strip $(IPHONE_IP)),)
	@echo "Deploy binary to iphone..."
	scp -rp $(APP) $(IPHONE_USER)@$(IPHONE_IP):$(APP_DEPLOY_PATH)
else
	$(error iPhone ip address unknow, use "IPHONE_IP=x.x.x.x make")
endif
	
iphone-run:	iphone-deploy
ifneq ($(strip $(IPHONE_IP)),)
	@echo "Run binary on iphone..."
	ssh $(IPHONE_USER)@$(IPHONE_IP) $(IPHONE_DEPLOY_PATH)/$(APP)
else
	$(error iPhone ip address unknow, use "IPHONE_IP=x.x.x.x make")
endif

deploy-test:	test
ifneq ($(strip $(IPHONE_IP)),)
	@echo "Deploying test to iPhone($(IPHONE_IP))"
	@scp -rp $(TEST) root@$(IPHONE_IP):/
else
	$(error iPhone ip address unknow, try "IPHONE_IP=x.x.x.x make xxx")
endif

run-test:	deploy-test
ifneq ($(strip $(IPHONE_IP)),)
	@echo "Running test on iPhone($(IPHONE_IP))..."
	@ssh root@$(IPHONE_IP) "/test 2>&1" 
else
	$(error iPhone ip address unknow, try "IPHONE_IP=x.x.x.x make xxx")
endif

#===================================================
# Clean
#===================================================
.PHONY: clean
clean:
	rm -f $(TARGET_OBJS) $(TEST_OBJS)
	rm -f $(TARGET) $(TEST)
