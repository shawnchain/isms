//==============================================================================
//	Created on 2008-09-13
//==============================================================================
//	$Id$
//==============================================================================
//	Copyright (C) <2007,2008>  Shawn Qian(shawn.chain@gmail.com)
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

#import <UIKit/UIKit.h>
//#import <UIKit/UIScroller.h>
#import <UIKit/UIViewController.h>

#import <MessageUI/ComposeRecipientView.h>
@interface ISMSComposeViewController : UIViewController {
	//ComposeRecipientView *recipientView;
	//IBOutlet UIScroller *composeArea;
	IBOutlet UITextField *recipientField;
	IBOutlet UITextView *textView;
	IBOutlet UIBarButtonItem *sendButton;
}

//@property(nonatomic,retain) ComposeRecipientView *recipientView;
//@property(nonatomic,retain) UIScroller *composeArea;
@property(nonatomic,retain)  UITextField *recipientField;
@property(nonatomic,retain)  UITextView *textView;
@property(nonatomic,retain)  UIBarButtonItem *sendButton;

+(id) sharedInstance;
- (IBAction)onCancel;
- (IBAction)onSend;
- (IBAction)onChooseSmiley;
- (IBAction)onRecipientChanged;
- (IBAction)onTextChanged;

@end
