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
#import "NSString-PhoneNumber.h"

NSString* _formalizePhoneNumber(NSString* inNumber){
	NSMutableString* outNumber = [[NSMutableString alloc]init];
	for(unsigned int i = 0;i<[inNumber length];i++){
		unichar aChar = [inNumber characterAtIndex:i];
		if(aChar >= '0' && aChar <= '9'){
			[outNumber appendFormat:@"%c",aChar];	
		}
	}
	return [outNumber autorelease];
}

@implementation NSString(PhoneNumber)
-(NSString*)formalizedPhoneNumber{
	return _formalizePhoneNumber(self);
}
@end