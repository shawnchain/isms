//==============================================================================
//	Created on 2008-1-20
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
//  along with iSMS.  If not, see <http://www.gnu.org/licenses/>.
//==============================================================================
#import "MessageTemplate.h"
#import "Prefix.h"
#import "ObjectContainer.h"
#import "iSMSPreference.h"

#define MESSAGE_TEMPLATE @"MESSAGE_TEMPLATE"

@implementation MessageTemplate : NSObject
+(void)initialize{
	static BOOL initialized = NO;
	if (!initialized) {
		[[ObjectContainer sharedInstance] registerObject:self forKey:self isSingleton:YES];
		initialized = YES;
	}
}

+(id)sharedInstance{
	return [[ObjectContainer sharedInstance] objectForKey:self];
}


-(id)init{
	[super init];
	
	defaultList = [[NSArray arrayWithObjects:
		NSLocalizedStringFromTable(@"I am late, I will be there at",@"iSMS",@""),
		NSLocalizedStringFromTable(@"I will be arriving at",@"iSMS",@""),
		NSLocalizedStringFromTable(@"I'm at home. Please call",@"iSMS",@""),
		NSLocalizedStringFromTable(@"I'm at work. Please call",@"iSMS",@""),
		NSLocalizedStringFromTable(@"I'm in a meeting, call me later at",@"iSMS",@""),
		NSLocalizedStringFromTable(@"Meeting is cancelled.",@"iSMS",@""),
		NSLocalizedStringFromTable(@"Please call",@"iSMS",@""),
		NSLocalizedStringFromTable(@"See you at",@"iSMS",@""),
		NSLocalizedStringFromTable(@"See you in",@"iSMS",@""),
		NSLocalizedStringFromTable(@"Sorry, I can't help you on this.",@"iSMS",@""),
		NSLocalizedStringFromTable(@"Thank you for using iSMS",@"iSMS",@""),
		nil] retain];
	
	iSMSPreference *pref = [iSMSPreference sharedInstance];
	NSArray* c = (NSArray*)[pref objectForKey:MESSAGE_TEMPLATE];
	customizedList = [[NSMutableArray alloc]initWithArray:c];
	return self;
}

-(void)dealloc{
	RELEASE(defaultList);
	RELEASE(customizedList);
	[super dealloc];
}


-(void)addTemplate:(NSString*)content{
	DBG(@"Adding template: \"%@\"",content);
	[customizedList addObject:content];
	
	NSArray *newList = [[NSArray alloc]initWithArray:customizedList];
	iSMSPreference *pref = [iSMSPreference sharedInstance];
	[pref setObject:newList forKey:MESSAGE_TEMPLATE];
	[pref flush];
	[newList release];
}

-(void)removeTemplateAtIndex:(int)idx{
	if(idx < [customizedList count]){
		DBG(@"Removing template: %d",idx);
		[customizedList removeObjectAtIndex:idx];
		
		NSArray *newList = [[NSArray alloc]initWithArray:customizedList];
		iSMSPreference *pref = [iSMSPreference sharedInstance];
		[pref setObject:newList forKey:MESSAGE_TEMPLATE];
		[pref flush];
		//RETAIN(customizedList,newList);
		[newList release];
	}
}

-(NSArray*)defaultTemplates{
	return defaultList;
}

-(NSArray*)customizedTemplates{
	return customizedList;
}
@end
