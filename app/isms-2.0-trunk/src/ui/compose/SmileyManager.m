//==============================================================================
//	Created on 2007-12-18
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
#import "SmileyManager.h"
#import "ObjectContainer.h"
#import "Log.h"

@implementation SmileyManager


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

-(NSDictionary*)allSmileyMap{
	return smileyMap;
}

-(NSDictionary*)availableSmileyMap{
	return availableSmileyMap;
}


-(void)_loadSmileys{
	//TODO load from file ?
//	smileyMap = [[NSDictionary dictionaryWithObjectsAndKeys:
//	@":)", @"1.png",
//	@":-)", @"1.png",
//	@":(", @"2.png",
//	@":-(", @"2.png",
//	nil] retain];
	
	smileyMap = [[NSMutableDictionary alloc] init];
	availableSmileyMap = [[NSMutableDictionary alloc] init];
	
	[smileyMap setObject:@"smile.png" forKey:@":)"];
	[smileyMap setObject:@"smile.png" forKey:@":-)"];
	[availableSmileyMap setObject:@"smile.png" forKey:@":)"];
	
	[availableSmileyMap setObject:@"smile-big.png" forKey:@":D"];
	[smileyMap setObject:@"smile-big.png" forKey:@":D"];
	[smileyMap setObject:@"smile-big.png" forKey:@":d"];
	[smileyMap setObject:@"smile-big.png" forKey:@":-D"];
	[smileyMap setObject:@"smile-big.png" forKey:@":-d"];
	
	[availableSmileyMap setObject:@"sad.png" forKey:@":("];
	[smileyMap setObject:@"sad.png" forKey:@":-("];
	[smileyMap setObject:@"sad.png" forKey:@":("];
	
	[availableSmileyMap setObject:@"wink.png" forKey:@";)"];	
	[smileyMap setObject:@"wink.png" forKey:@";)"];
	[smileyMap setObject:@"wink.png" forKey:@";-)"];
	
	[availableSmileyMap setObject:@"tongue.png" forKey:@":-p"];
	[smileyMap setObject:@"tongue.png" forKey:@":P"];
	[smileyMap setObject:@"tongue.png" forKey:@":-P"];
	[smileyMap setObject:@"tongue.png" forKey:@":p"];
	[smileyMap setObject:@"tongue.png" forKey:@":-p"];
	
	[smileyMap setObject:@"shock.png" forKey:@"=-O"];
	[smileyMap setObject:@"shock.png" forKey:@"=-o"];
	
	[availableSmileyMap setObject:@"kiss.png" forKey:@":-*"];
	[smileyMap setObject:@"kiss.png" forKey:@":-*"];

	[smileyMap setObject:@"glasses-cool.png" forKey:@"8-)"];
	[availableSmileyMap setObject:@"glasses-cool.png" forKey:@"8-)"];
	
	[availableSmileyMap setObject:@"embarrassed.png" forKey:@":-["];
	[smileyMap setObject:@"embarrassed.png" forKey:@":-["];
	
	[availableSmileyMap setObject:@"crying.png" forKey:@":'("];
	[smileyMap setObject:@"crying.png" forKey:@":'("];

	[availableSmileyMap setObject:@"thinking.png" forKey:@":-/"];
	[smileyMap setObject:@"thinking.png" forKey:@":-/"];
	[smileyMap setObject:@"thinking.png" forKey:@":-\\"];

	[availableSmileyMap setObject:@"shut-mouth.png" forKey:@":-X"];
	[smileyMap setObject:@"shut-mouth.png" forKey:@":-X"];
	[smileyMap setObject:@"moneymouth.png" forKey:@":-$"];

	[availableSmileyMap setObject:@"foot-in-mouth.png" forKey:@":-!"];
	[smileyMap setObject:@"foot-in-mouth.png" forKey:@":-!"];
	
	[availableSmileyMap setObject:@"shout.png" forKey:@":-O"];
	[smileyMap setObject:@"shout.png" forKey:@":-o"];
	[smileyMap setObject:@"shout.png" forKey:@":-O"];
	[smileyMap setObject:@"shout.png" forKey:@":o"];
	[smileyMap setObject:@"shout.png" forKey:@":O"];
	
	[availableSmileyMap setObject:@"skywalker.png" forKey:@"c-)"];
	[smileyMap setObject:@"skywalker.png" forKey:@"C-)"];
	[smileyMap setObject:@"skywalker.png" forKey:@"c-)"];
	
	[availableSmileyMap setObject:@"monkey.png" forKey:@":-|)"];
	[smileyMap setObject:@"monkey.png" forKey:@":-|)"];
	
	LOG(@"Smiley loaded");
}

-(id)init{
	self = [super init];
	if(self){
		[self _loadSmileys];
	}
	return self;
}

-(void)dealloc{
	RELEASE(smileyMap);
	RELEASE(availableSmileyMap);
	[super dealloc];
}

@end