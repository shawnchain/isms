//==============================================================================
//	Created on 2008-1-20
//==============================================================================
//	$Id: MessageTemplate.h 251 2008-09-11 13:16:22Z shawn $
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
#ifndef MESSAGETEMPLATE_H_
#define MESSAGETEMPLATE_H_
#import <Foundation/Foundation.h>

@class NSArray;
@class NSMutableArray;

@interface MessageTemplate : NSObject
{
	NSArray			*defaultList;
	NSMutableArray	*customizedList;
}
+(id)sharedInstance;
-(NSArray*)defaultTemplates;
-(NSArray*)customizedTemplates;

-(void)addTemplate:(NSString*)content;
-(void)removeTemplateAtIndex:(int)idx;
@end
#endif /*MESSAGETEMPLATE_H_*/
