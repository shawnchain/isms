//==============================================================================
//	Created on 2008-1-28
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
#import "Criteria.h"

@implementation Criteria : NSObject

/**
 * Offset is start by 0
 */
+(Criteria*) criteria:(NSString*)where order:(NSString*)order limit:(int)limit offset:(int)offset{
	Criteria *c = [[Criteria alloc]init];
	c->limit = limit;
	c->offset = offset;
	c->where = [where retain];
	c->order = [order retain];
	return [c autorelease];
}

+(Criteria*) criteria:(NSString*)where order:(NSString*)order{
	return [self criteria:where order:order limit:-1 offset:-1];
}


+(Criteria*) criteria:(NSString*)where{
	return [self criteria:where order:nil limit:-1 offset:-1];
}

-(id)init{
	[super init];
	limit = -1;
	offset = -1;
	return self;
}

-(void)dealloc{
	RELEASE(where);
	RELEASE(order);
	[super dealloc];
}

-(int)limit
{
	return limit;
}

-(int)offset{
	return offset;
}

-(NSString*)sql{
	NSMutableString	*sql = [[NSMutableString alloc]init];
	if(where){
		[sql appendFormat:@" WHERE %@ ",where];
	}
	if(order){
		[sql appendFormat:@" ORDER BY %@ ",order];
	}
	if(limit >= 0){
		[sql appendFormat:@" LIMIT %d ",limit];
	}
	
	if(offset >= 0){
		[sql appendFormat:@" OFFSET %d ",offset];
	}
	return [sql autorelease];
}
@end