//==============================================================================
//	Created on 2008-1-30
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
#import "Prefix.h"
#import "BlackList.h"
#import "ObjectContainer.h"
#import "iSMSPreference.h"
#import <Foundation/Foundation.h>
#import "NSString-PhoneNumber.h"

@implementation BlackList : NSObject

/***************************************************************
 * Class Comments
 * //TODO Should always exists in the SpringBoard process
 * @Author Shawn
 ***************************************************************/
+(void)initialize {
	static BOOL initialized = NO;
	if (!initialized) {
		[[ObjectContainer sharedInstance] registerObject:self forKey:self isSingleton:YES];
		initialized = YES;
	}
}

+(id)sharedInstance {
	return [[ObjectContainer sharedInstance] objectForKey:self];
}

-(id)init {
	[super init];
	return self;
}

-(void)dealloc {
	//RELEASE(blackList);
	[super dealloc];
}

-(BOOL)_isNumber:(NSString*)number matches:(NSString*)pattern {
	return [number isEqualToString:pattern];
}

-(BOOL)isBlocked:(NSString*)address {
	BOOL result = NO;
	iSMSPreference *pref = [iSMSPreference sharedInstance];
	NSArray* a = [pref objectForKey:BLACK_LIST];
	for(int i = 0;i <[a count];i++) {
		NSString *p = [a objectAtIndex:i];
		NSLog(@"%@ == %@ ?",address,p);
		if([self _isNumber:address matches:p]) {
			result = YES;
			break;
		}
	}
	NSLog(@"isBlocked %@ ? - %d",address,result);
	return result;
}

-(void)block:(NSString*)address block:(BOOL)block {
	BOOL needSave = NO;
	iSMSPreference *pref = [iSMSPreference sharedInstance];
	NSArray* a = [pref objectForKey:BLACK_LIST];
	if(!block && a == nil) {
		// Nothing to unblock ?
		return;
	}
	NSMutableArray* a2;
	if(a) {
		a2 = [[NSMutableArray alloc]initWithArray:a];
	} else {
		a2 = [[NSMutableArray alloc]init];
	}
	if(block) {
		[a2 addObject:[address formalizedPhoneNumber]];
		needSave = YES;
		//[d2 setObject:@"blocked" forKey:[address formalizedPhoneNumber]];
	} else {
		// Search the black list and remove if found;
		for(int i = 0;i < [a2 count];i++) {
			if([address isEqualToString:[a2 objectAtIndex:i]]) {
				[a2 removeObjectAtIndex:i];
				needSave = YES;
				break;
			}
		}
		//[d2 removeObjectForKey:[address formalizedPhoneNumber]];
	}
	if(needSave) {
		[pref setObject:a2 forKey:BLACK_LIST];
		[pref flush];
	}
	[a2 release];
}

-(void)block:(NSString*)address {
	[self block:address block:YES];
}

-(void)unblock:(NSString*)address {
	[self block:address block:NO];
}

-(NSArray*)list {
	NSArray* result = [[iSMSPreference sharedInstance] objectForKey:BLACK_LIST];
	NSMutableArray* array = [[NSMutableArray alloc] initWithArray:result];
	//[array addObject:@"10086"];
	return [array autorelease];
}

-(int)count {
	return [[[iSMSPreference sharedInstance] objectForKey:BLACK_LIST]count];
}
@end