//==============================================================================
//	Created on 2007-12-3
//==============================================================================
//	$Id: UIMessageView.h 251 2008-09-11 13:16:22Z shawn $
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

#ifndef UIMESSAGEVIEW_H_
#define UIMESSAGEVIEW_H_

#import "Prefix.h"
#import "UIButtonBarView.h"
#import "Message.h"
#import "UIRichTextView.h"

#import <UIKit/UIPushButton.h>
#import <UIKit/UITextLabel.h>

@class UIMessageTextView;

#ifdef __BUILD_FOR_2_0__
@class UIActionSheet;
#else
@class UIAlertSheet;
#endif

/***************************************************************
 * Class UIMessageView
 * 
 * @Author Shawn
 ***************************************************************/
@interface UIMessageView : UIButtonBarView {
	UINavigationBar *topBar;
	UINavigationItem	*topBarTitle;
	UIView				*headPart;
	UITextField		 	*briefField;
	UIPushButton		*calloutButton;
	UIPushButton		*chatButton;
	UITextLabel			*timestampLabel;
	UIMessageTextView		*textView;
	NSArray			*messageList;
	int				currentMessageIdx;
#ifdef __BUILD_FOR_2_0__
        UIActionSheet * deleteAlert;
#else
	UIAlertSheet		*deleteAlert;
#endif
	BOOL			messageChanged;
}

//-(id)initWithFrame:(CGRect) rect;  // designated intializer
//-(void)navigationBar:(UINavigationBar*)bar buttonClicked:(int)button;

+(UIMessageView*)sharedInstance;
-(void)setMessageList:(NSArray*) msgList;
-(void)setCurrentMessageIndex:(int) idx;

-(void)movePrevious;
-(void)moveNext;

-(void)resetAllState;
@end
#endif /*UIMESSAGEVIEW_H_*/
