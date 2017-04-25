//==============================================================================
//	Created on 2008-4-11
//==============================================================================
//	$Id: ISMSConversationModel.h 201 2008-04-19 16:18:29Z shawn $
//==============================================================================
//	Copyright (C) <2008>  Shawn Qian(shawn.chain@gmail.com)
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
#ifndef ISMSCONVERSATIONMODEL_H_
#define ISMSCONVERSATIONMODEL_H_

#import <Foundation/NSObject.h>

@class NSArray;
@class NSMutableArray;
@class Message;
@interface ISMSConversationModel : NSObject{
//	NSString	*buddyName;
	NSString	*phoneNumber;
	NSArray		*messages;
}

+(id)load:(NSString*)phoneNumber;
-(id)initWithPhoneNumber:(NSString*)aNumber;
-(NSArray*)messages;
-(int)messageCount;
-(Message*)messageAtIndex:(int)index;
-(NSString*)phoneNumber;
-(void)clear;

-(void)_reloadMessages;
@end

#endif /*ISMSCONVERSATIONMODEL_H_*/
