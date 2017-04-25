//==============================================================================
//	Created on 2007-11-18
//==============================================================================
//	$Id: UIComposeSMSView.h 267 2008-09-21 14:21:50Z shawn $
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

#ifndef UICOMPOSESMSVIEW_H_
#define UICOMPOSESMSVIEW_H_

#import "UIButtonBarView.h"

@class UIView;
@class UIImageView;
@class ContactPickerView;
@class UIController;
@class UINavigationBar;
@class UINavigationItem;
//@class UISMSRecipientField;
@class ComposeRecipientView;
@class UIScroller;
@class UISMSTextView;
@class UITextLabel;
@class UIKeyboard;
@class ISMSProgressViewController;
@class ISMSSmileyChooserViewController;
@class ISMSTemplateChooserViewController;
@class UIQuickContactList;
@class Message;

@class UIComposeArea;
@class ISMSContactPickerViewController;


#ifdef __BUILD_FOR_2_0__
@class UIAlertView;
@class UIActionSheet;
#else
@class UIAlertSheet;
#endif


/***************************************************************
 * UI class for SMS message composing
 * 
 * @Author Shawn
 ***************************************************************/
//TODO 1-Auto-sized recipient field
//TODO 5-Offline sms sending
//TODO 7-Support instant search contact by input chars in recipient field 
@interface UIComposeSMSView : UIButtonBarView//: UIView
{
	
	UIView *defaultView;
	UIComposeArea *composeArea;

	//ContactPickerView *contactListView;
	ISMSContactPickerViewController *contactPickerViewController;
	UIController *controller;
	
//	UINavigationBar *navBar;
//	UINavigationItem *navTitle;
	//UITextView	*smsReceiverView;
	//UISMSRecipientField 	*fldRcpt;
	
//	ComposeRecipientView	*fldRcpt2;
//	UIScroller				*rcptAreaView;
//	UISMSTextView *smsTextView;
//	UITextLabel *lblTxtLength;

	ISMSProgressViewController *progressViewController;
	
	ISMSSmileyChooserViewController *smileyChooserViewController;
	ISMSTemplateChooserViewController *templateChooserViewController;
	UIQuickContactList	*quickContactList;
	id delegate;

	//BOOL textAreaIsFocused;
	BOOL pickingContactForSending;
	
	Message* message;
	BOOL recipientChanged;
	
#ifdef __BUILD_FOR_2_0__
	UIActionSheet 	*saveAlert;
	UIAlertView	*sendAlert;
	UIAlertView	*sendFailedAlert;
#else
	UIAlertSheet	*saveAlert;
	UIAlertSheet	*sendAlert;
	UIAlertSheet	*sendFailedAlert;
#endif
}

- (id)initWithFrame:(struct CGRect)rect;
-(void)setInitialText:(NSString*) iText;
-(void)setMessage:(Message*)msg;
-(void)addRecipient:(NSString*) name withNumber:(NSString*) number;
-(void)clearAllData;
-(void)setTitle:(NSString*) title;
// Callback methods
-(void)_recipientFieldChanged;
-(void)_focusChanged:(id) control;
-(void)_smsTextChanged;


// Callback for UIContactPickerView
-(void)onContactSelected:(NSNotification*)aNotify;

-(void)insertSMSText:(NSString*)text;
-(void)appendContactInfoToSMSText:(NSString*) aName value:(NSString*) aValue;

+(BOOL)_isValidPhoneNumber:(NSString*) number;

//Internal methods
-(void)_createMainView;
-(void)_setQuickContactSearchString:(NSString*) search;
-(void)_chooseContactForRcpt;
-(void)_chooseContactForSMS;
-(void)_updateSendButtonState;
@end
#endif /*UICOMPOSESMSVIEW_H_*/
