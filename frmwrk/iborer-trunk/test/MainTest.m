#include <stdio.h>
#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <UIKit/UIApplication.h>
#import "HelloBundle.h"
#import <UIKit/UIKit.h>
#import "../src/common/Logger.h"

@interface TestApp : UIApplication{
	BOOL send;
	CFMessagePortRef messagePort;
}
-(void)applicationDidFinishLaunching:(NSNotification *)aNotification;
- (id)_initWithArgc:(int)argc argv:(const char **)argv;
@end

#define NOTIFICATION_NAME @"TestDistributedNotification"
#define SENDER_NAME @"TestApp"
#define USE_CF_NOTIFICATION_API 1

@implementation TestApp

//@see http://developer.apple.com/documentation/CoreFoundation/Reference/CFNotificationCenterRef/Reference/reference.html#//apple_ref/c/func/CFNotificationCenterRemoveEveryObserver
void _notificationCallBack (
   CFNotificationCenterRef center,
   void *observer,
   CFStringRef name,
   const void *object,
   CFDictionaryRef userInfo
){
	INFO(@"Notification callback called - center:%@, observer:%@, name: %@",center,observer,name);
}

CFDataRef _machMessageCallBack (
   CFMessagePortRef local,
   SInt32 msgid,
   CFDataRef data,
   void *info
){
	NSString* dataStr;
	if(data){
		dataStr = [[NSString alloc] initWithData:(NSData*)data encoding:NSUTF8StringEncoding];
	}
	INFO(@"Received Mach message from %@, msgid is %@, data is %@(%@), info is %@",local,msgid,dataStr,data,info);
	if(dataStr){
		[dataStr release];
	}
	// We response nothing to client
	return nil;
}


-(void) _sendNotification{
#ifdef USE_CF_NOTIFICATION_API
	CFNotificationCenterRef center = CFNotificationCenterGetDarwinNotifyCenter();
	CFNotificationCenterPostNotification(center,(CFStringRef)NOTIFICATION_NAME,nil,nil,YES);
#else
	NSDistributedNotificationCenter	*dnc = [NSDistributedNotificationCenter defaultCenter];
	[dnc postNotificationName:NOTIFICATION_NAME object:SENDER_NAME userInfo:nil deliverImmediately:YES];
#endif
	INFO(@"Notification %@ posted.",NOTIFICATION_NAME);
}

- (void) _notifyReceived:(NSNotification *) notification {
	INFO(@"Notification %@ received!",notification);
}


-(void)_registerObserver{
#ifdef USE_CF_NOTIFICATION_API
	CFNotificationCenterRef center = CFNotificationCenterGetDarwinNotifyCenter();
	CFNotificationCenterAddObserver(center,self,_notificationCallBack,(CFStringRef)NOTIFICATION_NAME,nil,nil);
#else	
	NSDistributedNotificationCenter	*dnc = [NSDistributedNotificationCenter defaultCenter];
	[dnc addObserver:self selector:@selector(_notifyReceived:) name:NOTIFICATION_NAME object:SENDER_NAME suspensionBehavior:NSNotificationSuspensionBehaviorDeliverImmediately];
#endif
}

-(void)_removeObserver{
#ifdef USE_CF_NOTIFICATION_API
	CFNotificationCenterRef center = CFNotificationCenterGetDarwinNotifyCenter();
	CFNotificationCenterRemoveObserver(center,self,(CFStringRef)NOTIFICATION_NAME,nil);
	// See CFNotificationCenterRemoveEveryObserver(CFNotificationCenterRef center,const void *observer);
#else	
	NSDistributedNotificationCenter	*dnc = [NSDistributedNotificationCenter defaultCenter];
	[dnc removeObserver:self name:NOTIFICATION_NAME object:SENDER_NAME];
#endif
}


//==Using mach message port ==
-(void)_sendMachMessage{
	// Connect to the remove port and send message to it
	CFMessagePortRef remotePort = CFMessagePortCreateRemote(kCFAllocatorDefault,(CFStringRef)NOTIFICATION_NAME);
	if(remotePort){
		NSString *data = @"Hello mach message!";
		SInt32 ret = CFMessagePortSendRequest(
				remotePort,
				0,
				(CFDataRef)[data dataUsingEncoding:NSUTF8StringEncoding],
				0,
				0,
				NULL, /*one-way message, no response is expected*/
				nil
		);
		if(ret != kCFMessagePortSuccess){
			INFO(@"Error sending message to remote port %@, error code is %d",NOTIFICATION_NAME,ret);
		}
		CFRelease(remotePort);
	}else{
		INFO(@"Could not create remote port %@",NOTIFICATION_NAME);
	}
}

-(void)_createMachMessagePort{
	if(messagePort){
		INFO(@"Message port is not nil ?");
		return;
	}
	CFMessagePortContext context = { 0 };
	// TODO context.info = my_info_data;
	Boolean shouldFreeInfo;
	
	/*CFMessagePortRef port*/
	messagePort = CFMessagePortCreateLocal(
				kCFAllocatorDefault,
				(CFStringRef)NOTIFICATION_NAME,
				_machMessageCallBack,
				&context,
				&shouldFreeInfo
				);
	if(messagePort == nil){
		INFO(@"Message port %@ already exists!",NOTIFICATION_NAME);
		return;
	}
	CFRunLoopSourceRef rls = CFMessagePortCreateRunLoopSource(
				kCFAllocatorDefault,
				messagePort,
				0
				);
	CFRunLoopAddSource(CFRunLoopGetCurrent(), rls, kCFRunLoopDefaultMode);
	CFRelease(rls);
}

-(void)_releaseMachMessagePort{
	if(messagePort){
		CFMessagePortInvalidate(messagePort);
		CFRunLoopSourceRef rls = CFMessagePortCreateRunLoopSource(
						kCFAllocatorDefault,
						messagePort,
						0
						);
		CFRunLoopRemoveSource(CFRunLoopGetCurrent(),rls,kCFRunLoopDefaultMode);
		CFRelease(rls);
		CFRelease(messagePort);
		messagePort = nil;
	}
}

- (id)_initWithArgc:(int)argc argv:(const char **)argv{
	[super _initWithArgc:argc argv:argv];
	if(argc == 2 && strcasecmp(argv[1],"recv") == 0){
		send = NO;
	}else{
		send = YES;
	}
	return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	INFO(@"TestApp finished launched. %@",aNotification);
	if(send){
		[self _sendNotification];
		[self terminate];
	}else{
		[self _registerObserver];
		INFO(@"Receiving notification(%@) from %@ ...",NOTIFICATION_NAME,SENDER_NAME);
	}
}

- (void)applicationWillTerminate {
	if(!send){
		[self _removeObserver];
	}
	INFO(@"TestApp Exitting...");
}
@end

void TestBundle() {
	NSString *bundlePath =@"/test/TestBundle.bundle";
	INFO(@"Loading bundle %@",bundlePath);
	NSBundle *bundleToLoad = [NSBundle bundleWithPath:bundlePath];
	if(bundleToLoad) {
		INFO(@"Loading principal class...");
		Class bundleClass = [bundleToLoad principalClass];
		//Class bundleClass = [bundleToLoad classNamed:@"TestBundle"];
		if (bundleClass)
		{
			INFO(@"Initializing class %@",bundleClass);
			id<HelloBundle> aBundle = [[bundleClass alloc] init];
			if(aBundle) {
				[aBundle sayHello];
				[(id)aBundle release];
			}
		}
	}else {
		INFO(@"Load bundle failed");
	}
}

void TestSMSFilter() {
	//ifilter -t sms -from 138xxx -j drop
	//ifilter -t sms -contains "xyz" -j archive
	//ifilter -t call -from 138xxx -time-between 11:00-9:00 -j reject
	//ifilter -t [table] [[match rule] AND|OR [match rule]*] [target]
	//ifilter -t [table] -p [policy]
	//ifilter -t [table] -l
	//ifilter -L
	
	//IFFilter, IFTable/IFChain, IFRule, IFTable, IFCondition, IFTarget
	
	//-(BOOL) IFConditionMatcher.matches() match or not
	//-(BOOL) IFTarget.execute() continue or break
	//-(BOOL) IFRule.check()
	
}
//
//void TestDistributedNotification(BOOL receive){
//	if(receive){
//		// Register listener
//		UIApplicationMain(argc, argv, [iSMSApp class]);
//		[[[TestObject alloc] init] testNotifyReceive];
//	}else{
//		// Post the message
//		
//		
//	}
//}

void TestHello() {
	printf("Hello Stdout!\n");
	fprintf(stderr, "Hello Stderr!\n");
	INFO(@"Hello NSLog!");
}

#define IBORER_MESSAGE_PORT @"IBORER_MESSAGE_PORT"
void SendMessage(const char** msgBytes, int count){
	NSMutableString *msg = [[NSMutableString alloc] init];
	for(int i = 0;i < count;i++){
		[msg appendFormat:@"%s ",msgBytes[i]];
	}
	
	BOOL success = NO;
	// Connect to the remove port and send message to it
	CFMessagePortRef remotePort = CFMessagePortCreateRemote(kCFAllocatorDefault,(CFStringRef)IBORER_MESSAGE_PORT);
	if(remotePort){
		//NSString *msg = [[NSString alloc]initWithUTF8String:msgBytes];
		CFDataRef data = (CFDataRef)[msg dataUsingEncoding:NSUTF8StringEncoding];
		SInt32 ret = CFMessagePortSendRequest(
				remotePort,
				0,
				data,
				0,
				0,
				NULL, /*one-way message, no response is expected*/
				nil
		);
		if(ret != kCFMessagePortSuccess){
			INFO(@"Error sending message to remote port %@, error code is %d",IBORER_MESSAGE_PORT,ret);
		}else{
			success = YES;
		}
		CFRelease(remotePort);
	}else{
		INFO(@"Could not create remote port %@",IBORER_MESSAGE_PORT);
	}
	return;
}

int main(int argc, char **argv) {
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	if(argc >= 2){
		
		if((strcasecmp(argv[1],"send") == 0)){
			[[[TestApp alloc] init] _sendNotification];
			//UIApplicationMain(argc, argv, [TestApp class]);
		}else if(strcasecmp(argv[1],"recv") == 0){
			//UIApplicationMain(argc, argv, [TestApp class]);
			TestApp *app = [[TestApp alloc]init];
			[app _registerObserver];
			[[NSRunLoop currentRunLoop] run];
			[app _removeObserver];
			[app release];
		}else if((strcasecmp(argv[1],"mach-send") == 0)){
			[[[TestApp alloc] init] _sendMachMessage];
		}else if(strcasecmp(argv[1],"mach-recv") == 0){
			TestApp *app = [[TestApp alloc]init];
			[app _createMachMessagePort];
			[[NSRunLoop currentRunLoop] run];
			[app _releaseMachMessagePort];
			[app release];
		}else if(strcasecmp(argv[1],"bundle") == 0){
			TestBundle();
		}else if(strcasecmp(argv[1],"msg") == 0){
			if(argc >= 3){
				SendMessage((const char**)&argv[2],argc - 2);
			}
		}else{
			INFO(@"Unknow test %s",argv[1]);
		}
	}else{
		INFO(@"Run: test [test_name]");
	}
	
	[pool release];
	return 0;
}