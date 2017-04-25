//==============================================================================
//	Created on 2007-12-13
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

#import "UISMSTextView.h"
#import "UIComposeSMSView.h"
#import "UISMSTextView.h"

/***************************************************************
 * Class Comments
 * 
 * @Author Shawn
 ***************************************************************/
@implementation UISMSTextView
-(void) webViewDidChange: (id) webView{
NSLog(@"UISMSTextView webViewDidChange: webView %@", webView);
	[super webViewDidChange:webView];
	[(UIComposeSMSView*)[self delegate] _smsTextChanged];
}

- (BOOL) becomeFirstResponder{
	BOOL result = [super becomeFirstResponder];
NSLog(@"UISMSTextView self %@ canBecomeFirstResponder %d super becomeFirstResponder: %d webView becomeFirstResponder %d", self, [self canBecomeFirstResponder], result,
      [[self webView] becomeFirstResponder]);
	[(UIComposeSMSView*)[self delegate] _focusChanged:self];
	return result;
}

/*
-(void) _mouseDown:(struct __GSEvent *)event
{
       NSLog(@"UISMSTextView mouseDown");
       [super _mouseDown:event];
}
*/
@end
