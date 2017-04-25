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
#import "UIComposeSMSView.h"

#import "Prefix.h"
#import <UIKit/UIKit.h>
#import <UIKit/UIView.h>
#import <UIKit/UITextView.h>
#import <UIKit/UITextField.h>

#import <MessageUI/ComposeRecipientView.h>
#import <MessageUI/SMSComposeRecipient.h>

#import <WebCore/WebFontCache.h>

#ifdef __BUILD_FOR_2_0__
#import <UIKit/UIAlertView.h>
#import <UIKit/UIActionSheet.h>
#import <UIKit/UIView-Geometry.h>
#import <UIKit/UIView-Hierarchy.h>
#import <UIKit/UIView-Rendering.h>
#import <UIKit/UIImage-UIImagePrivate.h>
#import <UIKit/UITextLabel.h>
#import <UIKit/UINavigationItem.h>
#import <AddressBook/ABPerson.h>
#import <AddressBook/ABRecord.h>
#import <AddressBook/ABMultiValue.h>
#import <AddressBookUI/ABPeoplePickerNavigationController.h>
//#import <AddressBookUI/ABPeoplePickerNavigationControllerDelegate-Protocol.h>
#else
#import <GraphicsServices/GraphicsServices.h>
#import <UIKit/UIAlertSheet.h>
#endif

#import "ContactPickerView.h"
#include <UIKit/UIScroller.h>

#import <UIKit/UIImage.h>
#import <UIKit/UIFieldEditor.h>
#import "SMSCenter.h"
#import "Message.h"
#import "Log.h"
#import "iSMSPreference.h"

#import "iSMSApp.h"
#import "SMSProgressView.h"
#import "UIController.h"

#import "UISMSRecipientField.h"
#import "UISMSTextView.h"
#import "UISmileyChooserView.h"
#import "UITemplateChooserView.h"
#import "UIQuickContactList.h"
#import "Contact.h"
#import "AudioHelper.h"
#import "MessageTemplate.h"

#import "AnimationHelper.h"

#import <CoreFoundation/CFPreferences.h>
#import "ISMSComposeViewController.h"

/***************************************************************
 * Class Comments
 * 
 * @Author Shawn
 ***************************************************************/
@interface ComposeRecipientView(MyHack)
-(void)setTextFieldPreferredKeyboardType:(int)type;
#ifdef __BUILD_FOR_2_0__
-(BOOL)canResignFirstResponder;
#endif
@end

@implementation ComposeRecipientView(MyHack)
-(void)setTextFieldPreferredKeyboardType:(int)type{
#ifdef __BUILD_FOR_2_0__
	[_textField setKeyboardType:type];
#else
	[_textField setPreferredKeyboardType:type];
#endif
}

#ifdef __BUILD_FOR_2_0__
-(BOOL)canResignFirstResponder
{
       return YES;
}
#endif

-(void)moveToTextView
{
	[_textField resignFirstResponder];
}

-(void)addPhoneNumber:(NSString*)value{
	int current = [[self recipients] count];
	int max = [self maxRecipients];
	if(current < max){
		[self addAddress:value];
		if(current + 1 == max){
			// We're full
			[self setEditable:NO];
		}
	}
}

-(void)recipientPickupFinished{
	_picking = NO;
}

-(void)clearRecipients{
	//[_recipients removeAllObjects];
	//	int i = [_recipients count];
	//	for(;i>0;--i){
	//		[self removeAddressAtIndex:i];
	//	}
	while([_recipients count] > 0){
		[self removeAddressAtIndex:0];
	}
}

-(UITextField*)textField{
	return _textField;
}
@end

/***************************************************************
 * The compose area, which contains the recipient bar and 
 * is scrollable when there're too many recipients selected.
 * 
 * @Author Shawn
 ***************************************************************/
@interface UIComposeArea : UIScroller{
@public	
	//UIImageView	*textBG;
	//UIScroller	*rcptAreaView;
	ComposeRecipientView	*fldRcpt2;
	UITextLabel	*lblTxtLength;
	UISMSTextView	*smsTextView;
	UIImageView	*textArea;
}
@end

@implementation UIComposeArea : UIScroller
-(void)setDelegate:(id)aDelegate{
	[fldRcpt2 setDelegate:aDelegate];
	[smsTextView setDelegate:aDelegate];
}

-(void)moveToTextView
{
NSLog(@"smsTextView: %@, ComposeRecipientView: canResign %d", [smsTextView isEditable] ? @"Editable" : @"Readonly", [fldRcpt2 canResignFirstResponder]);
// [fldRcpt2 moveToTextView];
       [smsTextView becomeFirstResponder];
}

#define MIN_TEXT_AREA_HEIGHT 34.f
#define MAX_RCPT_AREA_HEIGHT 126.f
-(void)rcptFieldSizeChanged:(struct CGSize)size{
	float newRcptAreaHeight = size.height;
	LOG(@"New Rcpt Area Height: %f",newRcptAreaHeight);

	CGRect fromFrame,toFrame;
	
	fromFrame = [fldRcpt2 frame];
	toFrame = fromFrame;
	toFrame.size.height = newRcptAreaHeight;
	[fldRcpt2 setFrame:toFrame];
	[fldRcpt2 recipientPickupFinished];
	[fldRcpt2 showAtoms];
	
	
	CGRect textAreaRect = [textArea frame];
	CGSize newComposeAreaSize = CGSizeMake(size.width,size.height + 1 + textAreaRect.size.height);
	[self setContentSize:newComposeAreaSize];
	[self displayScrollerIndicators];
	//[AnimationHelper animate:fldRcpt2 from:fromFrame to:toFrame /*withDelegate:self*/];
	
//	fromFrame = [textArea frame];
//	toFrame = fromFrame;//CGRectMake(fromFrame.origin.x,fromFrame.origin.y,fromFrame.size.width,fromFrame.size.height);
//	toFrame.origin.y = newRcptAreaHeight + 1;
//	//[AnimationHelper animate:textArea from:fromFrame to:toFrame /*withDelegate:self*/];
//	[textArea setFrame:toFrame];
		
//	[self layoutSubviews];
//	LOG(@"recipient view %@ size changed to %f,%f",fldRcpt2, size.width,size.height);
}

//- (void)animator:(UIAnimator*)animator stopAnimation:(UIAnimation*)animation {
////	struct CGRect endFrame;
////	endFrame = [animation endFrame];
////	
////	UIView* aView = [animation target];
////	if(aView){
////		[aView setFrame:frame];
////	}
//}

-(void)layoutSubviews{
//	CGRect rect = [fldRcpt2 bounds];
//	LOG(@"Layout subviews of Compose Area, current recipient area size: %f,%f",rect.size.width,rect.size.height);
	[super layoutSubviews];
	CGRect rcptRect = [fldRcpt2 frame];
	CGRect from = [textArea frame];
	CGRect to = from;
	to.origin.y = rcptRect.size.height + 1;
	//[AnimationHelper animate:textArea from:from to:to];
	[textArea setFrame:to];
}

-(void)dealloc{
	RELEASE(fldRcpt2);
	RELEASE(smsTextView);
	RELEASE(lblTxtLength);
	RELEASE(textArea);
	[super dealloc];
}

//UIComposeArea/scroller
-(id)initWithFrame:(CGRect) rect{
	[super initWithFrame:rect];
	//=================================================================
	// The compose area (0,43,320,170)
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	float c1[4] = {1.0f, 1.0f, 1.0f, 1.0f}; // WHITE
	struct CGColor *whiteColor = CGColorCreate(colorSpace, c1);
	float c2[4] = {0.86f, 0.89f, 0.93f,1};
	struct CGColor *bgColor = CGColorCreate(colorSpace, c2);

#ifdef __BUILD_FOR_2_0__
	[self setBackgroundColor:[UIColor colorWithCGColor:bgColor]];
#else
	[self setBackgroundColor:bgColor];
#endif
	[self setBottomBufferHeight:0.0f];
	[self setAllowsRubberBanding:YES];
	[self setAdjustForContentSizeChange:YES];

	//UIImage *bgImg = [UIImage applicationImageNamed:@"bg_compose_area_2.png"];
	//[self setImage:bgImg];	

	// Setup the color and font to be used later
	float transparentColorDef[4] = {0, 0, 0, 0};
	float lovelyShadeOfGreen[4] = {0,0,0,0.8};//grey
	
	// 3. sms recipient area
	CGRect _rcptAreaRect = CGRectMake(0.0f,0,320, UI_RECEIPT_FIELD_HEIGHT);
	fldRcpt2 = [[ComposeRecipientView alloc] initWithFrame:_rcptAreaRect];
	[fldRcpt2 setLabel:NSLocalizedStringFromTable(@"To",@"iSMS",@"")];
	[fldRcpt2 setEditable:YES];
	//[fldRcpt2 becomeFirstResponder];
	//[test setFont:reciptFont];
#ifdef __BUILD_FOR_2_0__
	[fldRcpt2 setProperty:kABPersonPhoneProperty];
#else
	[fldRcpt2 setProperty:(int)kABCPhoneProperty];
#endif
	[fldRcpt2 setMaxRecipients:20];
#ifdef __BUILD_FOR_2_0__
	[fldRcpt2 setTextFieldPreferredKeyboardType:UIKeyboardTypeNamePhonePad];
#else
	// My Hack
	[fldRcpt2 setTextFieldPreferredKeyboardType:4];
#endif
	[fldRcpt2 setAllowsDuplicateEntries:NO];
	[fldRcpt2 setAddresses:[NSArray array]];
	[self addSubview:fldRcpt2];
	

	// Text area(white)
	textArea = [[UIImageView alloc] initWithFrame:CGRectMake(0.f,UI_RECEIPT_FIELD_HEIGHT + 1., 320., (157. - UI_RECEIPT_FIELD_HEIGHT -1) )];
#ifdef __BUILD_FOR_2_0__
	[textArea setBackgroundColor:[UIColor colorWithCGColor:whiteColor]];
	[textArea setUserInteractionEnabled:YES]; // otherwise the subview smsTextView cannot get touch events
#else
	[textArea setBackgroundColor:whiteColor];
#endif
	UIImage *bgTxt = [UIImage applicationImageNamed:@"bg_text_area.png"];
	[textArea setImage:bgTxt];
	[self addSubview:textArea];
	
	// 4. SMS length indicator
	lblTxtLength=[[UITextLabel alloc] initWithFrame: CGRectMake(218, 77, 120.0f,35.0f)];
	[lblTxtLength setCentersHorizontally:YES];
	[lblTxtLength setText:@"0"];

	CGColorRef transparentColor = CGColorCreate( colorSpace, transparentColorDef);
#ifdef __BUILD_FOR_2_0__
	[lblTxtLength setBackgroundColor:[UIColor colorWithCGColor:transparentColor]];
#else
	[lblTxtLength setBackgroundColor:transparentColor];
#endif

	float lovelyShadeOfGrey[4]= {0,0,0,0.05f};
	CGColorRef lovelyShadeOfGreyColor = CGColorCreate( colorSpace, lovelyShadeOfGrey);

#ifdef __BUILD_FOR_2_0__
        [lblTxtLength setFont:[UIFont systemFontOfSize:36]];
        [lblTxtLength setColor:[UIColor colorWithCGColor:lovelyShadeOfGreyColor]];
#else
	struct __GSFont *countFont=[NSClassFromString(@"WebFontCache") createFontWithFamily:@"Helvetica" traits:2 size:36];
	[lblTxtLength setFont:countFont];
	[lblTxtLength setColor:lovelyShadeOfGreyColor];
#endif

	[textArea addSubview:lblTxtLength];

	// 5. text area
	//smsTextView= [[UITextView alloc] initWithFrame: CGRectMake(12.0f, UI_TOP_NAVIGATION_BAR_HEIGHT + UI_RECEIPT_FIELD_HEIGHT + 77.0f , (240.0f - 4.0f), (80.0f - 4.0f))];
	smsTextView= [[UISMSTextView alloc] initWithFrame: CGRectMake(8.0f, 6.0f/*relative to the text area*/, (320.0f - 16.0f), (126.0f - 12.0f))];
	CGColorRef lovelyShadeOfGreenColor = CGColorCreate(colorSpace, lovelyShadeOfGreen);

#ifdef __BUILD_FOR_2_0__
	[smsTextView setFont:[UIFont systemFontOfSize:18]];
	[smsTextView setBackgroundColor:[UIColor colorWithCGColor:transparentColor]];
	[smsTextView setTextColor:[UIColor colorWithCGColor:lovelyShadeOfGreenColor]];
	[smsTextView setEditable:YES];
	[smsTextView setUserInteractionEnabled:YES];
#else
	[smsTextView setTextSize:18];
	[smsTextView setBackgroundColor:transparentColor];
	[smsTextView setTextColor:lovelyShadeOfGreenColor];
#endif
	//[smsTextView setMarginTop:2];
	[smsTextView setBottomBufferHeight:0.0f];
	//[smsTextView setAllowsRubberBanding:YES];
	//[smsTextView setBackgroundColor:bgColor];
	//FIXME enable me if want to hookup the keyboard events
	//[[smsTextView textTraits] setEditingDelegate:self];
	[textArea addSubview:smsTextView];
	
	[self bringSubviewToFront:textArea];

        // Cleanup
        CGColorSpaceRelease(colorSpace);
        CGColorRelease(bgColor);
        CGColorRelease(whiteColor);
        CGColorRelease(transparentColor);
        CGColorRelease(lovelyShadeOfGreyColor);
        CGColorRelease(lovelyShadeOfGreenColor);

#ifdef __BUILD_FOR_2_0__
#else
        CFRelease(countFont);
#endif

	return self;
}

// Auto correction field will display above the text, 0 = down, 1 = up
- (int) keyboardInput:(UIFieldEditor*) editor positionForAutocorrection:(id) autoCorrection {
	return 0;
}
@end


/***************************************************************
 * SMS Compose View
 * 
 * @Author Shawn
 ***************************************************************/
#define UI_COMPOSE_AREA_HEIGHT 170.0f
extern NSString* const kABCPhoneProperty;
//extern NSString* const kABCEmailProperty;

@implementation UIComposeSMSView

-(void)_createMainView {
	defaultView = [[UIView alloc] initWithFrame:[self bounds]];
	//float c2[4] = {0.86f, 0.89f, 0.93f,1};
	float c2[4] = {1.0f, 1.0f, 1.0f, 1.0f};
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	struct CGColor *bgColor = CGColorCreate(colorSpace, c2);
#ifdef __BUILD_FOR_2_0__
	[defaultView setBackgroundColor:[UIColor colorWithCGColor:bgColor]];
#else
	[defaultView setBackgroundColor:bgColor];
#endif

        CGColorRelease(bgColor);
        CGColorSpaceRelease(colorSpace);

	/* No nav bar anymore since 2.0. NavigationController will handle this
	// 1. The top navi bar
	
//	LOG(@"UINavigationBar defaultSizeWithPrompt %f,%f",[UINavigationBar defaultSizeWithPrompt].width,[UINavigationBar defaultSizeWithPrompt].height);
//	LOG(@"UINavigationBar defaultSize %f,%f",[UINavigationBar defaultSize].width,[UINavigationBar defaultSize].height);
	navBar= [[UINavigationBar alloc] initWithFrame: CGRectMake(0.0f, 0.0f, 320.0f, UI_TOP_NAVIGATION_BAR_HEIGHT)];
	[navBar setDelegate: self];
	[navBar setBarStyle: 0];
	[navBar enableAnimation];

	[navBar showButtonsWithLeftTitle:nil rightTitle:NSLocalizedStringFromTable(@"Cancel",@"iSMS",@"") leftBack: NO];
	navTitle =[[UINavigationItem alloc] initWithTitle:NSLocalizedStringFromTable(@"New Message",@"iSMS",@"")];
	[navBar pushNavigationItem: navTitle];
	[navTitle release];
	[defaultView addSubview:navBar];
	*/	

	// 2. The compose area
	composeArea = [[UIComposeArea alloc] initWithFrame: CGRectMake(0.0f, 0.0f, 320.0f, UI_COMPOSE_AREA_HEIGHT)];
	[composeArea setDelegate:self];
	[defaultView addSubview:composeArea];

	//=================================================================
	// Add the button bar
	[defaultView addSubview:_buttonBar];
}

- (id)initWithFrame:(struct CGRect)rect{
	self=[super initWithFrame:rect];
	if (self == nil) {
		return nil;
	}
	
	// We need to re-setup the button bar later
	[_buttonBar removeFromSuperview];
	[self _createMainView];

	controller = [[UIController alloc]initWithDefaultView:defaultView];
	[UIController registerController:controller forName:@"compose"];
	
	// Create views
	[self addSubview:[controller transitionView]];
	
	[controller showView:defaultView];

	// Register event observer
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppResumed:) name:APP_RESUMED object:nil];
	recipientChanged = NO;
	return self;
}

//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// ComposeRecipientView Control Callback - Begin
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
- (void)composeRecipientViewRequestAddRecipient:(id)fp8{
	[self _chooseContactForRcpt];
}

- (void)composeRecipientView:(id)fp8 didChangeSize:(struct CGSize)size;{
	[composeArea rcptFieldSizeChanged:size];
}

- (void)composeRecipientViewDidFinishEnteringRecipient:(ComposeRecipientView*)rcptView{
	LOG(@"composeRecipientViewDidFinishEnteringRecipient - %@",rcptView);
	[rcptView addPhoneNumber:[rcptView text]];
	[rcptView showAtoms];
	[rcptView clearText];

	[self _updateSendButtonState];
	recipientChanged = YES;

	// Dump recipients 
#ifdef DEBUG
	NSArray* _recipients = [rcptView recipients];
	for(int i = 0;i < [_recipients count];i++){
		SMSComposeRecipient *rcpt = [_recipients objectAtIndex:i];
		DBG(@">>>> Recipients: %@ / %@ / %@",[rcpt address], [rcpt displayString], [rcpt uncommentedAddress]);	
	}
#endif
}

- (void)composeRecipientView:(id)fp8 textDidChange:(id)fp12{	// IMP=0x0001a460
	LOG(@"composeRecipientView %@ textDidChange:%@",fp8,fp12);
	[fp8 showAtoms];
	//[self _setQuickContactSearchString:fp12];
	[self _updateSendButtonState];
	recipientChanged = YES;
}

- (id)composeRecipientView:(id)fp8 composeRecipientForAddress:(id)fp12{ // IMP=0x0001a6f8
	SMSComposeRecipient	*rcpt = [SMSComposeRecipient recipientWithAddress:fp12];
	LOG(@"composeRecipientView %@  request SMSComposeRecipient forAddress %@, displayString is %@",fp8,fp12,[rcpt displayString]);
	//return @"Shawn";
	//return nil;
	return rcpt;
}

- (void)composeRecipientViewBeganEditing:(id)fp8{	// IMP=0x0001a754
	LOG(@"composeRecipientViewBeganEditing %@",fp8);
}

- (void)composeRecipientViewEndedEditing:(id)fp8{	// IMP=0x0001a758
	LOG(@"composeRecipientViewEndedEditing %@",fp8);
}

- (void)composeRecipientView:(id)fp8 requestDeleteRecipientAtIndex:(int)fp12{	// IMP=0x0001a534
	[fp8 removeAddressAtIndex:fp12];
	[fp8 showAtoms];
	[self _updateSendButtonState];
	//TODO notify the delegate "smsRecipientSelectionViewEmpty";
}

//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// ComposeRecipientView Control Callback - Finish
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

void UIKeyboardDisableAutomaticAppearance();
void UIKeyboardEnableAutomaticAppearance();

void UIKeyboardOrderInAutomatic();
void UIKeyboardOrderOutAutomatic();

//==== Contact List ====
-(void)showContactList {
	//[[[[UIApplication sharedApplication] keyWindow] firstResponder] resignFirstResponder];
	[composeArea->smsTextView becomeFirstResponder];
	//[composeArea->smsTextView resignFirstResponder];
	if(contactPickerViewController == nil) {
		contactPickerViewController = [[ISMSContactPickerViewController alloc] initWithNibName:nil bundle:nil];
	}
	
	//FIXME Register for the contact selected notification
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onContactSelected:) name:ISMS_NOTIFICATION_CONTACT_SELECTED object:nil];
	
	// The overlay effect
	[[[ISMSComposeViewController sharedInstance]navigationController] presentModalViewController:contactPickerViewController animated:YES];
	//[[[ISMSComposeViewController sharedInstance]navigationController] presentModalViewController:contactPickerViewController withTransition:6];
	//[[ISMSComposeViewController sharedInstance] presentModalViewController:contactPickerViewController animated:YES];
	//[controller switchToView:contactListView from:[controller maskView] withStyle:3];
}

/*
#ifdef __BUILD_FOR_2_0__

// ABPeoplePickerNavigationControllerDelegate methods

// When canceled...
-(void) peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)picker
{
        // Just dismiss the view
        [picker dismissModalViewControllerAnimated:YES];
}

// When one person selected...
-(BOOL) peoplePickerNavigationController:(ABPeoplePickerNavigationController *)picker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
        // Got person information 
	NSString* selectedName = (NSString *)ABRecordCopyCompositeName(person);
	NSString* selectedPhone = (NSString *)ABRecordCopyValue(person, kABPersonPhoneProperty);

	if (textAreaIsFocused) {
  	   [self appendContactInfoToSMSText:selectedName value:selectedPhone];
	} else {
	   [composeArea->fldRcpt2 addPhoneNumber:selectedPhone];
	   [composeArea->fldRcpt2 showAtoms];
	   [self _updateSendButtonState];
	}

	[composeArea->fldRcpt2 recipientPickupFinished];
        
        // Release them
        [selectedName release];
        [selectedPhone release];

        // Dismiss
        [picker dismissModalViewControllerAnimated:YES];

        return NO;
}

// When one person's property selected, never called in our scenario
-(BOOL) peoplePickerNavigationController:(ABPeoplePickerNavigationController *)picker 
      shouldContinueAfterSelectingPerson:(ABRecordRef)person 
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
        return NO;
}

#else */
/*
-(void)hideContactList {
	[[[ISMSComposeViewController sharedInstance] navigationController] dismissModalViewControllerAnimated:YES];
	//[controller switchBackFrom:contactListView];
}
*/

-(void)onContactSelected:(NSNotification*)aNotify{

	/*
	if([aNotify object] != contactPickerViewController){
		// Not from the desired contact picker. Ghost!!!
		return;
	}
	*/
	
	// Unregister the notification observer
	[[NSNotificationCenter defaultCenter] removeObserver:self name:ISMS_NOTIFICATION_CONTACT_SELECTED object:nil];
	
	// Check selected value
	NSString* selectedName = [contactPickerViewController.view getSelectedContactName];
	NSString* selectedPhone = [contactPickerViewController.view getSelectedPropertyValue];
	if(selectedName && selectedPhone){
		LOG(@">>> contactSelected - Name %@, Number %@",selectedName,selectedPhone);
		if(pickingContactForSending) {
			[self appendContactInfoToSMSText:selectedName value:selectedPhone];
		} else {
			//[fldRcpt addRecipient:selectedName withNumber:selectedPhone];
			[composeArea->fldRcpt2 addPhoneNumber:selectedPhone];
			[composeArea->fldRcpt2 showAtoms];
			[self _updateSendButtonState];
		}		
	}else{
		LOG(@"Contact select canceled!");
	}
	// Important!
	[composeArea->fldRcpt2 recipientPickupFinished];
	
	
	//Dismiss the contact pick view
	//[[[ISMSComposeViewController sharedInstance] navigationController] dismissModalViewControllerAnimated:YES];
	[contactPickerViewController dismissModalViewControllerAnimated:YES];
}
// #endif

//==== Button bar ====
-(void)_chooseContactForRcpt {
	[composeArea->fldRcpt2 becomeFirstResponder];
	pickingContactForSending = NO;
	[self showContactList];
}

-(void)_chooseContactForSMS {
	pickingContactForSending = YES;
	[self showContactList];
}

-(void)chooseSmiley {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_smileyChoosed:) name:SMILEY_CHOOSED object:nil];
	// Show the smiley view
	if(smileyChooserViewController == nil) {
		smileyChooserViewController = [[ISMSSmileyChooserViewController alloc] initWithNibName:@"SmileyChooserView" bundle:nil];
	}
	[[[ISMSComposeViewController sharedInstance] navigationController] presentModalViewController:smileyChooserViewController animated:YES];
}

-(void)_smileyChoosed:(NSNotification*) notify {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:SMILEY_CHOOSED object:nil];
	NSString* value = (NSString*)[notify userInfo];
	if(value){
		[self insertSMSText:value];	
	}
	// Hide the view
	[smileyChooserViewController dismissModalViewControllerAnimated:YES];
	//[smileyChooserView setShow:NO];
}

-(void)chooseTemplate {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(templateChoosed:) name:TEMPLATE_CHOOSED object:nil];
	// Show the template chooser view
	if(templateChooserViewController == nil){
		templateChooserViewController = [[ISMSTemplateChooserViewController alloc]initWithNibName:nil bundle:nil];
	}
	[[[ISMSComposeViewController sharedInstance] navigationController] presentModalViewController:templateChooserViewController animated:YES];
	/*
	if(templateChooserView == nil) {
		templateChooserView = [[UITemplateChooserView alloc] initWithFrame:[self frame]];
		[templateChooserView setParentView:self];
	}
	[controller switchToView:templateChooserView from:[controller maskView] withStyle:3];
	*/
}

-(void)templateChoosed :(NSNotification*) notify{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:TEMPLATE_CHOOSED object:nil];
	NSString* value = (NSString*)[notify userInfo];
	[self insertSMSText:value];
	[templateChooserViewController dismissModalViewControllerAnimated:YES];
	//[controller switchBackFrom:templateChooserView];
}

//==== Quick Contact List View ====
-(void)showQuickContactList{
	if(quickContactList && ![quickContactList visible]){
		// Should disable the contact choose
		//[btnChooseRcpt setEnabled:NO];
		[defaultView addSubview:quickContactList];
		[quickContactList setVisible:YES];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onQuickContactSelected:) name:@"UIQuickContactList" object:nil];
	}
}

-(void)hideQuickContactList{
	if(quickContactList && [quickContactList visible]){
		[[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIQuickContactList" object:nil];
		[quickContactList setVisible:NO];
		[quickContactList clearAllData];
		//[btnChooseRcpt setEnabled:YES];
	}
}

//FIXME set the max recipient limit !!!
-(void)onQuickContactSelected:(NSNotification*)aNotify{
	// What if user tapped twice ??
	NSArray* selected = [quickContactList selectedContacts];
	if(selected && [selected count] > 0){
		// We need to remove the "search text"
		// and retain the result first otherwise the result may be released
		[selected retain];
		//[fldRcpt setText:@""];
		for(int i = 0;i < [selected count];i++){
			//Contact* contact = [selected objectAtIndex:i];
			//[fldRcpt addRecipient:[contact compositeName] withNumber:[contact phoneNumber] shouldNotifyChange:NO];
			NSDictionary* data = [selected objectAtIndex:i];
			//NSString* display = [NSString stringWithFormat:@"%@(%@)",[data objectForKey:@"compositeName"],[data objectForKey:@"label"]];
			NSString* number = [data objectForKey:@"value"];
			//[fldRcpt addRecipient:display withNumber:number shouldNotifyChange:NO];
			[composeArea->fldRcpt2 addPhoneNumber:number];
		}
		[selected release];
		[composeArea->fldRcpt2 becomeFirstResponder];
		[composeArea->fldRcpt2 clearText];
		[composeArea->fldRcpt2 recipientPickupFinished];
		[composeArea->fldRcpt2 showAtoms];
	}
	[self hideQuickContactList];
}

-(void)_setQuickContactSearchString:(NSString*) search{
	if(quickContactList == nil){
		CGRect rect = [composeArea frame];
		//0.0f, UI_TOP_NAVIGATION_BAR_HEIGHT, 320.0f, 201.0f
		rect.origin.y+=UI_RECEIPT_FIELD_HEIGHT;
		rect.size.height = rect.size.height - UI_RECEIPT_FIELD_HEIGHT ; // button bar height
		quickContactList = [[UIQuickContactList alloc] initWithFrame:rect];
	}
	if(search && [search length] > 0 /*&& ![UIComposeSMSView _isValidPhoneNumber:search]*/){
		// Try to search and show the result if have
		[quickContactList setSearchString:search];
		if([quickContactList hasResults]){
			[self showQuickContactList];
			return;
		}
	}
	[self hideQuickContactList];
}


//==== SMS Text  ====
-(void)insertSMSText:(NSString*)text{
	if(text == nil || [text length] == 0){
		return;
	}
	// If nothing there previously, just set as text
	NSString* oldText = [composeArea->smsTextView text];
	int len = [oldText length];
	if(oldText == nil || len == 0){
		[composeArea->smsTextView setText:text];
		return;
	}

	// Check the position
	NSString *newText = nil;
#ifdef __BUILD_FOR_2_0__
	NSRange range = [composeArea->smsTextView selectedRange];
#else
	NSRange range = [composeArea->smsTextView selectionRange];
#endif
	int location = range.location;
	if(location >= len){
		// Append to the end
		newText = [NSString stringWithFormat:@"%@%@",oldText,text];
	}else if(location == 0){
		newText = [NSString stringWithFormat:@"%@%@",text,oldText];
	}else{
		NSString* part1 = [oldText substringToIndex:location];
		NSString* part2 = [oldText substringFromIndex:location];
		newText = [NSString stringWithFormat:@"%@%@%@",part1,text,part2];
	}
	[composeArea->smsTextView becomeFirstResponder];
	[composeArea->smsTextView setText:newText];
	range.location += [text length];
	range.length = 0;
#ifdef __BUILD_FOR_2_0__
	[composeArea->smsTextView setSelectedRange:range];
#else
	[composeArea->smsTextView setSelectionRange:range];
#endif
	
	[self _smsTextChanged];
}

-(void)setTitle:(NSString*)title {
	[(ISMSComposeViewController*)[ISMSComposeViewController sharedInstance] setTitle:title];
}

+(BOOL)_isValidPhoneNumber:(NSString*) number {
	if(number == nil || [number length] == 0) {
		return NO;
	}

	for(int i = 0;i<[number length];i++) {
		unichar aChar = [number characterAtIndex:i];
		if ((aChar >= '0' && aChar <= '9') || aChar == '+' || aChar == ' ' || aChar == '(' || aChar ==')' || aChar=='-') {
			// Yep it's a valid number
			continue;
		} else {
			LOG(@"%@ is not a valid number, %c",number,aChar);
			return NO;
		}
	}

	return YES;
}

//-(BOOL)_canSend{
//	
//}

-(void)sendSMS {
//	if([composeArea->fldRcpt2 isFirstResponder]){
//		[composeArea->fldRcpt2 resignFirstResponder];
//		[composeArea->smsTextView becomeFirstResponder];
////		textAreaIsFocused = YES;
//	}
	//[composeArea->smsTextView becomeFirstResponder];
	//[composeArea->fldRcpt2 resignFirstResponder];
	
//	[composeArea->smsTextView resignFirstResponder];
	
	NSArray *rcptList = [composeArea->fldRcpt2 recipients];
	BOOL _argOK = NO;
	NSString* _smsText =  [composeArea->smsTextView text];
	if(rcptList && [rcptList count] > 0) {
		//_smsText = [composeArea->smsTextView text];
		if(_smsText != nil && [_smsText length]> 0) {
			_argOK = YES;
		}
	}

	if(!_argOK) {
		[composeArea->fldRcpt2 becomeFirstResponder];

		//NSString *emptyMess=[NSString stringWithUTF8String:"\xe5\x8f\xb7\xe7\xa0\x81\xe6\x88\x96\xe5\x86\x85\xe5\xae\xb9\xe7\xa9\xba"];
		NSString *errorMsg = nil;
		/*if(_numberString == nil){
			errorMsg = NSLocalizedStringFromTable(@"Please check recipient's name",@"iSMS",@"");
		}else 
		*/	
		if(_smsText == nil){
			errorMsg = NSLocalizedStringFromTable(@"Message is empty",@"iSMS",@"");
		}else{
			errorMsg = NSLocalizedStringFromTable(@"Please check your recipient and message content!",@"iSMS",@"");
		}
		
		UIAlertView * alertSheetEmpty = [[UIAlertView alloc] initWithTitle:@""
																   message:errorMsg
																  delegate:self
														 cancelButtonTitle:nil
														 otherButtonTitles:nil]; 
		[alertSheetEmpty addButtonWithTitle:NSLocalizedStringFromTable(@"OK",@"iSMS",@"")];
		[alertSheetEmpty show];
		return;
	}
	
	// Hide the keyboard
	[composeArea->fldRcpt2 resignFirstResponder];
	[composeArea->smsTextView resignFirstResponder];

	//The progress view will fire up the send task
	if(progressViewController == nil) {
		progressViewController = [[ISMSProgressViewController alloc]initWithNibName:nil bundle:nil];
		//		LOG(@"WARNING - previous sent task is not completed yet ??");
		//		return;
	}
	
	// Register listener for sms sending notification
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_messageSent:) name:PROGRESS_FINISHED_NOTIFICATION object:nil];
	
	// Call the smsSendController to send the message out
	DBG(@"Will send message %@ to %@",_smsText,rcptList);
	[[SMSCenter getInstance] setSendTask:_smsText to:rcptList statusCallback:(SMSSendStatusCallback*)progressViewController.view];

	
	[[[ISMSComposeViewController sharedInstance]navigationController] presentModalViewController:progressViewController animated:NO];
	//[[[ISMSComposeViewController sharedInstance]navigationController] presentModalViewController:progressViewController withTransition:6];
	//[progressView showFrom:self]; //[smsSendController send]; will be called in progress view when the animation is done.
	//[progressView setMessage:_smsText recipients:rcptList];
	//[[SMSCenter getInstance] sendMessageEx:_smsText to:rcptList];
	return;
}

// Will be called when message send task is finished
- (void) _messageSent:(NSNotification *) notification {
	//unregister the progress notification listener.
	[[NSNotificationCenter defaultCenter] removeObserver:self name:PROGRESS_FINISHED_NOTIFICATION object:nil];
	
	//dismiss the progress view
	[[[ISMSComposeViewController sharedInstance]navigationController] dismissModalViewControllerAnimated:NO];

	// Notify message update
	// FIXME duplicated with the conversation view!!!
	id _notifyType = [NSNumber numberWithInt:MESSAGE_CHANGED];
	NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
			_notifyType,@"type",
			nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_CHANGE_NOTIFICATION object:self userInfo:userInfo];

	// Check the notification data
	id data = [notification userInfo];
	NSArray* failedList = [[data objectForKey:@"unsent"] retain];
	BOOL success = (failedList == nil) || ([failedList count] == 0);
	
	if(success) {
		LOG(@"All message is sent successfully!");
		// We can remove the draft message now
		// All failed message has already been saved
		if(message != nil){
			[message delete];
			RELEASE(message);
		}
		// Sent success, play sound if necessary and switch back to the previous UI
		playMessageSentSound();
		
		//Important! clean up and switch back
		[self clearAllData];
		//[self _exitComposeView];
		[composeArea->fldRcpt2 becomeFirstResponder];
	} else {
		//TODO enumerate the failed rcpt list
		if(sendFailedAlert == nil){
#ifdef __BUILD_FOR_2_0__
                  sendFailedAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
                  [sendFailedAlert addButtonWithTitle:NSLocalizedStringFromTable(@"OK",@"iSMS",@"")];
#else
			sendFailedAlert = [[UIAlertSheet alloc] initWithFrame:CGRectMake(0,240,320,240)];
			[sendFailedAlert addButtonWithTitle:NSLocalizedStringFromTable(@"OK",@"iSMS",@"")];
			[sendFailedAlert setDelegate: self];
#endif
		}
		NSMutableString *failedNameList = [[NSMutableString alloc]init];
		for(int i = 0;i < [failedList count];i++){
			SMSComposeRecipient *rcpt = [failedList objectAtIndex:i];
			if(i == 0){
				[failedNameList appendString:[rcpt displayString]];	
			}else{
				[failedNameList appendString:@","];	
				[failedNameList appendString:[rcpt displayString]];	
			}
		}
		//NSString *badMess=NSLocalizedStringFromTable(@"Failed to send message to following recipients\n%@\n\n All unsent messages are saved in DRAFT folder.",@"iSMS",@"");
		NSString *badMess=[NSString stringWithFormat:@"Failed to send message to following recipients\n%@\n\n All unsent messages are saved in DRAFT folder.",failedNameList];

#ifdef __BUILD_FOR_2_0__
                [sendFailedAlert setMessage:badMess];
                [sendFailedAlert show];
#else
		[sendFailedAlert setBodyText:badMess];
		[sendFailedAlert popupAlertAnimated:YES];
#endif
		//Note we'll switch back in the alertSheet callback
	}
	
	[failedList release];
}

-(void)_updateSendButtonState {
	//BOOL enabled = ([[smsTextView text] length]> 0 ) && ([[fldRcpt text] length]> 0 );
	BOOL _hasRcpts = ([[composeArea->fldRcpt2 recipients] count]> 0 ) || ([[composeArea->fldRcpt2 text] length] > 0);
	BOOL _hasText = [[composeArea->smsTextView text] length]> 0;
	LOG(@"_updateSendButtonState - hasRcpts:%d, hasText:%d",_hasRcpts,_hasText);
	BOOL enabled = _hasRcpts && _hasText;
	[self setButtonEnabled:5 enabled:enabled];
}

-(int)_calculateSMSTextCount {
	int textLen = 0;
	if(composeArea->smsTextView && ([composeArea->smsTextView text])) {
		textLen = [[composeArea->smsTextView text] length];
	}
	[composeArea->lblTxtLength setText:[NSString stringWithFormat:@"%d",textLen]];
	return textLen;
}

//-(BOOL)_isAscii:(unichar)aChar {
//	return (aChar >= 'a' && aChar <= 'z')
//	|| (aChar >= 'A' && aChar <= 'Z')
//	|| (aChar >= '0' && aChar <= '9')
//	|| (aChar == ' ');
//}

//-(BOOL)keyboardInput:(id)k shouldInsertText:(id)i isMarkedText:(int)b {
//	return TRUE;
//}

-(void)_smsTextChanged {
	[self _updateSendButtonState];
	[self _calculateSMSTextCount];
}

// User modifying the recipient list  
- (void)_recipientFieldChanged {
//	//popup the quick contact list when user typing
//	if([[fldRcpt recipients] count] == 0){
//		// Popup the quick contact list
//		[self _setQuickContactSearchString:[fldRcpt text]];
//	}
//	[self _updateSendButtonState];
	
}

-(void)_focusChanged:(id) control {
	/*
	if(control == composeArea->smsTextView) {
		textAreaIsFocused = YES;
	} else {
		textAreaIsFocused = NO;
	}
	*/
}

-(void) onAppResumed:(NSNotification*)aNotify{
	NSLog(@"Application resumed, refreshing view. FirstResponder is %@", [[[UIApplication sharedApplication] keyWindow]firstResponder]);
#ifdef __BUILD_FOR_2_0__
#else
	if(keyboard){
		[keyboard setNeedsDisplay];
		[keyboard activate];
	}
#endif
	
//	if(fldRcpt){
//		[fldRcpt setNeedsDisplay];
//		[fldRcpt becomeFirstResponder];
//	}
	if(composeArea->fldRcpt2){
		[composeArea->fldRcpt2 setNeedsDisplay];
		[composeArea->fldRcpt2 becomeFirstResponder];
	}
}

-(void)setInitialText:(NSString*) iText {
	if(composeArea->smsTextView && iText) {
		[composeArea->smsTextView setText:iText];
		[self _smsTextChanged];
		[composeArea->smsTextView becomeFirstResponder];
	}
}

// Set up draft message
-(void)setMessage:(Message*)msg{
	if(![msg isDraft]){
		LOG(@"WARN - Not a draft message!");
		return;
	}
	RETAIN(message,msg);
	NSString* phoneNumber = [message phoneNumber];
	if(phoneNumber && [phoneNumber length] > 0){
		NSArray* _addrs = [phoneNumber componentsSeparatedByString:@","];
		for(int i = 0;i<[_addrs count];i++){
			NSString* _addr = [_addrs objectAtIndex:i];
			if(_addr && [_addr length] > 0){
				[composeArea->fldRcpt2 addPhoneNumber:_addr];	
			}
		}
		//[fldRcpt2 showAtoms];
		//[fldRcpt2 resignFirstResponder];
	}
	[self setInitialText:[message body]];
}

/**
 * Append the contact number into the end of the sms text
 */
-(void)appendContactInfoToSMSText:(NSString*) aName value:(NSString*) aValue {
	NSString *value = [NSString stringWithFormat:@"%@(%@)",aName, aValue];
	[self insertSMSText:value];
	//TODO Move the cursor to last text field
	
}

-(void)addRecipient:(NSString*) name withNumber:(NSString*) number {
	LOG(@"Will add recipient %@ with number:%@",name,number);
	[composeArea->fldRcpt2 addPhoneNumber:number];
}

-(void)clearAllData {
	recipientChanged = NO;
	[composeArea->smsTextView setText:@""];
	[composeArea->fldRcpt2 clearRecipients];
	[composeArea->lblTxtLength setText:@""];
	[self setTitle:NSLocalizedStringFromTable(@"New Message",@"iSMS",@"")];
	RELEASE(message);
}

- (void)setDelegate:(id)aDelegate
{
	delegate = aDelegate;
}

-(BOOL)_needSave{
	return recipientChanged 
	||	(message == nil && [[composeArea->smsTextView text] length ] > 0) 
	|| 	(message != nil && [[message body]length] != [[composeArea->smsTextView text] length])
	|| 	(message != nil && ![[message body] isEqualToString:[composeArea->smsTextView text]])
	; 
}

-(void)_saveAsTemplate{
	[[MessageTemplate sharedInstance] addTemplate:[composeArea->smsTextView text]];
}

-(void)_saveAsDraft{
	// Save draft
	Message *newDraftMsg = [Message newDraftMessage];
//	if(message == nil){
//		message = [[Message alloc] init];
//	}
	// Build the phone number string
	NSArray* _rcpts = [composeArea->fldRcpt2 recipients];//[[fldRcpt2 text] componentsSeparatedByString:@","];
	NSMutableString* _rcptStr = [[NSMutableString alloc]init];
	for(int i = 0;i < [_rcpts count];i++){
		SMSComposeRecipient *_rcpt = [_rcpts objectAtIndex:i];
		if(i >0){
			[_rcptStr appendString:@","];
		}
		[_rcptStr appendString:[_rcpt uncommentedAddress]];
	}
	[newDraftMsg setPhoneNumber:_rcptStr];
	[newDraftMsg setBody:[composeArea->smsTextView text]];
	//[message setType:DRAFT_MESSAGE];
	[newDraftMsg save];
	
	RETAIN(message,newDraftMsg);
	//[_rcptStr release];
}

//-(void)alertSheet:(UIAlertSheet*)sheet buttonClicked:(int)button {
//	LOG(@"Sheet %@ - Button %d is clicked",sheet,button);
//	[sheet dismiss];
//}


// RESULT: 
-(BOOL)willHide:(NSDictionary*) param {
//	
//	if([self _needSave]) {
//		LOG(@">>> Popup save as dialog");
//		NSArray *buttons = [NSArray arrayWithObjects:
//			NSLocalizedStringFromTable(@"Save",@"iSMS",@""), 
//			NSLocalizedStringFromTable(@"Save As Template",@"iSMS",@""),
//			NSLocalizedStringFromTable(@"Don't Save",@"iSMS",@""),
//			NSLocalizedStringFromTable(@"Cancel",@"iSMS",@""),
//			nil];
//		//UIModalAlertSheet *alertSheet = [[UIModalAlertSheet alloc] initWithTitle:@"" buttons:buttons defaultButtonIndex:3 delegate:nil context:nil];
//		UIModalAlertSheet *alertSheet = [[UIModalAlertSheet alloc] initWithTitle:@"" buttons:buttons defaultButtonIndex:3];
//		[alertSheet setBodyText:NSLocalizedStringFromTable(@"UNSAVED_MESSAGE_CONFIRMATION",@"iSMS",@"")];
//		//[alertSheet setDestructiveButton:[[alertSheet buttons] objectAtIndex:0]];
//		// we want it block the main thread
//		[alertSheet setRunsModal:YES];
//		[alertSheet setBlocksInteraction:YES];
//		[alertSheet presentSheetFromAboveView:self];
//		NSLog(@"!!! presentSheetFromAboveView() done!");
//		int result = [alertSheet result];
//		LOG(@"!!! button %d clicked",result);
//		[alertSheet autorelease];
//		
//		switch(result){
//		case 1:
//		{
//			[self _saveAsDraft];
//			break;
//		}
//		case 2:
//			[self _saveAsTemplate];
//			break;
//		case 3:
//			// Don't save, so just quit
//			break;
//		case 4:
//			// Cancel, keep this UI
//			return NO;
//		}
//	}

	return YES;
}

-(BOOL)willShow:(NSDictionary*) param{
//-(void)didShow:(NSDictionary*)param {
DBG(@"didShow. firstResponder is %@", [[[UIApplication sharedApplication] keyWindow] firstResponder]);

	//[fldRcpt setNeedsDisplay];
	if([[composeArea->fldRcpt2 recipients] count] == 0 &&  [[composeArea->fldRcpt2 text] length] == 0){
		[composeArea->smsTextView resignFirstResponder];
//		[composeArea->smsTextView setEditable:NO];
//		[composeArea->fldRcpt2 setEditable:YES];
		[composeArea->fldRcpt2 becomeFirstResponder];
		//textAreaIsFocused = NO;
	}else{
		[composeArea->fldRcpt2 resignFirstResponder];
//		[composeArea->fldRcpt2 setEditable:NO];
//		[composeArea->smsTextView setEditable:YES];
		[composeArea->smsTextView becomeFirstResponder];
		//textAreaIsFocused = YES;
	}

//	
//	if([composeArea->smsTextView text] != nil && [[composeArea->smsTextView text]length] > 0){
//		[composeArea->smsTextView resignFirstResponder];
//		[composeArea->fldRcpt2 becomeFirstResponder];
//		textAreaIsFocused = NO;
//	}else{
//		[composeArea->fldRcpt2 resignFirstResponder];
//		[composeArea->smsTextView becomeFirstResponder];
//		textAreaIsFocused = YES;
//	}
	return YES;
}

-(void)didHide:(NSDictionary*)param {
	[self clearAllData];
	[self hideQuickContactList];
}

-(void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	//RELEASE(navTitle);
	//RELEASE(navBar);
	//RELEASE(keyboard);
	//RELEASE(btnChooseRcpt);

	RELEASE(defaultView);
	//RELEASE(contactListView);
	//RELEASE(transitionView);
	RELEASE(contactPickerViewController);
	RELEASE(controller);
	RELEASE(composeArea);

	RELEASE(progressViewController);
	RELEASE(smileyChooserViewController);
	RELEASE(templateChooserViewController);

	RELEASE(message);
	
	RELEASE(saveAlert);
	RELEASE(sendAlert);
	RELEASE(sendFailedAlert);
	[super dealloc];
}

//==== Other Callbacks ====
-(void)_exitComposeView{
	[[[[UIApplication sharedApplication] keyWindow] firstResponder] resignFirstResponder];
	[[UIController defaultController] switchBackFrom:self];
}

-(void)onCancel{
	// Cancel
	//
	if([self _needSave]) {
		LOG(@">>> Popup save as dialog");
		if(saveAlert == nil){
			NSArray *buttons = [NSArray arrayWithObjects:
								NSLocalizedStringFromTable(@"Save",@"iSMS",@""), 
								NSLocalizedStringFromTable(@"Save As Template",@"iSMS",@""),
								NSLocalizedStringFromTable(@"Don't Save",@"iSMS",@""),
								NSLocalizedStringFromTable(@"Cancel",@"iSMS",@""),
								nil];
#ifdef __BUILD_FOR_2_0__
			saveAlert = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:nil
									  destructiveButtonTitle:nil otherButtonTitles:nil];
			
			[saveAlert addButtonWithTitle:[buttons objectAtIndex:0]];
			[saveAlert addButtonWithTitle:[buttons objectAtIndex:1]]; 
			[saveAlert addButtonWithTitle:[buttons objectAtIndex:2]];
			[saveAlert addButtonWithTitle:[buttons objectAtIndex:3]];
			[saveAlert setCancelButtonIndex:3];
			
			[saveAlert setMessage:NSLocalizedStringFromTable(@"UNSAVED_MESSAGE_CONFIRMATION",@"iSMS",@"")];
#else
			saveAlert = [[UIAlertSheet alloc] initWithTitle:@"" buttons:buttons defaultButtonIndex:3 delegate:self context:nil];
			//UIAlertSheet *alertSheet = [[UIModalAlertSheet alloc] initWithTitle:@"" buttons:buttons defaultButtonIndex:3];
			[saveAlert setBodyText:NSLocalizedStringFromTable(@"UNSAVED_MESSAGE_CONFIRMATION",@"iSMS",@"")];
#endif
		}
#ifdef __BUILD_FOR_2_0__
		[saveAlert showInView:self];
#else
		[saveAlert presentSheetFromAboveView:self];
#endif
		DBG(@"!!! presentSheetFromAboveView() done!");
	}else{
		// Directly quit
		[self _exitComposeView];
	}
}

/*
- (void)navigationBar:(UINavigationBar *)navbar buttonClicked:(int)button
{
	switch (button)
	{
		case 1://left
		{

		}
		case 0://Right
		{
			[self onCancel];
		}

	}
}
*/

-(void) _handleButtonsInAlert:(id)sheet buttonIndex:(int)button
{
	if(sheet == saveAlert){
		switch(button){
		case 0:
		{
			DBG(@"Save as draft");
			[self _saveAsDraft];
			break;
		}
		case 1:
			DBG(@"Save as template");
			[self _saveAsTemplate];
			break;
		case 2:
			DBG(@"Don't save");
			// Don't save, so just quit
			break;
		case 3:
			DBG(@"Canceled");
			// Cancel, keep this UI
			return ;
		}
		[self _exitComposeView];
	}else if(sheet == sendAlert){
		switch(button){
			case 0:{
				[self sendSMS];
				break;
			}
		}
	}else if(sheet == sendFailedAlert){
		// Hide me
		//Important! clean up and switch back
		[self clearAllData];
		[self _exitComposeView];
	}
}

#ifdef __BUILD_FOR_2_0__
-(void)alertView:(UIAlertView *)view clickedButtonAtIndex:(NSInteger)buttonIndex
{
       [view dismissWithClickedButtonIndex:buttonIndex animated:YES];
       [self _handleButtonsInAlert:view buttonIndex:buttonIndex];
}

-(void)actionSheet:(UIActionSheet *)sheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
       [sheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
       [self _handleButtonsInAlert:sheet buttonIndex:buttonIndex];
}
#else
-(void)alertSheet:(UIAlertSheet*)sheet buttonClicked:(int)button {
	[sheet dismiss];
	[self _handleButtonsInAlert:sheet buttonIndex:button];
}
#endif


//------------
// Button bar
//------------
-(CGRect)makeButtonBarRect {
	return CGRectMake(0.0f, UI_COMPOSE_AREA_HEIGHT, 320.0f, 31.0f);
}

// We need to customize the button bar style
#ifdef __BUILD_FOR_2_0__
-(UIToolbar *)createButtonBar
{
#else
- (UIButtonBar *)createButtonBar {
#endif
	// Create the button bar with default style
	return [self createButtonBarSetDelegate:self setBarStyle:2 setButtonBarTrackingMode:1 showSelectionForButton:-1];
}

- (void)_setButtonFrame:(UIView*)btnView btnTag:(int)tag {
	[btnView setFrame:CGRectMake(2.0f + ((tag - 1) * 62.0f), 5.0f, 62.0f, 31.0f)];
	//	
	//	if(tag == 1){
	//		[btnView setFrame:CGRectMake(2.0f, 0.0f - 5.0f, FOUR_VIEW_BTN_WIDTH, UI_BOTTOM_BUTTON_BAR_HEIGHT + 10.0f)];
	//	}else if(tag == 2){
	//		[btnView setFrame:CGRectMake(2.0f + FOUR_VIEW_BTN_WIDTH + 1.0f, 0.0f - 5.0f, FOUR_VIEW_BTN_WIDTH, UI_BOTTOM_BUTTON_BAR_HEIGHT + 10.0f)];
	//	}else if(tag == 3){
	//		[btnView setFrame:CGRectMake((320.0f - FOUR_VIEW_BTN_WIDTH - 2.0f - FOUR_VIEW_BTN_WIDTH - 1.0f),0.0f - 5.0f,FOUR_VIEW_BTN_WIDTH,UI_BOTTOM_BUTTON_BAR_HEIGHT + 10.0f)];
	//	}else if(tag == 4){
	//		[btnView setFrame:CGRectMake((320.0f - FOUR_VIEW_BTN_WIDTH - 2.0f),0.0f - 5.0f,FOUR_VIEW_BTN_WIDTH,UI_BOTTOM_BUTTON_BAR_HEIGHT + 10.0f)];
	//	}else if(tag == 5){
	//		
	//	}
}

- (NSArray *)buttonBarItems {
	return [ NSArray arrayWithObjects:
	// 1 - Reply button
	[ NSDictionary dictionaryWithObjectsAndKeys:
	@"buttonBarItemTapped:", kUIButtonBarButtonAction,
	@"button_smileys.png", kUIButtonBarButtonInfo,
	@"button_smileys.png", kUIButtonBarButtonSelectedInfo,
	//[ NSNumber numberWithFloat: 5], kUIButtonBarButtonInfoOffset,
	[ NSNumber numberWithInt: 1], kUIButtonBarButtonTag,
	self, kUIButtonBarButtonTarget,
	NSLocalizedStringFromTable(@"Smiley",@"iSMS",@""), kUIButtonBarButtonTitle,
	@"0", kUIButtonBarButtonType,
	nil
	],

	// 2 - Forward button
	[ NSDictionary dictionaryWithObjectsAndKeys:
	@"buttonBarItemTapped:", kUIButtonBarButtonAction,
	@"button_contacts.png", kUIButtonBarButtonInfo,
	@"button_contacts.png", kUIButtonBarButtonSelectedInfo,
	//[ NSNumber numberWithFloat: 5], kUIButtonBarButtonInfoOffset,
	[ NSNumber numberWithInt: 2], kUIButtonBarButtonTag,
	self, kUIButtonBarButtonTarget,
	NSLocalizedStringFromTable(@"Contact",@"iSMS",@""), kUIButtonBarButtonTitle,
	@"0", kUIButtonBarButtonType,
	nil
	],

	// 3 - Delete button
	[ NSDictionary dictionaryWithObjectsAndKeys:
	@"buttonBarItemTapped:", kUIButtonBarButtonAction,
	@"button_templates.png", kUIButtonBarButtonInfo,
	@"button_templates.png", kUIButtonBarButtonSelectedInfo,
	//[ NSNumber numberWithFloat: 5],kUIButtonBarButtonInfoOffset,
	[ NSNumber numberWithInt: 3], kUIButtonBarButtonTag,
	self, kUIButtonBarButtonTarget,
	NSLocalizedStringFromTable(@"Template",@"iSMS",@""), kUIButtonBarButtonTitle,
	@"0", kUIButtonBarButtonType,
	nil
	],

	// 4 - Prev button
	[ NSDictionary dictionaryWithObjectsAndKeys:
	@"buttonBarItemTapped:", kUIButtonBarButtonAction,
	@"button.png", kUIButtonBarButtonInfo,
	@"button.png", kUIButtonBarButtonSelectedInfo,
	//[ NSNumber numberWithFloat: 5],kUIButtonBarButtonInfoOffset,
	[ NSNumber numberWithInt: 4], kUIButtonBarButtonTag,
	self, kUIButtonBarButtonTarget,
	@"    ", kUIButtonBarButtonTitle,
	@"0", kUIButtonBarButtonType,
	nil
	],

	// 4 - Next button
	[ NSDictionary dictionaryWithObjectsAndKeys:
	@"buttonBarItemTapped:", kUIButtonBarButtonAction,
	@"button_send.png", kUIButtonBarButtonInfo,
	@"button_send.png", kUIButtonBarButtonSelectedInfo,
	//	[ NSNumber numberWithInt: 2],kUIButtonBarButtonInfoOffset,
	[ NSNumber numberWithInt: 5], kUIButtonBarButtonTag,
	self, kUIButtonBarButtonTarget,
	NSLocalizedStringFromTable(@"Send",@"iSMS",@""), kUIButtonBarButtonTitle,
	@"0", kUIButtonBarButtonType,
	nil
	],
	/*
	 [ NSDictionary dictionaryWithObjectsAndKeys:
	 @"buttonBarItemTapped:", kUIButtonBarButtonAction,
	 @"imageup.png", kUIButtonBarButtonInfo,
	 @"imagedown.png", kUIButtonBarButtonSelectedInfo,
	 [ NSNumber numberWithInt: 5], kUIButtonBarButtonTag,
	 self, kUIButtonBarButtonTarget,
	 @"Button5", kUIButtonBarButtonTitle,
	 @"0", kUIButtonBarButtonType,
	 nil
	 ],
	 */
	nil
	];
}

- (void)buttonBarItemTapped:(id) sender {
	int button = [ sender tag ];
	switch (button) {
		case 1: // Smileys
		{
			[self chooseSmiley];
			break;
		}
		case 2: // Contact
		[self _chooseContactForSMS];
		break;
		case 3: // Template
		{
			[self chooseTemplate];
			break;
		}
		case 4: // TODO
		//[self setCurrentMessageIndex:(--currentMessageIdx)];
		break;
		case 5: // Send
		{
			if([[iSMSPreference sharedInstance] confirmBeforeSend]){
				// Popup the send confirmation dialog
				if(sendAlert == nil){
					NSArray *buttons = [NSArray arrayWithObjects:NSLocalizedStringFromTable(@"Send",@"iSMS",@""), NSLocalizedStringFromTable(@"Cancel",@"iSMS",@""), nil];

#ifdef __BUILD_FOR_2_0__
                                        sendAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"Confirmation",@"iSMS",@"") 
                                                                               message:NSLocalizedStringFromTable(@"Send this message out?",@"iSMS",@"")
                                                                              delegate:self
                                                                     cancelButtonTitle:nil
                                                                     otherButtonTitles:nil];

                                        [sendAlert addButtonWithTitle:[buttons objectAtIndex:0]];
                                        [sendAlert addButtonWithTitle:[buttons objectAtIndex:1]];
                                        [sendAlert setCancelButtonIndex:1];
#else
					sendAlert = [[UIAlertSheet alloc] initWithTitle:NSLocalizedStringFromTable(@"Confirmation",@"iSMS",@"") buttons:buttons defaultButtonIndex:0 delegate:self context:nil];
					//[sendAlert setDestructiveButton:[[sendAlert buttons] objectAtIndex:0]];
					[sendAlert setBodyText:NSLocalizedStringFromTable(@"Send this message out?",@"iSMS",@"")];					
#endif
				}
#ifdef __BUILD_FOR_2_0__
                                [sendAlert show];
#else
				//[alertSheet setRunsModal:YES];
				[sendAlert popupAlertAnimated:YES];
#endif
			}else{
				[self sendSMS];
			}

		}
		break;
	}
}

//-------- button bar setup end --------

-(void) composeRecipientViewWillBecomeFirstResponder:(id)aView{
	DBG(@"View %@ will become first responder",aView);
}
	
-(void) composeRecipientViewDidBecomeFirstResponder:(id)aView{
		DBG(@"View %@ did become first responder",aView);
}

	
-(void) composeRecipientViewWillResignFirstResponder:(id)aView{
	DBG(@"View %@ will resign first responder",aView);
}
	
-(void) composeRecipientViewDidResignFirstResponder:(id)aView{
	DBG(@"View %@ did resign first responder",aView);
}

	
- (void)composeRecipientAtomWillBecomeFirstResponder:(id)fp8{
	DBG(@"composeRecipientAtomWillBecomeFirstResponder");
}

- (void)composeRecipientAtomDidBecomeFirstResponder:(id)fp8{
	DBG(@"composeRecipientAtomDidBecomeFirstResponder");
}

- (void)composeRecipientAtomDidResignFirstResponder:(id)fp8{
	DBG(@"composeRecipientAtomDidResignFirstResponder");
}
	
- (void)composeRecipientAtomDeleteClicked:(id)fp8{
	DBG(@"- (void)composeRecipientAtomDeleteClicked:(id)fp8");
}


#ifdef DEBUG
-(BOOL)respondsToSelector:(SEL)sel {
  BOOL rts = [super respondsToSelector:sel];
  DBG(@"!!! %@ respondsToSelector \"%@\" (%d)\n",[self class],NSStringFromSelector(sel), rts);
  return rts;
}
#endif

@end
