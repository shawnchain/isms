//==============================================================================
//	Created on 2008-1-28
//==============================================================================
//	$Id: Criteria.h 179 2008-03-06 07:17:09Z shawn $
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
#ifndef CRITERIA_H_
#define CRITERIA_H_

#import <Foundation/Foundation.h>

/***************************************************************
 * Class Comments
 * 
 * @Author Shawn
 ***************************************************************/
@interface Criteria : NSObject
{
	int 		offset;
	int 		limit;
	NSString	*where;
	NSString	*order;
	//NSMutableDictionary	*condition;
}

+(Criteria*) criteria:(NSString*)where order:(NSString*)order limit:(int)limit offset:(int)offset;
+(Criteria*) criteria:(NSString*)where order:(NSString*)order;
+(Criteria*) criteria:(NSString*)where;

-(NSString*)sql;
-(int)limit;
-(int)offset;
@end
#endif /*CRITERIA_H_*/
