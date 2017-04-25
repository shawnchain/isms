//==============================================================================
//	Created on 2007-12-3
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
//  along with Foobar.  If not, see <http://www.gnu.org/licenses/>.
//==============================================================================
#import "UIModalAlertSheet.h"
#import "Log.h"

#ifdef __BUILD_FOR_2_0__
#import <UIKit/UIAlertView-Private.h>
#endif

/***************************************************************
 * Class Comments
 * 
 * @Author Shawn
 ***************************************************************/
@implementation UIModalAlertSheet 
-(id)init {
	self = [super init];
	if(self == nil) {
		return nil;
	}
	result = -1;
	//[self setRunsModal:YES];
	return self;
}

-(id)initWithTitle:(NSString*) title buttons:(NSArray*)buttons defaultButtonIndex:(int)defaultButtonIndex{
	[super initWithTitle:title buttons:buttons defaultButtonIndex:defaultButtonIndex delegate:self context:self];
	[self setRunsModal:YES];
	return self;
}

//- (void) _buttonClicked: (id) button {
//	[super _buttonClicked:button];
//	NSArray* btns = [self buttons];
//	int i;
//	for(i = 0;i < [btns count];i++) {
//		if(button == [btns objectAtIndex:i]) {
//			result = i+1;
//#ifdef DEBUG			
//			LOG(@"UIModalAlertSheet::_buttonClicked - Button %d is clicked",result);
//#endif			
//			break;
//		}
//	}
//	[self dismiss];
//}

-(int)result {
	return result;
}

#ifdef __BUILD_FOR_2_0__
-(void)alertView:(UIAlertView*)sheet clickedButtonAtIndex:(int)button {
#else
-(void)alertSheet:(UIAlertSheet*)sheet buttonClicked:(int)button {
#endif
	result = button + 1;
	LOG(@"UIModalAlertSheet::alertSheet %@ - Button %d is clicked",sheet, result);
	[sheet dismiss];
}

//-(void)popup{
//	[self ]
//}
@end
