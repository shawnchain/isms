//==============================================================================
//	Created on 2007-12-5
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

#import "UIImageNavigationBar.h"

#ifdef __BUILD_FOR_2_0__
#import <UIKit/UIImage-UIImagePrivate.h>
#import <UIKit/UINavigationButton.h>
#endif

#define IMAGE_BUTTON_PREFIX @"img:"

@implementation UIImageNavigationBar //(ImageButton)
- (id)createButtonWithContents:(id) aid  width:(float) awidth  barStyle:(int) abarStyle  buttonStyle:(int) abuttonStyle  isRight:(BOOL) aisRight{
	
	NSString* title = (NSString*)aid;
	if(title && [title hasPrefix:IMAGE_BUTTON_PREFIX]){
#ifdef __BUILD_FOR_2_0__
		UINavigationButton * pushButton = [super createButtonWithContents:@"" width:10 barStyle:abarStyle buttonStyle:abuttonStyle isRight:aisRight];
#else
		UINavBarButton *pushButton = [super createButtonWithContents:@"" width:10 barStyle:abarStyle buttonStyle:abuttonStyle isRight:aisRight];
#endif
		//[pushButton setTitle:@""];
		NSString *imageFile = [title substringFromIndex:4];
		UIImage *btnImage = [UIImage applicationImageNamed:[NSString stringWithFormat:@"%@.png",imageFile]];
		UIImage *btnOnImage = [UIImage applicationImageNamed:[NSString stringWithFormat:@"%@_on.png",imageFile]];

		[pushButton setEnabled:YES];
#ifdef __BUILD_FOR_2_0__
		[pushButton setBackgroundImage:btnImage forState:0];  //up state
		[pushButton setBackgroundImage:btnOnImage forState:1];  //up state

#else
		[pushButton setDrawsShadow: NO];
		[pushButton drawImageAtPoint: CGPointMake(0.0, 0) fraction: 0.0];
		[pushButton setStretchBackground:NO];
		[pushButton setBackground:btnImage forState:0];  //up state
		[pushButton setBackground:btnOnImage forState:1];  //up state
#endif

		return pushButton;
	}else{
		return 	[super createButtonWithContents:aid width:awidth barStyle:abarStyle buttonStyle:abuttonStyle isRight:aisRight];
	}
	
	//[super createButtonWithContents:aid width:awidth barStyle:abarStyle buttonStyle:abuttonStyle isRight:aisRight];
	//return [super createButtonWithContents:aid width:awidth barStyle:abarStyle buttonStyle:abuttonStyle isRight:aisRight];
}
@end
