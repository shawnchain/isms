#===================================================
# Makefile for iBorer
# -  By Shawn - $Revision: 235 $
#===================================================

LIB_NAME=iBorer
LIB_SUFFIX=dylib
VERSION=0.1
FIRMWARE_VERSION=U

TARGET=../build/$(LIB_NAME).framework
DYLIB=$(TARGET)/$(LIB_NAME).$(LIB_SUFFIX)

TOOLCHAIN_HOME=/opt/iphone
HEAVENLY_VERSION=1.0.2
HEAVENLY=$(TOOLCHAIN_HOME)/heavenly/$(HEAVENLY_VERSION)
HEAVENLY_SYSTEM=$(HEAVENLY)/system
HEAVENLY_INCLUDE=$(HEAVENLY)/include

SYS_INCLUDE=$(TOOLCHAIN_HOME)/include

CC=$(TOOLCHAIN_HOME)/bin/arm-apple-darwin-gcc \
	-isysroot $(HEAVENLY_SYSTEM) \
	-isystem $(SYS_INCLUDE) \
	-isystem $(SYS_INCLUDE)/gcc/darwin/3.3 \
	-isystem $(HEAVENLY_INCLUDE)

LD=$(CC) -F$(HEAVENLY_SYSTEM)/System/Library/Frameworks -F../build


# Append snapshot suffix if no RELEASE variable found
ifeq ($(strip $(RELEASE)),1)
	FULL_VERSION=$(VERSION)
else
	FULL_VERSION=$(VERSION)-snapshot
endif
# Flags for compiler and linker
CFLAGS=-Wall -std=gnu99 -fno-common -fsigned-char -DVERSION='"$(FULL_VERSION)"' -g
CFLAGS+=-D_REENTRANT

ifeq ($(strip $(DEBUG)),1)
	CFLAGS+=-DDEBUG
else
	CFLAGS+=-O2
endif

LDFLAGS=-lobjc -framework Foundation -framework CoreFoundation -framework iBorer

INCLUDE=-Isrc -I../src

#===================================================
# App Target
#===================================================
dylib:	build_prepare	$(DYLIB)
all:	dylib test
build_prepare:	
	@mkdir -p $(TARGET)

$(DYLIB):	LDFLAGS+=-dynamiclib -framework UIKit
#		-undefined define_a_way
#		-framework CoreGraphics \
#		-framework LayerKit \
#		-framework PhotoLibrary \
#		-framework GraphicsServices \
#		-framework WebKit \
#		-framework WebCore \
#		-framework Celestial \
#		-framework IOKit

DYLIB_OBJS=src/iBorer.o
$(DYLIB):	$(DYLIB_OBJS)
	$(LD) $(LDFLAGS) -o $@ $^
	@echo --------------------------------------------------------------------------------
	@echo ">>>> $(LIB_NAME).dylib v$(FULL_VERSION) for iPhone($(FIRMWARE_VERSION)) is built successfully! <<<<"
	@echo
	@echo

TEST_OBJS=test/MainTest.o
TEST=$(TARGET)/$(LIB_NAME)_$(LIB_SUFFIX)_test
$(TEST):	LDFLAGS+=-framework UIKit
$(TEST):	$(TEST_OBJS)
	$(LD) $(LDFLAGS) -o $@ $^
	@echo --------------------------------------------------------------------------------
	@echo ">>>> Test cases for $(LIB_NAME) v$(FULL_VERSION)/($(FIRMWARE_VERSION)) is built successfully! <<<<"
	@echo
	@echo

#Common rule to compile the source file to object file
%.o:	%.m
	$(CC) -c $(CFLAGS) $(INCLUDE) $< -o $@

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
	rm -f $(DYLIB_OBJS) $(TEST_OBJS)
	rm -f $(DYLIB) $(TEST)