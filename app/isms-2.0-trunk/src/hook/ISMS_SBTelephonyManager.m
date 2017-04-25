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

#import "ISMS_SBTelephonyManager.h"

#import <UIKit/UIKit.h>
#import "SBAwayController.h"
#import "SBAwayModel.h"
#import "SBDisplayStack.h"
#import "SBApplication.h"
#import "SBSMSAlertItem.h"
#import "SBAlertItemsController.h"
#import "SBApplicationIcon.h"

extern NSString* const kCTSMSMessageReceivedNotification;
extern void* CTTelephonyCenterGetDefault(void);
extern void CTTelephonyCenterAddObserver(void*,id,CFNotificationCallback,NSString*,void*,int);
extern void CTTelephonyCenterRemoveObserver(void*,id,NSString*,void*);
extern int CTSMSMessageGetUnreadCount(void);
NSString* CTSMSMessageCopyAddress(void*,struct __CTSMSMessage *);
void CTSMSMessageDelete(struct __CTSMSMessage *);

//static CFNotificationCallback originalCallback = nil;
void __ISMS_MSG_RECEIVED_CALLBACK (
   CFNotificationCenterRef center,
   void *observer,
   CFStringRef name,
   const void *object,
   CFDictionaryRef userInfo
){
#ifdef DEBUG
	NSLog(@"!!! Got new message! - %@, %@, %@",observer, name, object);
#endif
	[(id)observer _receivedMessage:(struct __CTSMSMessage *)object];
}

NSString* _formalizePhoneNumber(NSString* inNumber){
	NSMutableString* outNumber = [[NSMutableString alloc]init];
	for(unsigned int i = 0;i<[inNumber length];i++){
		unichar aChar = [inNumber characterAtIndex:i];
		if(aChar >= '0' && aChar <= '9'){
			[outNumber appendFormat:@"%c",aChar];	
		}
	}
	return [outNumber autorelease];
}

BOOL isSenderBlocked(struct __CTSMSMessage *msg){
	BOOL result = NO;
	// Get sender number
	if(msg == nil){
		return NO;
	}
	NSString* number = _formalizePhoneNumber(CTSMSMessageCopyAddress(nil,msg));
	NSLog(@"Checking black list for phone number %@",number);
	
	// Get the black list from preference
	//FIXME use Distributed Object!!!
	CFPreferencesAppSynchronize(CFSTR("com.nonsoft.iSMS"));
	NSArray* blackList = (NSArray*)CFPreferencesCopyAppValue(CFSTR("BLACK_LIST"),CFSTR("com.nonsoft.iSMS"));
	if(blackList){
		for(int i = 0;i< [blackList count];i++){
			if([number isEqualToString:[blackList objectAtIndex:i]]){
				result = YES;
				NSLog(@"Phone number %@ is blocked",number);
				break;
			}
		}
	}
	
	/*
	if([[BlackList sharedInstance]isBlocked:number]){
		NSLog(@"The number %@ has been blocked",number);
		result = YES;
	}*/
	// Check the black list
	// return YES or NO
	//CFRelease(blackList);
	return result;
}

BOOL _isNewMessagePreviewEnabled(){
	CFPreferencesAppSynchronize(CFSTR("com.nonsoft.iSMS"));
	Boolean readSuccess = YES;
	Boolean value = CFPreferencesGetAppBooleanValue(CFSTR("PREF_NEW_MESSAGE_PREVIEW"),CFSTR("com.nonsoft.iSMS"),&readSuccess);
	if(FALSE == readSuccess){
		NSLog(@"Read iSMS preference PREF_NEW_MESSAGE_PREVIEW failed");
		// Our fail-safe choose is TRUE!
		value = YES;
	}
	return value;
}

SBApplication* _getSBTopApplication(){
	SBDisplayStack **pStaticVar1=nil,**pStaticVar2 = nil;
	int version = osVersion();
	switch(version){
	case 102:
		pStaticVar1 = (SBDisplayStack**)0x0008E5A0;
		pStaticVar2 = (SBDisplayStack**)0x0008E5B8;
		break;
	case 111:
		pStaticVar1 = (SBDisplayStack**)0x000A0174;
		pStaticVar1 = (SBDisplayStack**)0x000A018C;
		break;
	case 112:
		pStaticVar1 = (SBDisplayStack**)0x000A125C;
		pStaticVar2 = (SBDisplayStack**)0x000A1274;
		break;
	case 113: // 113/114 are same
	case 114:
		pStaticVar1 = (SBDisplayStack**)0x000B1998;
		pStaticVar2 = (SBDisplayStack**)0x000B19B0;
		break;
	}
	
	NSLog(@"OS Version %d, static var1: 0x%x, var2: 0x%x",version,pStaticVar1,pStaticVar2);
	if([*pStaticVar1 topApplication]){
		return [*pStaticVar1 topApplication];
	}
	return [*pStaticVar2 topApplication];
}

BOOL _isTopApplication(NSString* bundleId){
	BOOL result = NO;
	SBApplication *app = _getSBTopApplication();
	if(app){
		result = [[[app bundle] bundleIdentifier] isEqualToString:bundleId];
	}
	NSLog(@"_isTopApplication(%@) = %@",bundleId,result?@"YES":@"NO");
	return result;
}


@implementation ISMS_SBTelephonyManager : SBTelephonyManager
+ (void)load
{
	if(!hookEnabled()){
		//printf("iSMS hook is disabled");
		return;
	}
	printf("\n****isms_SBTelephonyManager, loading!!\n\n");
	[self poseAsClass: [SBTelephonyManager class]];
}

- (id)init{
	id result = [super init];
	if(result){
		// Replace the notification callback with ours
		void* center =  CTTelephonyCenterGetDefault();
		CTTelephonyCenterRemoveObserver(center, self,kCTSMSMessageReceivedNotification,NULL);
		CTTelephonyCenterAddObserver(center, self, __ISMS_MSG_RECEIVED_CALLBACK,kCTSMSMessageReceivedNotification,NULL,4);
		NSLog(@"iSMS Helper - Callback routine for incoming message notification is changed to: 0x%x",__ISMS_MSG_RECEIVED_CALLBACK);
	}
	return result;
}

// Logic is based on the disassembled springboard code
-(void)_receivedMessage:(struct __CTSMSMessage *)msg{
	NSLog(@"Received Message %@",msg); 
	if(isSenderBlocked(msg)){
		// Remove the message
		//_CTSMSMessageStoreRemoveMessage(msg);
		CTSMSMessageDelete(msg);
		return;
	}
	SBAwayController *awayController = [SBAwayController sharedAwayController];
	// Need to display the sms alert when: locked or no SMSApp is running
	//if([awayController isLocked] || (![isms_SBDisplayStack isTopApplication:ISMS_IDENTIFIER] && ![isms_SBDisplayStack isTopApplication:APPLE_SMS_IDENTIFIER])){
	
	if([awayController isLocked] || (!_isTopApplication(ISMS_IDENTIFIER) && !_isTopApplication(APPLE_SMS_IDENTIFIER))){
		if(_isNewMessagePreviewEnabled()){
			SBSMSAlertItem *_alert = [[SBSMSAlertItem alloc] init];
			[_alert setMessage:msg];
			[(SBAlertItemsController*)[SBAlertItemsController sharedInstance] activateAlertItem:_alert];
			[_alert release];
			[[awayController awayModel] addSMSMessage:msg];
		}else{
			// We disabled the new message preview, so just play the sound
			_playMessageReceivedSound();
		}
	}

	[self updateSMSBadges];
	return;
}

- (void)updateSMSBadges; // IMP=0x00025cb0
{
	//SBUIController *controller = [SBUIController sharedInstance];
	//SBIconList* iconList = [controller iconList];
	// Update our icon only
	NSString *appId = isPrimarySMSApp()?ISMS_IDENTIFIER:APPLE_SMS_IDENTIFIER;	
	SBApplicationIcon *appIcon = getAppIconById(appId);
	[appIcon retain];
	int i = CTSMSMessageGetUnreadCount();
	if(i> 0) {
		[appIcon setBadge:[NSString stringWithFormat:@"%d",i]];			
		[UIApp addStatusBarImageNamed:@"iSMS" removeOnAbnormalExit:YES];
	} else {
		[appIcon setBadge:nil];
		[UIApp removeStatusBarImageNamed: @"iSMS"];
	}
	[appIcon release];
	//[super updateSMSBadges];
}
@end