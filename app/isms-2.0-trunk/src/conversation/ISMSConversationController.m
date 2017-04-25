//==============================================================================
//	Created on 2008-4-11
//==============================================================================
//	$Id$
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

#import "Prefix.h"
#import "ISMSConversationController.h"
#import "ObjectContainer.h"
#import <UIKit/UIKit.h>

@implementation ISMSConversationController : NSObject
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
	// TODO customized init logic here
	return self;
}

-(void)dealloc{
	// TODO your dealloc codes here
	[super dealloc];
}

-(void)_initViews{
	
}

-(void)show{
	
}
@end