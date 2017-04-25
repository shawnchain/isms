//==============================================================================
//	Created on 2007-11-18
//==============================================================================
//	$Id: ContactPickerView.h 263 2008-09-17 15:17:42Z shawn $
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

#ifndef CONTACTPICKERVIEW_H_
#define CONTACTPICKERVIEW_H_

#import "Prefix.h"
#import <UIKit/UIKit.h>
#import <UIKit/UIView.h>
#import <AddressBookUI/ABPeoplePicker.h>

// Some ugly external data/functions
extern NSString* const kABCPhoneProperty;
#ifdef __BUILD_FOR_2_0__
struct CPRecord;
#import <AddressBook/AddressBook.h>
#else
extern NSString* const kABCEmailProperty;
extern int ABCRecordCopyValue(struct CPRecord *, int); //arg2 property
extern int ABCMultiValueIndexForIdentifier(int, int); //arg2 identifier
extern NSString* ABCMultiValueCopyValueAtIndex(int, int); //
extern NSString* ABCRecordCopyCompositeName(struct CPRecord*);
extern int ABCMultiValueGetCount(int);
extern void ABCMultiValueDestroy(int);

extern NSString* ABCMultiValueGetLabelAtIndex(int,int);
extern NSString* ABCCopyLocalizedPropertyOrLabel(NSString*);
#endif

/***************************************************************
 * Wrapper view class for ABPeoplePicker controller
 * Based on the coded originally by ChinaET/gaoxiaojun@gmail.com
 * 
 * @Author Shawn
 ***************************************************************/

#define ISMS_NOTIFICATION_CONTACT_SELECTED @"ISMS_NOTIFICATION_CONTACT_SELECTED"

@interface ContactPickerView : UIView
{
	ABPeoplePicker *_peoplepicker;
	NSString *contactPropertyName;
	NSString *contactPropertyValue;
	NSString *contactName;
	id _delegate;
}

- (id)initWithFrame:(struct CGRect)rect withDelegate:(id) aDelegate;
/*
 - (void)peoplePicker:(id)fp8 displayedMembersOfGroup:(struct CPRecord *)fp12;
 - (void)peoplePicker:(id)fp8 editedPerson:(struct CPRecord *)fp12 property:(int)fp16 identifier:(int)fp20;
 - (void)peoplePicker:(id)fp8 enteredOtherValue:(void *)fp12 forProperty:(int)fp16;
 - (void)peoplePicker:(id)fp8 selectedPerson:(struct CPRecord *)fp12 property:(int)fp16 identifier:(int)fp20;
 - (BOOL)peoplePicker:(id)fp8 shouldShowCardForPerson:(struct CPRecord *)fp12;
 - (void)peoplePickerDidEndPicking:(id)fp8;
 - (void)peoplePickerDisplayedGroups:(id)fp8;
 - (UIView *)peoplePickerView;
 - (NSString *)phonenumber;
 - (NSString *)name;
 */
- (void)setDelegate:(id)delegate;
- (NSString *)getSelectedPropertyName;
- (NSString *)getSelectedPropertyValue;
- (NSString *)getSelectedContactName;
- (void)clearAllData;

@end

@interface ISMSContactPickerViewController :UIViewController

@end
#endif /*CONTACTPICKERVIEW_H_*/
