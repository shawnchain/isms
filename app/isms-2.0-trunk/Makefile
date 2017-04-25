#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Makefile for iSMS -  By Shawn - $Revision: 254 $
# TODO - Detect firmware version
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#===================================================
# App version and file name
#===================================================
APP_NAME=iSMS2
VERSION=2.0
FIRMWARE_VERSION=u
TARGET=build/bin
APP=$(TARGET)/$(APP_NAME)

#===================================================
# DYLib versions and file names
#===================================================
DYLIB_BASE_NAME=iSMSHook
DYLIB_EXT_NAME=.dylib
DYLIB_NAME_102=$(DYLIB_BASE_NAME)102$(DYLIB_EXT_NAME)

DYLIB_102= $(TARGET)/$(DYLIB_NAME_102)

#===================================================
# Toolchain setup
#===================================================
TOOLCHAIN_HOME=/opt/iphone-toolchain
IPHONE_SDK_HOME = /Developer/Platforms/iPhoneOS.platform/Developer

## No heaven any more since SDK out ?
#HEAVENLY_HOME=$(TOOLCHAIN_HOME)/heavenly
#HEAVENLY_VERSION=1.0.2
#HEAVENLY_SYSTEM=$(HEAVENLY_HOME)/$(HEAVENLY_VERSION)/system
#HEAVENLY_SYSTEM_FRAMEWORKS=$(HEAVENLY_SYSTEM)/System/Library/Frameworks
#HEAVENLY_HEADERS=$(HEAVENLY_HOME)/$(HEAVENLY_VERSION)/include

#===================================================
# Common compile argument setup
#===================================================
#CC=$(TOOLCHAIN_HOME)/bin/arm-apple-darwin-gcc 
CC = $(IPHONE_SDK_HOME)/usr/bin/arm-apple-darwin9-gcc-4.0.1	
LD=$(CC) 

# Append snapshot suffix if no RELEASE variable found
ifeq ($(strip $(RELEASE)),1)
	FULL_VERSION=$(VERSION)
else
	FULL_VERSION=$(VERSION)-snapshot
endif

# Flags for compiler and linker
CFLAGS=-Wall -std=gnu99 -fno-common -fsigned-char -DVERSION='"$(FULL_VERSION)"' -g
#CFLAGS+=-DMOCK_SEND
#CFLAGS+=-DMOCK_SEND_FAILURE
#CFLAGS+=-DUSE_SQLITE_FTS=1
#CFLAGS+=-DTEST_SMS_DB
#CFLAGS+=-DDEBUG_HOOK_INSTALL

# Debug flags
ifeq ($(strip $(DEBUG_HOOK)),1)
	CFLAGS+=-DDEBUG_HOOK
endif
ifeq ($(strip $(DEBUG)),1)
	CFLAGS+=-DDEBUG
else
	CFLAGS+=-O2
endif

LDFLAGS=-lobjc \
		-framework Foundation \
		-framework CoreFoundation \
		-framework UIKit \
		-framework CoreTelephony

CFLAGS += -Isrc -Isrc/container

CFLAGS_2_0 = -D__BUILD_FOR_2_0__
INCLUDE_2_0 = -I$(IPHONE_SDK_HOME)/SDKs/iPhoneOS2.0.sdk/usr/include \
              -I$(IPHONE_SDK_HOME)/usr/include \
              -I$(IPHONE_SDK_HOME)/usr/lib/gcc/arm-apple-darwin9/4.0.1/include \
              -I$(TOOLCHAIN_HOME)/arm-apple-darwin/include-2.0 \
	      -F$(IPHONE_SDK_HOME)/SDKs/iPhoneOS2.0.sdk/System/Library/Frameworks
LIBS_2_0 = -isysroot $(TOOLCHAIN_HOME)/arm-apple-darwin/system-2.0 \
           -F$(TOOLCHAIN_HOME)/arm-apple-darwin/system-2.0/System/Library/Frameworks \
	   -F$(TOOLCHAIN_HOME)/arm-apple-darwin/system-2.0/System/Library/PrivateFrameworks \
           -L$(TOOLCHAIN_HOME)/arm-apple-darwin/system-2.0/usr/lib \
	   -L$(IPHONE_SDK_HOME)/SDKs/iPhoneOS2.0.sdk/usr/lib

CFLAGS += $(CFLAGS_2_0) $(INCLUDE_2_0)
LDFLAGS := $(LIBS_2_0) $(LDFLAGS)

#===================================================
# App Target
#===================================================
$(APP):	CFLAGS += -Isrc/controller \
			-Isrc/ui/common \
			-Isrc/log \
			-Isrc/include \
			-Isrc/util \
			-Isrc/db \
			-Isrc/model \
			-Isrc/sms \
			-Isrc/preference

$(APP):	LDFLAGS+=-lsqlite3 \
		-framework CoreGraphics \
		-framework Celestial \
		-framework WebKit \
		-framework WebCore \
		-framework AddressBookUI \
		-framework AddressBook \
		-framework GraphicsServices \
		-framework AudioToolbox \
		-framework QuartzCore \
		-framework MessageUI
		
APP_OBJS = src/main.o \
		src/sms/SMSCenter.o\
		src/sms/NSString-PhoneNumber.o \
		src/sms/BlackList.o \
		src/db/SQLiteDB.o \
		src/db/Criteria.o \
		src/db/DBAdapter.o \
		src/model/Contact.o \
		src/model/Message.o\
		src/model/MessageTemplate.o\
		src/UIAboutView.o \
		src/MessageListView.o\
		src/UIMessageTableCell.o\
		src/ui/compose/UIComposeSMSView.o\
		src/ui/compose/UISMSTextView.o\
		src/ui/compose/UISMSRecipientField.o\
		src/ui/compose/UISmileyChooserView.o\
		src/ui/compose/SmileyManager.o\
		src/ui/compose/UITemplateChooserView.o\
		src/ui/compose/UITemplateEditView.o\
		src/ui/compose/ContactPickerView.o\
		src/controller/UIController.o\
		src/ui/common/UIButtonBarView.o\
		src/ui/common/UIImageNavigationBar.o\
		src/ui/common/UITableEx.o\
		src/ui/common/UIViewEx.o\
		src/ui/common/UISwipeAwareTable.o\
		src/ui/common/UIModalAlertSheet.o\
		src/ui/common/UIRichTextView.o\
		src/UIMessageView.o\
		src/UIMainView.o\
		src/UIMessageMainView.o\
		src/UIMessageSearchView.o\
		src/UIMessageListTable.o\
		src/preference/ui/UIPreferenceView.o\
		src/ui/compose/UIQuickContactList.o\
		src/container/ObjectContainer.o\
		src/ui/compose/SMSProgressView.o\
		src/util/AnimationHelper.o\
		src/log/Logger.o\
		src/util/AudioHelper.o\
		src/util/Util.o\
		src/util/TelephonyHelper.o\
		src/preference/ui/UIBlackListView.o\
		src/preference/ui/UIAddBlackListView.o\
		src/preference/iSMSPreference.o\
		src/hook/HookInstaller.o\
		src/conversation/ISMSConversationController.o\
		src/conversation/ISMSConversationView.o\
		src/conversation/ISMSConversationModel.o\
		src/conversation/BalloonCell.o\
		src/conversation/QXGestureMaskView.o\
		src/conversation/HTMLHandler.o\
		src/conversation/NSString-Plus.o\
		src/PCRE/chartables.o\
		src/PCRE/get.o\
		src/PCRE/maketables.o\
		src/PCRE/pcre.o\
		src/PCRE/study.o\
		src/PCRE/AGRegex.o\
		src/iSMSApp.o
		
$(APP):	$(APP_OBJS)
	$(LD) $(LDFLAGS) -o $@ $^
	CODESIGN_ALLOCATE=$(IPHONE_SDK_HOME)/usr/bin/codesign_allocate codesign -s iPhone $@
	@echo --------------------------------------------------------------------------------
	@echo ">>>> $(APP_NAME) v$(FULL_VERSION) for iPhone($(FIRMWARE_VERSION)) is built successfully! <<<<"
	@echo
	@echo
	
codesign:
	CODESIGN_ALLOCATE=$(IPHONE_SDK_HOME)/usr/bin/codesign_allocate codesign -s iPhone build/Debug-iphoneos/iSMS2.app/iSMS2

#===================================================
# DYLIB Target
#===================================================

FORCE:
clean_dylib_objs:	FORCE
	rm -f $(DYLIB_OBJS)

DYLIB_CFLAGS+=-D_REENTRANT
DYLIB_LDFLAGS=-undefined define_a_way \
				-dynamiclib \
				-framework AudioToolbox

DYLIB_BASE=src/hook
DYLIB_102_OUT=$(DYLIB_BASE)/1.0.2

DYLIB_102_OBJS=$(DYLIB_102_OUT)/ISMS_SBTelephonyManager.o $(DYLIB_102_OUT)/iSMSHook.o

$(DYLIB_102):	ADDITIONAL_INCLUDE = -Isrc/hook/sb_header/1.0.2

$(DYLIB_102_OUT)/%.o:	$(DYLIB_BASE)/%.m
	@echo ">>>> Compiling $<"
	$(CC) -c $(CFLAGS) $(DYLIB_CFLAGS) $(INCLUDE) $(ADDITIONAL_INCLUDE) $< -o $@

$(DYLIB_102):	$(DYLIB_102_OBJS)
	@echo "#### Linking $@"
	$(LD) $(LDFLAGS) $(DYLIB_LDFLAGS) -o $@ $^

build_prepare:	
	@mkdir -p $(TARGET)
build_lib_prepare:	build_prepare
	@mkdir -p $(DYLIB_102_OUT)

build_dylib_102:	build_lib_prepare $(DYLIB_102)
	@echo --------------------------------------------------------------------------------
	@echo
	@echo ">>>> Build $(DYLIB_BASE_NAME) v$(FULL_VERSION) for iPhone(1.0.2) success! <<<<"
	@echo
	@echo --------------------------------------------------------------------------------
		
dylib_all:	build_dylib_102 build_dylib_111 build_dylib_112 build_dylib_113 build_dylib_114

%.o:	%.m
	@echo ">>>> Compiling $<"
	$(CC) -c $(CFLAGS) $(INCLUDE) $(ADDITIONAL_INCLUDE) $< -o $@

#===================================================
# target alias
#===================================================
dylib:	dylib_all
app:	build_prepare $(APP)
all:	app dylib

#===================================================
# Package & Deploy
#===================================================
package:	all
#	@echo Packaging $(APP_NAME)-$(FULL_VERSION) for iPhone $(FIRMWARE_VERSION)
	@sh ./bundle/package/package.sh $(FULL_VERSION) $(FIRMWARE_VERSION)
	
test:
	#@TIMESTAMP=`date +%m%d%H%M`
	#	PACKAGE=$(APP_NAME)-$(VERSION)-$(TIMESTAMP)-$(FIRMWARE_VERSION).zip
	#@PACKAGE=$(APP_NAME)-$(VERSION)-`date +%m%d%H%M`.zip
	@echo $(APP_NAME)-$(FULL_VERSION)-`date +%m%d%H%M`.zip
	@echo $(DEBUG)
	
deploy:	$(package)
	@echo "TODO - Upload files to repository server"
#	@sh ./bundle/package/deploy.sh $(VERSION) $(FIRMWARE_VERSION)

#===================================================
# DEBUG
#===================================================
REMOTE_APP_PATH=/Applications/iSMS.app
#IPHONE=
IPHONE_USER=root

deploy-app:	app
ifneq ($(strip $(IPHONE_IP)),)
	@echo "Deploy binary to iphone..."
	scp -rp $(APP) $(IPHONE_USER)@$(IPHONE_IP):$(REMOTE_APP_PATH)
else
	$(error NO iPhone ip, use "IPHONE_IP=x.x.x.x make")
endif
	
run-app:	deploy-app
ifneq ($(strip $(IPHONE_IP)),)
	@echo "Run binary on iphone..."
	ssh $(IPHONE_USER)@$(IPHONE_IP) $(REMOTE_APP_PATH)/$(APP_NAME)
else
	$(error NO iPhone ip, use "IPHONE_IP=x.x.x.x make")
endif

#===================================================
# Clean
#===================================================
.PHONY: clean
clean:
	$(RM) $(APP_OBJS) $(DYLIB_OBJS)
	$(RM) $(TARGET)/*
	$(RM) -r $(DYLIB_102_OUT)
