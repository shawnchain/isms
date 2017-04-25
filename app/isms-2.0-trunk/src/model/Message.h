//==============================================================================
//	Created on 2007-11-18
//==============================================================================
//	$Id$
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
//  along with Foobar.  If not, see <http://www.gnu.org/licenses/>.
//==============================================================================

#ifndef MESSAGE_H_
#define MESSAGE_H_

#import <Foundation/Foundation.h>
#import "Entity.h"
#import "Contact.h"

typedef enum _msg_type{
	UNREAD_MESSAGE = 0,
	DRAFT_MESSAGE = 1,
	READ_MESSAGE = 2,
	SENT_MESSAGE = 3,
	SEND_FAIL_MESSAGE = 33,
} MessageType;

#define MESSAGE_TABLE @"message"
#define DRAFT_MESSAGE_TABLE @"draft_message"
#define DELETED_MESSAGE_TABLE @"deleted_message"

#define INBOX_MESSAGE READ_MESSAGE

typedef enum _msg_change_notification_type
{
	MESSAGE_CHANGED	= 1,
	MESSAGE_RECEIVED= (1 << 1 | 1),
	MESSAGE_CREATED = (1 << 2 | 1),
	MESSAGE_UPDATED = (1 << 3 | 1),
	MESSAGE_DELETED = (1 << 4 | 1),
} MessageChangeNotificationType;

#define MESSAGE_CHANGE_NOTIFICATION @"MESSAGE_CHANGE_NOTIFICATION"

/**
 * Interface of Message Entity
 * 
 * @Author Shawn
 */
@interface Message : NSObject<Entity>
{
	@public
	int 	 rowId;
	NSString *phoneNumber;
	NSString *body;
	NSDate	 *date;
	NSString *senderName;
	int		 type;
	Contact	 *sender;
	//BOOL	 isDraft;
	NSString *targetTable;
}

+(Message*)newDraftMessage;

+(Message*)load:(NSString*) msgId;
+(Message*)loadById:(int) msgId;

+(NSArray*)list;
+(NSArray*)listByType:(MessageType)type;
+(NSArray*)listInbox;
+(NSArray*)list:(Criteria*) criteria;
+(NSArray*)listUnreadMessages;
+(NSArray*)listDraftMessages;

+(int)count;
+(int)countByType:(MessageType)type;
+(int)countInbox;
+(int)count:(Criteria*)criteria;

+(int)countUnreadMessages;
+(int)countDraftMessages;

+(int)delete:(Criteria*) criteria;
+(int)deleteByType:(MessageType)type;

+(NSArray*)search:(NSString*)searchContent;

-(id)initWithRowData:(NSDictionary*) row;
-(BOOL)save;
-(BOOL)delete;

-(BOOL)isOutgoing;
-(BOOL)hasBeenRead;
-(BOOL)hasBeenSent;
-(BOOL)isDeleted;
-(BOOL)isProtected;

-(void)markAsRead:(BOOL)read;
-(void)markAsSent:(BOOL)sent;

-(BOOL)isDraft;
-(BOOL)isArchived;

-(NSString*)_getTargetTable;

-(NSString*)toString;

/* No setter methods, and be immutable ? */
-(void)setMsgId:(NSString*) value;
-(void)setPhoneNumber:(NSString*) value;
-(void)setDate:(NSDate*) value;
-(void)setBody:(NSString*) value;
//-(void)setType:(int) value;

-(NSString*) msgId;
-(NSString*) phoneNumber;
-(NSDate*) date;
-(NSString*) body;
-(NSString*) text;
-(int) type;

-(Contact*) getSender; //FIXME should be getContact ??
//-(Contact*) getSender;
-(NSString*) getSenderName; //FIXME should be getContactName ??

- (void)dealloc;

@end
#endif /*MESSAGE_H_*/