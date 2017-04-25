//==============================================================================
//	Created on 2007-12-8
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

#import "ObjectContainer.h"
#import "ObjectAdapter.h"
#import "Prefix.h"

static ObjectContainer* container = nil;
/***************************************************************
 * You will smile if you know IoC. :)
 * and if you will laugh if you know Pico Container. :@
 * 
 * lol
 * 
 * @Author Shawn
 ***************************************************************/

@implementation ObjectContainer
+(void)initialize {
	static BOOL initialized = NO;
	if (!initialized) {
		if(container) {
			[self release];
		}
		container = [[ObjectContainer alloc] init];
		initialized = YES;
	}
}

+(void)release {
	if(container) {
		[container release];
		container = nil;
	}
}

+(id)sharedInstance {
	if(container == nil) {
		[self initialize];
	}
	return container;
}

-(id)init {
	self = [super init];
	if(!self) {
		return nil;
	}
	repository = [[NSMutableDictionary alloc]init];
	return self;
}

-(id)getObjectForKey:(id)key {
	return [self objectForKey:key];
}

-(id)objectForKey:(id)key {
	ObjectAdapter *adapter = [repository objectForKey:key];
	if(adapter != nil) {
		return [adapter getInstance];
	}
	return nil;
}

-(void)registerObject:(Class)clazz forKey:(id)key isSingleton:(BOOL)flag {
	ObjectAdapter *adapter = [[ObjectAdapter alloc] initWithClass:clazz isSingleton:flag];
	[repository setObject:adapter forKey:key];
	[adapter release];
}

-(void)registerObject:(Class)clazz forKey:(id)key {
	[self registerObject:clazz forKey:key isSingleton:YES];
}

-(void)registerObjectAdapter:(ObjectAdapter*) adapter forKey:(id)key {
	[repository setObject:adapter forKey:key];
}

-(void)registerObjectInstance:(id)aInstance forKey:(id)key {
	ObjectInstanceAdapter* adapter = [[ObjectInstanceAdapter alloc]initWithInstance:aInstance];
	[repository setObject:adapter forKey:key];
	[adapter release];
}

-(void)dealloc {
	RELEASE(repository);
	[super dealloc];
}
@end

/***************************************************************
 * Adapter class
 * 
 * @Author Shawn
 ***************************************************************/
@implementation ObjectAdapter
-(id)initWithClass:(Class)clazz isSingleton:(BOOL)flag {
	self = [super init];
	if(!self) {
		return nil;
	}
	objectClass = clazz;
	shouldCacheInstance = flag;
	cachedInstance = nil;

	return self;
}

-(id)getInstance {
	if(cachedInstance != nil) {
		//LOG(@"getInstance return cached object instance %@(0x%x)",[cachedInstance class],cachedInstance);
		return cachedInstance;
	}
	id newInstance = [self newInstance];
	if(newInstance) {
		LOG(@"Object %@(0x%x) created",[newInstance class],newInstance);
		// Invoke the post initializer if exists ?
	}
	if(newInstance != nil && shouldCacheInstance) {
		cachedInstance = newInstance;
		LOG(@"Object %@(0x%x) cached",[newInstance class],newInstance);
	}
	return newInstance;
}

-(void)setObjectClass:(Class)aClass {
	objectClass = aClass;
}

-(void)setCacheInstance:(BOOL)flag {
	shouldCacheInstance = flag;
}

-(id)newInstance {
	// The default method
	return [[objectClass alloc] init];
}

-(void)dealloc {
	RELEASE(cachedInstance);
	[super dealloc];
}
@end

@implementation ObjectInstanceAdapter
-(id)initWithInstance:(id)aInstance {
	self = [super init];
	if(!self) {
		return nil;
	}
	cachedInstance = [aInstance retain];
	return self;
}
-(id)getInstance {
	return cachedInstance;
}
@end