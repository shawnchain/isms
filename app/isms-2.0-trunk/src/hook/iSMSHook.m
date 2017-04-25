//==============================================================================
//	Created on 2008-4-21
//==============================================================================
//	$Id$
//==============================================================================
//	Copyright (C) <2008>  Shawn Qian(shawn.chain@gmail.com)
//
//	This file is part of iSMS-1.0-trunk.
//
//  iSMS-1.0-trunk is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  iSMS-1.0-trunk is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with iSMS-1.0-trunk.  If not, see <http://www.gnu.org/licenses/>.
//==============================================================================

#import "iSMSHook.h"

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIApplication.h>
//#include <stdio.h>

//
#import "SBApplication.h"
#import "SBIconList.h"
#import "SBUIController.h"
#import "SBSMSAlertItem.h"

//#import "sms/NSString-PhoneNumber.h"
//#import "sms/BlackList.h"

//#import "../util/AudioHelper.h"
//#import "../util/AccelMonitor.h"
//#import "SpringBoard.h"


// My hack to work under all FW versions
void _launchApp(SBApplication* theApp);
extern void AudioServicesPlaySystemSound(int);
void _playMessageReceivedSound(){
	AudioServicesPlaySystemSound(0x3EF);
}

// Helper method to check whether iSMS is set as the default SMS app
Boolean isPrimarySMSApp(){
	Boolean success = FALSE;
	Boolean value = CFPreferencesGetAppBooleanValue(CFSTR("PREF_DEFAULT_APP"),CFSTR("com.nonsoft.iSMS"),&success);
	if(!success){
		NSLog(@"Read iSMS preference PREF_DEFAULT_APP failed");
		// if no such preference found, use apple's SMS
		value = FALSE;
	}
	return value;
}

Boolean hookEnabled(){
	Boolean success = FALSE;
	Boolean value = CFPreferencesGetAppBooleanValue(CFSTR("PREF_HOOK_ENABLED"),CFSTR("com.nonsoft.iSMS"),&success);
	if(FALSE == success){
		NSLog(@"Read iSMS preference PREF_HOOK_ENABLED failed");
		// if no such preference found, use apple's SMS
		value = FALSE;
	}
	return value;
}

/***************************************************************
 * SBDisplayStack Hookup class
 * 
 * @Author Shawn
 ***************************************************************/
/*
@interface isms_SBDisplayStack : SBDisplayStack
{}
- (id)init;
- (void)dealloc;
@end

static NSMutableDictionary* displayStacks = nil;
@implementation isms_SBDisplayStack : SBDisplayStack
+(void)__load{
	if(!hookEnabled()){
		printf("iSMS helper is disabled");
		return;
	}
	printf("\n****isms_SBDisplayStack, loading!!\n\n");
	@synchronized(self){
		if(displayStacks == nil){
			displayStacks = [[NSMutableDictionary alloc] init];
			NSLog(@"!!! displayStack cache created");
		}
	}
	// Pose ?
	[self poseAsClass: [SBDisplayStack class]];
}

+(void)__unload{
	@synchronized(self){
		if(displayStacks != nil){
			[displayStacks release];
			displayStacks = nil;
			NSLog(@"!!! displayStack cache released");
		}
	}
}

+(BOOL)isTopApplication:(NSString*) bundleId{
	@synchronized(self){
		NSEnumerator *enumerator = [displayStacks objectEnumerator];
		id value;
		while ((value = [enumerator nextObject])) {
			SBApplication *_app = [(SBDisplayStack*)value topApplication];
#ifdef DEBUG
			NSLog(@"Top Application: %@",_app);
#endif
			if(_app && [[[_app bundle] bundleIdentifier] isEqualToString:bundleId]){
				return YES;
			}
		}
		return NO;
	}
}

- (id)init{
	id result = [super init];
	NSString* key = [NSString stringWithFormat:@"%d",self];
	@synchronized([self class]){
		[displayStacks setObject:self forKey:key];
		NSLog(@">>> DisplayStack instance %@ created and cached",self);			
	}
	return result;
}

- (void)dealloc{
	NSString* key = [NSString stringWithFormat:@"%d",self];
	@synchronized([self class]){
		[displayStacks removeObjectForKey:key];
		NSLog(@">>> DisplayStack instance %@ removed from cache",self);			
	}
	[super dealloc];
}
@end
*/


/***************************************************************
 * SBSMSAlertItem Hookup class
 * 
 * @Author Shawn
 ***************************************************************/
@interface isms_SBSMSAlertItem : SBSMSAlertItem
{}
@end

@implementation isms_SBSMSAlertItem : SBSMSAlertItem
+ (void)load
{
	if(!hookEnabled()){
		//printf("iSMS hook is disabled");
		return;
	}
	printf("\n****isms_SBSMSAlertItem, loading!!\n\n");
	[self poseAsClass: [SBSMSAlertItem class]];
}


- (void)reply
{
#ifdef DEBUG
	NSLog(@">>> Will Reply Message to %@",[self address]);
#endif

	if(!isPrimarySMSApp()){
		// Delegate to super
		NSLog(@">>> Will reply message with stock app");
		[super reply];
		return;
	}
	
	NSLog(@">>> Trying to launch iSMS to reply message "); 

	SBApplicationIcon *appIcon = getAppIconById(ISMS_IDENTIFIER); //[[SBIconList sharedInstance] applicationIconForQualfiedBundleID:ISMS_IDENTIFIER];
	SBApplication* app = [appIcon application];
	_launchApp(app);
//	SBUIController* controller = [SBUIController sharedInstance];
//	
//	//FIXME this method does not work under 1.1.2+ !!!
//	[controller animateLaunchIcon:app];
	
	//[controller animateLaunchOfApplication:app];
#ifdef DEBUG
	NSLog(@">>> Dismiss all alert items");
#endif
	[self _deactivateAllTaggedSMSAlertItems];
}
@end


void _launchApp(SBApplication* theApp){
	SBUIController* controller = [SBUIController sharedInstance];
	if([controller respondsToSelector:@selector(animateLaunchIcon:)]){
		[controller animateLaunchIcon:theApp];
	}else if([controller respondsToSelector:@selector(animateLaunchApplication:)]){
		[controller animateLaunchApplication:theApp];
	}else{
		NSLog(@"Error - iSMS Helper could not find a method to launch the application %@",theApp);
	}
}

SBApplicationIcon* getAppIconById(NSString* bundleId){
	SBIconList* iconList = [SBIconList sharedInstance];
	if([iconList respondsToSelector:@selector(applicationIconForQualfiedBundleID:)]){
		// It's 1.0.2
		NSLog(@"iSMS Helper getAppIconById() - work in 1.0.2 way...");
		return [iconList applicationIconForQualfiedBundleID:bundleId]; 
	}else{
		// Try to use the SBIconModel
		Class sbIconModelClass = NSClassFromString(@"SBIconModel");
		if(sbIconModelClass){
			id iconModel = [sbIconModelClass sharedInstance];
			if(iconModel && [iconModel respondsToSelector:@selector(iconForDisplayIdentifier:)]){
				NSLog(@"iSMS Helper getAppIconById() - work in 1.1.x way...");
				return [iconModel iconForDisplayIdentifier:bundleId];
			}
		}else{
			NSLog(@"Could not get AppIcon by Id %@, wrong OS version ?",bundleId);
		}
	}
	//SBApplicationIcon *appIcon = [[SBIconList sharedInstance] applicationIconForQualfiedBundleID:ISMS_IDENTIFIER];
	return nil;
}

NSString* osVersionString(){
	return [[NSProcessInfo processInfo] operatingSystemVersionString];
}

static int _osVersionValue = -1; 
int osVersion(){
	if(_osVersionValue < 0){
		// We assume the strings is as:
		// Version 1.x.x (Build XXXX)
		NSString* s = osVersionString();
		if([s hasPrefix:@"Version "]){
			if([s length] >= 13 ){
				char buf[] = {0x0,0x0};
				buf[0] = [s characterAtIndex:8];
				int i1 = atoi(buf);
				buf[0] = [s characterAtIndex:10];
				int i2 = atoi(buf);
				buf[0] = [s characterAtIndex:12];
				int i3 = atoi(buf);
				_osVersionValue = i1 * 100 + i2 * 10 + i3;
				//NSLog(@"OS Version is %d",_osVersionValue);
				return _osVersionValue;
			}
		}
		_osVersionValue = 0;
	}
	return _osVersionValue;
}

/***************************************************************
 * SpringBoard Class
 * 
 * @Author Shawn
 ***************************************************************/
////@interface isms_SpringBoard : SpringBoard
//@interface SpringBoard(isms)
////- (void) acceleratedInX: (float)x Y:(float)y Z:(float)z;
//@end
//
////@implementation isms_SpringBoard : SpringBoard
//@implementation SpringBoard(isms)
////+(void)load{
////	if(!hookEnabled()){
////			//printf("iSMS hook is disabled");
////			return;
////	}
////	printf("\n****isms_SpringBoard, loading!!\n\n");
////	[self poseAsClass: [SpringBoard class]];
////}
//
////-(id)init{
////	[super init];
////	// Register the accel callback
////	NSLog(@"Registering accel monitor");
////	[AccelMonitor registerAccelListener:nil];
////	return self;
////}
//
//- (void) acceleratedInX: (float)x Y:(float)y Z:(float)z{
//	NSLog(@"%f,%f,%f",x,y,z);
//	if(x > 0.7f){
//		//[self vibrateForDuration:1];
//	    NSLog(@"!!! Shocked!");
//	    // Check whether we have unreceived message
//	    int unreadCount = CTSMSMessageGetUnreadCount();
//	    if(unreadCount > 0){
//	    	playMessageReceivedSound2(YES);
//	    }
//	}
//}
//@end