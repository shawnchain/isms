//==============================================================================
//	Created on 2007-11-18
//==============================================================================
//	$Id: template.txt 11 2007-11-18 05:35:36Z shawn $
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

#import "Prefix.h"
#import "ContactPickerView.h"
#import "Contact.h"
#import "Log.h"

#import "UIComposeSMSView.h"

#ifdef __BUILD_FOR_2_0__
#import <UIKit/UIView-Hierarchy.h>
#endif

/***************************************************************
 * ContactPickerView implementation
 * 
 * @Author Shawn
 ***************************************************************/

@implementation ContactPickerView

- (id) initWithFrame:(struct CGRect)rect withDelegate:(id) aDelegate {
	self = [super initWithFrame:rect];
	if(self == nil) {
		return nil;
	}
	_delegate = aDelegate;
	contactName = nil;
	contactPropertyValue = nil;
	
	rect.origin.x = rect.origin.y = 0;
	_peoplepicker =[[ABPeoplePicker alloc] initWithFrame: rect];
	[_peoplepicker setAllowsCancel: YES];
	[_peoplepicker setAllowsActions: NO];
	[_peoplepicker setAllowsOtherValue: YES];
	[_peoplepicker setPrompt: NSLocalizedStringFromTable(@"Select a recipient",@"iSMS",@"")];

	CFMutableArrayRef _props = CFArrayCreateMutable( NULL, 1, NULL );
	CFArrayAppendValue(_props, kABCPhoneProperty);
	//CFArrayAppendValue(_props, kABCEmailProperty);
	[_peoplepicker setDisplayedProperties:_props];
	CFRelease(_props);
	[_peoplepicker setDelegate: self];
	[self addSubview:_peoplepicker];

	return self;
}

- (void) dealloc {
	RELEASE(contactName);
	RELEASE(contactPropertyValue);
	RELEASE(_peoplepicker);
	[super dealloc];
}

// Callback methods for ABPeoplePicker
- (void)peoplePicker:(id)fp8 displayedMembersOfGroup:(struct CPRecord *)fp12 {
}

- (void)peoplePicker:(id)fp8 editedPerson:(struct CPRecord *)fp12 property:(int)fp16 identifier:(int)fp20 {
}

- (void)peoplePicker:(id)fp8 enteredOtherValue:(void *)fp12 forProperty:(int)fp16 {
}

#ifdef __BUILD_FOR_2_0__
-(void)copyPropertyValue:(ABRecordRef)cpRecord multiValue:(ABMultiValueRef)multiValue valueIdx:(CFIndex)valueIdx withLabel:(BOOL)withLabel
{
	if(contactPropertyValue) {
		[contactPropertyValue release];
		contactPropertyValue = nil;
	}
	
	contactPropertyValue = (NSString *)ABMultiValueCopyValueAtIndex(multiValue,valueIdx);

	if(contactName){
		[contactName release];
		contactName = nil;
	}
	
	CFStringRef compositeName = ABRecordCopyCompositeName(cpRecord);
	if(withLabel){
		// Append phone label if contact has 2+ phone numbers
		CFStringRef label = ABMultiValueCopyLabelAtIndex(multiValue,valueIdx);
		CFStringRef localizedLabel = ABAddressBookCopyLocalizedLabel(label);		
		contactName = [[NSString alloc] initWithFormat:@"%@(%@)",compositeName,localizedLabel];
		CFRelease(compositeName);
		CFRelease(localizedLabel);
		CFRelease(label);
	}else{
		contactName = (NSString *)compositeName;
	}
}
#else
-(void)copyPropertyValue:(struct CPRecord*)cpRecord multiValue:(int)multiValue valueIdx:(int) valueIdx withLabel:(BOOL)withLabel{

	if(contactPropertyValue){
		[contactPropertyValue release];
		contactPropertyValue = nil;
	}
	
	contactPropertyValue = ABCMultiValueCopyValueAtIndex(multiValue,valueIdx);
	if(contactName){
		[contactName release];
		contactName = nil;
	}
	
	NSString* compositeName = (NSString*)ABCRecordCopyCompositeName(cpRecord);
	if(withLabel){
		// Append phone label if contact has 2+ phone numbers
		NSString *label = ABCMultiValueGetLabelAtIndex(multiValue,valueIdx);
		NSString *localizedLabel = ABCCopyLocalizedPropertyOrLabel(label);		
		contactName = [[NSString alloc] initWithFormat:@"%@(%@)",compositeName,localizedLabel];
		[compositeName release];
		[localizedLabel release];
	}else{
		contactName = compositeName;
	}
}
#endif

/***************************************************************
 * 
 * cpRecord - the high-level ContactPerson record object
 * propertyId - value of "property" field in table ABMultiValue
 * identifier - value of "identifier" field in table ABMultiValue
 *  
 ***************************************************************/
#ifdef __BUILD_FOR_2_0__
- (void)peoplePicker:(id)fp8 selectedPerson:(ABRecordRef)cpRecord property:(ABPropertyID)propertyId identifier:(ABMultiValueIdentifier)propertyIdentifier 
{
	// Get the propert values
	ABMultiValueRef multiValue = ABRecordCopyValue(cpRecord, propertyId);
	LOG(@"ABCRecordCopyValue(cpRecord(0x%x),propertyId(%d)) - return multiValue(0x%x)",cpRecord,propertyId,multiValue);

	// Get the property value id in the values
	CFIndex valueIdx = ABMultiValueGetIndexForIdentifier(multiValue, propertyIdentifier);
	LOG(@"ABCMultiValueIndexForIdentifier(multiValue(%d),propertyIdentifier(%d)) - return valueIdx(%d)",multiValue,propertyIdentifier,valueIdx);
	
	[self copyPropertyValue:cpRecord multiValue:multiValue valueIdx:valueIdx withLabel:YES];

	CFRelease(multiValue);
}
#else
- (void)peoplePicker:(id)fp8 selectedPerson:(struct CPRecord *)cpRecord property:(int)propertyId identifier:(int)propertyIdentifier {
	int multiValue,valueIdx;
	// Get the propert values
	multiValue=ABCRecordCopyValue(cpRecord,propertyId);
	LOG(@"ABCRecordCopyValue(cpRecord(0x%x),propertyId(%d)) - return multiValue(0x%x)",cpRecord,propertyId,multiValue);

	// Get the property value id in the values
	valueIdx=ABCMultiValueIndexForIdentifier(multiValue,propertyIdentifier);
	LOG(@"ABCMultiValueIndexForIdentifier(multiValue(%d),propertyIdentifier(%d)) - return valueIdx(%d)",multiValue,propertyIdentifier,valueIdx);
	
	[self copyPropertyValue:cpRecord multiValue:multiValue valueIdx:valueIdx withLabel:YES];
}
#endif

- (void)peoplePickerDidEndPicking:(id)iself {
	LOG(@"peoplePickerDidEndPicking - %@",iself);
	//[_peoplepicker saveState];
	[_peoplepicker restoreDefaultState];

	// Notify out that contact has been choosed
	[[NSNotificationCenter defaultCenter] postNotificationName:ISMS_NOTIFICATION_CONTACT_SELECTED object:self userInfo:nil];
	//[NSNotification notificationWithName:ISMS_NOTIFICATION_CONTACT_PICKED object:self];
	/*
	if(_delegate == nil) {
		LOG(@"ERROR: delegate is nil!");
		//TODO throw exception!!
		return;
	}
	
	if ( [_delegate respondsToSelector:@selector(contactSelected:)]) {
		LOG(@"Calling delegate.contactSelected");
		[_delegate contactSelected:nil];
	} else {
		LOG(@"WARN delegate would not respond to message @selector(contactSelected:phoneNumber:)");
	}
	*/
	//TODO send out notification ?
}

#ifdef __BUILD_FOR_2_0__
- (BOOL)peoplePicker:(id)fp8 shouldShowCardForPerson:(ABRecordRef)cpRecord 
{
	LOG(@">>> shouldShowCardForPerson %@",cpRecord);
	//Currently We're only interested on phone numbers
	ABMultiValueRef multiValue = ABRecordCopyValue(cpRecord, kABPersonPhoneProperty);
	if (ABMultiValueGetCount(multiValue) > 1) {
	   CFRelease(multiValue);
           return YES;
	}
	
	//TODO if record only have one phone, return NO
	// Copy the values
	[self copyPropertyValue:cpRecord multiValue:multiValue valueIdx:0 withLabel:NO];

	CFRelease(multiValue);

	[self peoplePickerDidEndPicking:_peoplepicker];

	return NO;
}
#else
- (BOOL)peoplePicker:(id)fp8 shouldShowCardForPerson:(struct CPRecord *)cpRecord {
	LOG(@">>> shouldShowCardForPerson %@",cpRecord);
	//Currently We're only interested on phone numbers
	int multiValue = ABCRecordCopyValue(cpRecord, 3 /*PropertyType.PHONE*/);
	if(ABCMultiValueGetCount(multiValue) > 1){
		ABCMultiValueDestroy(multiValue);
		return YES;
	}
	
	//TODO if record only have one phone, return NO
	// Copy the values
	[self copyPropertyValue:cpRecord multiValue:multiValue valueIdx:0 withLabel:NO];
	ABCMultiValueDestroy(multiValue);
	[self peoplePickerDidEndPicking:_peoplepicker];
	return NO;
}
#endif

#ifdef DEBUG
-(BOOL)respondsToSelector:(SEL)sel {
  BOOL rts = [super respondsToSelector:sel];
  LOG(@"!!! %@ respondsToSelector \"%@\" (%d)\n",[self class],NSStringFromSelector(sel), rts);
  return rts;
}
#endif

- (void)peoplePickerDisplayedGroups:(id)fp8 {
}

- (NSString *)getSelectedPropertyName{
	return contactPropertyName;
}

- (NSString *)getSelectedPropertyValue {
	return contactPropertyValue;
}

-(NSString *)getSelectedContactName {
	return contactName;
}

- (void)setDelegate:(id)delegate {
	_delegate = delegate;
}

- (void)clearAllData{
	RELEASE(contactName);
	RELEASE(contactPropertyValue);
}


-(BOOL)willShow:(NSDictionary*)param{
	[self clearAllData];
	return YES;
}
//== disassembled from AddressBook == 
//static  CFBundleRef bundle = nil;
//NSString* ___ABCCopyLocalizedPropertyOrLabel(NSString* value){
//	if(bundle == nil){
//		bundle = CFBundleGetBundleWithIdentifier((CFStringRef)@"com.apple.AddressBook");
//	}
//	return (NSString*)CFBundleCopyLocalizedString(bundle,(CFStringRef)value,(CFStringRef)value,(CFStringRef)@"Localized");
//}

@end

#import <CoreFoundation/CoreFoundation.h>

static int gPersonNameOrdering = -1;

int getPersonNameOrdering(){
  if(gPersonNameOrdering < 0){
	  Boolean success;
	  int value = CFPreferencesGetAppIntegerValue(CFSTR("personNameOrdering"),CFSTR("com.apple.PeoplePicker"),&success);
	  if(success){
		  gPersonNameOrdering = value;
	  }else{
		  gPersonNameOrdering = 0;
	  }	  
  }
  return gPersonNameOrdering;
}


@implementation ISMSContactPickerViewController

- (void)loadView {
	UIView *view = [[ContactPickerView alloc] 
						initWithFrame:[[UIScreen mainScreen] applicationFrame]
						withDelegate:self]; 
	//[view setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];  
	self.view = view;
}

- (void)viewWillAppear:(BOOL)animated{
	[self.view 	clearAllData];
}
@end