CC=/opt/iphone/bin/arm-apple-darwin-gcc
LD=$(CC)
LDFLAGS = -undefined define_a_way \
		  -dynamiclib \
		  -lobjc \
		  -framework CoreFoundation \
		  -framework Foundation \
		  -framework CoreTelephony \
		  -framework UIKit

VERSION=1.0-snapshot

#DEBUG_CFLAGS=-std=gnu99 -g -W -Wall -fsigned-char -DDEBUG -DVERSION='"$(VERSION)"' -D_REENTRANT -fno-common
CFLAGS=-std=gnu99 -g -W -Wall -fsigned-char -DVERSION='"$(VERSION)"' -D_REENTRANT -fno-common -I/opt/iphone/include/Foundation

#FIXME use the APP Name in code
APP=iSMSHook.dylib

APP_DEPLOY_PATH=/Applications/iSMS.app
#IPHONE=
IPHONE_USER=root

all:	$(APP)

$(APP):	iSMSHook.o
		
	$(LD) $(LDFLAGS) -o $@ $^
	@cp -f $(APP) ../../build
	@echo "Build success!"
%.o:	%.m
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@
	
clean:
	rm -f *.o *.dylib
	rm -f ../../build/*.dylib
