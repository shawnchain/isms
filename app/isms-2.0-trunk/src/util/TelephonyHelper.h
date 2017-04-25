//==============================================================================
//	Created on 2008-1-18
//==============================================================================
//	$Id: TelephonyHelper.h 265 2008-09-19 16:53:42Z shawn $
//==============================================================================
//	Copyright (C) <2007>  Shawn Qian(shawn.chain@gmail.com)
//
//	This file is part of iSMS.
//
//  iSMS is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  iSMS is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with iSMS.  If not, see <http://www.gnu.org/licenses/>.
//==============================================================================
#ifndef TELEPHONYHELPER_H_
#define TELEPHONYHELPER_H_

#import <Foundation/Foundation.h>

// Notification type
#define MESSAGE_RECEIVED_NOTIFICATION @"MESSAGE_RECEIVED_NOTIFICATION"
#define CORE_TELEPHONY_FRAMEWORK "/System/Library/PrivateFrameworks/CoreTelephony.framework/CoreTelephony"

extern NSString* const kCTSMSMessageReceivedNotification;
extern NSString* const kCTSMSMessageReplaceReceivedNotification;
extern NSString* const kCTSMSMessageSentNotification;
extern NSString* const kCTSMSMessageSendErrorNotificiation;


//extern struct __CTSMSMessage*;
typedef struct __CTSMSMessage* CTSMSMessageRef;

void* CTTelephonyCenterGetDefault(void);
void CTTelephonyCenterAddObserver(void*,id,CFNotificationCallback,NSString*,void*,int);
void CTTelephonyCenterRemoveObserver(void*,id,NSString*,void*);

CTSMSMessageRef CTSMSMessageCreate(void* unknow/*always 0*/,NSString* number,NSString* text);
CTSMSMessageRef CTSMSMessageCreateWithGroupAndAssociation(
		void* unknow,
		NSString* number,
		NSString* text,
		int gid,
		int ass);
CTSMSMessageRef CTSMSMessageCreateReply(void* unknow/*always 0*/,struct __CTSMSMessage* forwardTo,NSString* text);
void CTSMSMessageDelete(struct __CTSMSMessage *);

CTSMSMessageRef _CTSMSMessageCreateFromRecordID(CFAllocatorRef allocator,int rowId);


BOOL CTSMSMessageFailedSend(CTSMSMessageRef);
BOOL CTSMSMessageIsPlaceholder(CTSMSMessageRef);
BOOL CTSMSMessageIsOutgoing(CTSMSMessageRef);
BOOL CTSMSMessageHasBeenRead(CTSMSMessageRef);
BOOL CTSMSMessageHasBeenSent(CTSMSMessageRef);
int CTSMSMessageGetUnreadCount(void);

void CTSMSMessageMarkAsSent(CTSMSMessageRef sms,BOOL reserveFlag);
void CTSMSMessageMarkAsRead(CTSMSMessageRef sms,BOOL reserveFlag);

CFStringRef CTSMSMessageCopyAddress(CTSMSMessageRef);

CTSMSMessageRef _CTSMSMessageStoreGetMessage(int id);
int _CTSMSMessageGetRecordIdentifier(CTSMSMessageRef);

void CTSMSMessageStoreSave();

//int CTSMSMessageGetTypeID();
//_CFRuntimeCreateInstance(int ?);
//struct __CTSMSMessage* _CTSMSMessageCreateFromRecordID(int unknow,int msgId);

//typedef void (*CFNotificationCallback) (
//   CFNotificationCenterRef center,
//   void *observer,
//   CFStringRef name,
//   const void *object,
//   CFDictionaryRef userInfo
//);

////result could be a 8 bytes data and the latter 4 byte contains the result.
////int result[2];
//typedef struct _CTMessageSend_Result
//{
//   int unknow1;
//   int unknow2;
//}CTMessageSend_Result;
void* CTSMSMessageSend(void* result,struct __CTSMSMessage* msg);


NSString* normalizePhoneNumber(NSString* inNumber);
NSArray* normalizeAndSplitPhoneNumberEveryFourDigits(NSString* number);
// Ugly workaround for some strange phone number format :(
NSString* convertToFranceStyleNumber(NSString* aNumber);

/***************************************************************
 * TelephonyHelper
 * 
 * @Author Shawn
 ***************************************************************/
@class SQLiteDB;
@class NSArray;
@interface TelephonyHelper : NSObject{
	void	*ctLibHandler;
}
+(id)sharedInstance;
-(void)registerSMSReceivedNotification;
-(void)unregisterSMSReceivedNotification;
-(void)registerSQLiteFunctions:(SQLiteDB*) db;
-(CTSMSMessageRef) createCTSMSMessage:(NSString*) text currentNumber:(NSString*)currentNumber numbers:(NSArray*)numbers;
@end
#endif /*TELEPHONYHELPER_H_*/
