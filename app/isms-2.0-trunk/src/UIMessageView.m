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
//  along with iSMS.  If not, see <http://www.gnu.org/licenses/>.
//==============================================================================

#import <Foundation/Foundation.h>

#import "Prefix.h"
#import "UIMessageView.h"
#import "iSMSApp.h"
#import "ui/compose/UIComposeSMSView.h"
#import "Message.h"
#import "Log.h"

#import <WebCore/WebFontCache.h>
#import <GraphicsServices/GraphicsServices.h>
#import "UIController.h"
#import "BlackList.h"
#import "conversation/ISMSConversationView.h"
#import "iSMSPreference.h"

#import <UIKit/UINavigationItem.h>

#ifdef __BUILD_FOR_2_0__
#import <UIKit/UIView-Hierarchy.h>
#import <UIKit/UIView-Rendering.h>
#import <UIKit/UIView-Geometry.h>
#import <UIKit/UIActionSheet.h>
#endif

/***************************************************************
 * Class UIMessageView
 * 
 * @Author Shawn
 ***************************************************************/
@interface UIMessageTextView : UIRichTextView{
	UIMessageView	*swipeDelegate;
}
-(void)setSwipeDelegate:(id)aDelegate;
@end

@implementation UIMessageTextView
-(void)setSwipeDelegate:(id)aDelegate{
	swipeDelegate = aDelegate;
}

- (BOOL)canHandleSwipes{
	return YES;
}

#ifdef __BUILD_FOR_2_0__
- (int)swipe:(int)direction withEvent:(id)event
#else
- (int)swipe:(int)direction withEvent:(struct __GSEvent *)event
#endif
{
	if (direction == kSwipeDirectionRight){
		[swipeDelegate moveNext];
	}else if(direction == kSwipeDirectionLeft){
		[swipeDelegate movePrevious];
	}

	int result = [super swipe:direction withEvent:event];
	return result;
}
@end

@implementation UIMessageView
+(UIMessageView*)sharedInstance{
	return (UIMessageView*)[[iSMSApp getInstance]getViewForName:@"UIMessageView"];
}
// designated initializer
-(id)initWithFrame:(CGRect) rect {
	self = [super initWithFrame: rect];
	if(self == nil){
		return nil;
	}
	
	currentMessageIdx = -1;
	
	float c2[4] = {0.86f, 0.89f, 0.93f,1};
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	struct CGColor *bgColor = CGColorCreate(colorSpace, c2);
#ifdef __BUILD_FOR_2_0__
	[self setBackgroundColor:[UIColor colorWithCGColor:bgColor]];
#else
	[self setBackgroundColor:bgColor];
#endif
	CGColorRelease(bgColor);

	topBar = [[UINavigationBar alloc] init];
	[topBar setFrame:CGRectMake(0, 0, rect.size.width,UI_TOP_NAVIGATION_BAR_HEIGHT)];
	//[topBar setBarStyle:2];
	topBarTitle = [[UINavigationItem alloc] initWithTitle: @"Message"];
 	[topBar pushNavigationItem:topBarTitle];
	[topBar showButtonsWithLeftTitle:NSLocalizedStringFromTable(@"Back",@"iSMS",@"") rightTitle:nil leftBack:YES];
	[topBar enableAnimation];
	[topBar setDelegate:self];
	
	// Create the head part, which contains the addressField & timestampLabel
	float cWhite[4] = {1,1,1,1};
	// Head part height is 60
	headPart = [[UIView alloc] initWithFrame:CGRectMake(0,UI_TOP_NAVIGATION_BAR_HEIGHT,rect.size.width,(45 - 1))];
	
	CGColorRef whiteColor = CGColorCreate(colorSpace, cWhite);
#ifdef __BUILD_FOR_2_0__
	[headPart setBackgroundColor:[UIColor colorWithCGColor:whiteColor]];
#else
	[headPart setBackgroundColor:whiteColor];
#endif
	CGColorRelease(whiteColor);
	
	briefField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, 30) ];
	// Label Font, Content Font 
#ifdef __BUILD_FOR_2_0__
	[briefField setFont:[UIFont systemFontOfSize:18]];
#else
	//struct __GSFont *txtFont=[NSClassFromString(@"WebFontCache") createFontWithFamily:@"Helvetica" traits:2 size:18];
	struct __GSFont *font=[NSClassFromString(@"WebFontCache") createFontWithFamily:@"Helvetica" traits:2 size:18];
	[briefField setFont:font];
#endif

	bgColor = CGColorCreate(colorSpace, cWhite);
#ifdef __BUILD_FOR_2_0__
	[briefField setBackgroundColor:[UIColor colorWithCGColor:bgColor]];
#else
	[briefField setBackgroundColor:bgColor];
#endif
	CGColorRelease(bgColor);

	[briefField setPaddingLeft:10.0f];
	[briefField setTextCentersVertically:YES];
	[briefField setEnabled:NO];
	[headPart addSubview:briefField];
	
	//timestamp label height = 25
	//TODO use the background image ?
	//timestampLabel = [[UITextLabel alloc] initWithFrame:CGRectMake(6,30,rect.size.width,(15 - 1))];
	//timestampLabel = [[UITextLabel alloc] initWithFrame:CGRectMake((320 - 113 - 5),30,113,(15 - 1))];
	timestampLabel = [[UITextLabel alloc] initWithFrame:CGRectMake(6,30,150,(15 - 1))];
	float cGray[4] = {0.56f,0.56f,0.56f,1};
	CGColorRef grayColor = CGColorCreate(colorSpace,cGray);
#ifdef __BUILD_FOR_2_0__
	[timestampLabel setColor:[UIColor colorWithCGColor:grayColor]];
#else
	[timestampLabel setColor:grayColor];
#endif
        CGColorRelease(grayColor);

#ifdef __BUILD_FOR_2_0__
	[timestampLabel setFont:[UIFont systemFontOfSize:12]];
#else
	font=[NSClassFromString(@"WebFontCache") createFontWithFamily:@"Helvetica" traits:2 size:12];
	[timestampLabel setFont:font];
#endif
	[timestampLabel setText:@""];
	[headPart addSubview:timestampLabel];
	
	// The callout button
	UIImage* btnImage = [UIImage imageNamed:@"button_blue.png"];
	UIImage* btnImageOn = [UIImage imageNamed:@"button_blue_on.png"];

	// CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	float transparentColor[4] = {0, 0, 0, 0};
        CGColorRef transparentColorRef = CGColorCreate( colorSpace, transparentColor);

	calloutButton = [[UIPushButton alloc] initWithTitle:NSLocalizedStringFromTable(@"Call",@"iSMS",@"") autosizesToFit:NO];
	[calloutButton setFrame:CGRectMake((320 - 62 - 5),15,62,26)];
	[calloutButton setBackground:btnImage forState:0]; //up state
	[calloutButton setBackground:btnImageOn forState:1]; //down state

#ifdef __BUILD_FOR_2_0__
	[calloutButton setBackgroundColor:[UIColor colorWithCGColor:transparentColorRef]];
	[calloutButton setTitleFont:[UIFont systemFontOfSize:18]];
#else
	[calloutButton setBackgroundColor:transparentColorRef];
	struct __GSFont *buttonTitleFont=[NSClassFromString(@"WebFontCache") createFontWithFamily:@"Helvetica" traits:2 size:18];
	[calloutButton setTitleFont:buttonTitleFont];
#endif

        CGColorRelease(transparentColorRef);

	//[calloutButton setDrawsShadow: YES];
	[calloutButton setEnabled:YES];  //may not be needed
	//[calloutButton setStretchBackground:NO];
	[calloutButton setDrawContentsCentered:YES];
	[calloutButton setShowPressFeedback:NO];
#ifdef __BUILD_FOR_2_0__
	[calloutButton addTarget:self action:@selector(callContact) forControlEvents:UIControlEventTouchUpInside];
#else
	[calloutButton addTarget:self action:@selector(callContact) forEvents:kUIControlEventMouseUpInside];
#endif

	[headPart addSubview:calloutButton];
	
//	chatButton = [[UIPushButton alloc] initWithTitle:NSLocalizedStringFromTable(@"Chat",@"iSMS",@"") autosizesToFit:NO];
//	[chatButton setFrame:CGRectMake((320 - 62 - 5 - 70),15,62,26)];
//	[chatButton setBackground:btnImage forState:0]; //up state
//	[chatButton setBackground:btnImageOn forState:1]; //down state
//	[chatButton setBackgroundColor:CGColorCreate( colorSpace, transparentColor)];
//	[chatButton setTitleFont:buttonTitleFont];
//	[chatButton setEnabled:YES];  //may not be needed
//	[chatButton setDrawContentsCentered:YES];
//	[chatButton setShowPressFeedback:NO];
//	[chatButton addTarget:self action:@selector(chatContact) forEvents:1];
//	[headPart addSubview:chatButton];
	
	//textView is between the topBar(40) + bbriefView(40) and bottomButtonBar(49)
	textView = [[UIMessageTextView alloc]initWithFrame:CGRectMake(0, (UI_TOP_NAVIGATION_BAR_HEIGHT +45), rect.size.width, (460 - UI_BOTTOM_BUTTON_BAR_HEIGHT - 45 - UI_TOP_NAVIGATION_BAR_HEIGHT) ) ];
	[textView setEditable:NO];
#ifdef __BUILD_FOR_2_0__
	[textView setFont:[UIFont systemFontOfSize:20]];
#else
	[textView setTextSize:20];
#endif

	[textView setText:@""];
	[textView setSwipeDelegate:self];
	[textView setAllowsRubberBanding:YES];
#ifdef __BUILD_FOR_2_0__
#else
	[textView setAdjustForContentSizeChange:YES];
#endif
	
	[self addSubview:topBar];
	[self addSubview:headPart];
	//[self addSubview:timestampPart];
	[self addSubview:textView];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_messageChanged:) name:MESSAGE_CHANGE_NOTIFICATION object:nil];
	return self;
}

-(void)dealloc{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	RELEASE(messageList);
	RELEASE(topBarTitle);
	RELEASE(topBar);
	RELEASE(briefField);
	RELEASE(calloutButton);
	RELEASE(chatButton);
	RELEASE(timestampLabel);
	RELEASE(headPart);
	RELEASE(textView);
	[super dealloc];
}

// If message is deleted or saved, update the list
- (void) _messageChanged:(NSNotification *) notification{
	// We do not care about the message change type
	messageChanged = YES;
}

-(void)didShow:(NSDictionary*) param{
	if(messageChanged){
		messageChanged = NO;
		[[UIController defaultController] switchBackFrom:self];
	}
}

-(void)callContact{
	//FIXME should suspend when switching to the SMS conversation view
	Message* msg = [messageList objectAtIndex:currentMessageIdx];
	NSString* url = [NSString stringWithFormat:@"tel:%@",[msg phoneNumber]];
	LOG(@"Call contact %@",url);
#ifdef __BUILD_FOR_2_0__
	[[UIApplication sharedApplication] openURL:[[NSURL alloc] initWithString: url]];
#else
	[UIApp openURL:[[NSURL alloc] initWithString: url]];
#endif
}

-(void)chatContact{
	Message* msg = [messageList objectAtIndex:currentMessageIdx];
	NSString* url = [NSString stringWithFormat:@"sms:/open?address=%@;showkeyboard=1",[msg phoneNumber]];
	LOG(@"Chat with contact %@",url);
#ifdef __BUILD_FOR_2_0__
	[[UIApplication sharedApplication] openURL:[[NSURL alloc] initWithString: url]];
#else
	[UIApp openURL:[[NSURL alloc] initWithString: url]];
#endif
	//[UIApp applicationOpenURL:[[NSURL alloc] initWithString: url]];
}

-(void)moveNext{
	if(currentMessageIdx < ([messageList count] - 1)){
		[self setCurrentMessageIndex:(++currentMessageIdx)];
	}
}

-(void)movePrevious{
	if(currentMessageIdx > 0){
		[self setCurrentMessageIndex:(--currentMessageIdx)];
	}
}

-(void)_backToMessageList{
	[[UIController defaultController] switchBackFrom:self];
}

-(void)navigationBar:(UINavigationBar*)bar buttonClicked:(int)button{
	//NSLog(@"navbar clicked bar:%@ button:%i", bar, button);
	if (button == 1){
		[self _backToMessageList];
	}
}


#define FOUR_VIEW_BTN_WIDTH 62.0f

//==== For UIButtonBar ==
- (void)_setButtonFrame:(UIView*)btnView btnTag:(int)tag{
	[btnView setFrame:CGRectMake(2.0f + ((tag - 1) * 62.0f), 1.0f, 62.0f, 49.0f)];
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

// We need to customize the button bar style
#ifdef __BUILD_FOR_2_0__
- (UIToolbar *)createButtonBar {
#else
- (UIButtonBar *)createButtonBar {
#endif
	// Create the button bar with default style
	return [self createButtonBarSetDelegate:self setBarStyle:1 setButtonBarTrackingMode:1 showSelectionForButton:-1];
}

- (NSArray *)buttonBarItems {
	return [ NSArray arrayWithObjects:
	// 1 - Reply button
	[ NSDictionary dictionaryWithObjectsAndKeys:
	@"buttonBarItemTapped:", kUIButtonBarButtonAction,
	@"button_reply.png", kUIButtonBarButtonInfo,
	@"button_reply.png", kUIButtonBarButtonSelectedInfo,
	//[ NSNumber numberWithFloat: 5], kUIButtonBarButtonInfoOffset,
	[ NSNumber numberWithInt: 1], kUIButtonBarButtonTag,
	self, kUIButtonBarButtonTarget,
	//@"     ", kUIButtonBarButtonTitle,
	@"0", kUIButtonBarButtonType,
	nil
	],
	
	// 2 - Forward button
	[ NSDictionary dictionaryWithObjectsAndKeys:
	@"buttonBarItemTapped:", kUIButtonBarButtonAction,
	@"button_forward.png", kUIButtonBarButtonInfo,
	@"button_forward.png", kUIButtonBarButtonSelectedInfo,
	//[ NSNumber numberWithFloat: 5], kUIButtonBarButtonInfoOffset,
	[ NSNumber numberWithInt: 2], kUIButtonBarButtonTag,
	self, kUIButtonBarButtonTarget,
	//@"     ", kUIButtonBarButtonTitle,
	@"0", kUIButtonBarButtonType,
	nil
	],
	
	// 3 - Delete button
	[ NSDictionary dictionaryWithObjectsAndKeys:
	@"buttonBarItemTapped:", kUIButtonBarButtonAction,
	@"button_delete.png", kUIButtonBarButtonInfo,
	@"button_delete.png", kUIButtonBarButtonSelectedInfo,
	//[ NSNumber numberWithFloat: 5],kUIButtonBarButtonInfoOffset,
	[ NSNumber numberWithInt: 3], kUIButtonBarButtonTag,
	self, kUIButtonBarButtonTarget,
	//@"     ", kUIButtonBarButtonTitle,
	@"0", kUIButtonBarButtonType,
	nil
	],

	// 4 - Prev button
	[ NSDictionary dictionaryWithObjectsAndKeys:
	@"buttonBarItemTapped:", kUIButtonBarButtonAction,
	@"button_left.png", kUIButtonBarButtonInfo,
	@"button_left.png", kUIButtonBarButtonSelectedInfo,
	//[ NSNumber numberWithFloat: 5],kUIButtonBarButtonInfoOffset,
	[ NSNumber numberWithInt: 4], kUIButtonBarButtonTag,
	self, kUIButtonBarButtonTarget,
	//@"     ", kUIButtonBarButtonTitle,
	@"0", kUIButtonBarButtonType,
	nil
	],

	// 4 - Next button
	[ NSDictionary dictionaryWithObjectsAndKeys:
	@"buttonBarItemTapped:", kUIButtonBarButtonAction,
	@"button_right.png", kUIButtonBarButtonInfo,
	@"button_right.png", kUIButtonBarButtonSelectedInfo,
//	[ NSNumber numberWithInt: 2],kUIButtonBarButtonInfoOffset,
	[ NSNumber numberWithInt: 5], kUIButtonBarButtonTag,
	self, kUIButtonBarButtonTarget,
	//@"     ", kUIButtonBarButtonTitle,
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


-(void)setMessageList:(NSArray*) msgList{
	if(msgList){
		RETAIN(messageList,msgList);	
	}
}

//FIXME use message iterator
-(void)setCurrentMessageIndex:(int) idx{
	// Do not need to check the upper/lower bound, we'll fail fast if something wrong
	[self setButtonEnabled:4 enabled:(idx >0)];
	[self setButtonEnabled:5 enabled:(idx < ([messageList count] - 1))];
	currentMessageIdx = idx;
	Message* msg = [messageList objectAtIndex:idx];
	if(msg){
		if([msg isOutgoing]){
			[briefField setLabel:NSLocalizedStringFromTable(@"To:",@"iSMS",@"")];	
		}else{
			[briefField setLabel:NSLocalizedStringFromTable(@"From:",@"iSMS",@"")];
		}
		[briefField setText:[NSString stringWithFormat:@"%@",[msg getSenderName]]];
		[topBarTitle setTitle:[NSString stringWithFormat:NSLocalizedStringFromTable(@"%d of %d",@"iSMS",@""),idx + 1,[messageList count]]];
		NSString* dateFormat = @"%Y/%m/%d %H:%M:%S";

#ifdef __BUILD_FOR_2_0__
		NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
		//[dateFormatter setDateFormat:dateFormat];
		[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
		[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
		
		[dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
		[dateFormatter setLocale:[NSLocale currentLocale]];
		NSString * formattedDate = [dateFormatter stringFromDate:[msg date]];
		[dateFormatter release];
#else
		NSString* formattedDate = [[msg date] descriptionWithCalendarFormat:dateFormat timeZone:nil locale:[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]];
#endif
		[timestampLabel setText:formattedDate];
		[textView setText:[msg body]];
		if(![msg hasBeenRead]){
			DBG(@"Marking message as read");
			[msg markAsRead:YES];
		}
		messageChanged = NO;
	}
}

#ifdef __BUILD_FOR_2_0__
-(void)actionSheet:(UIActionSheet *)sheet clickedButtonAtIndex:(NSInteger)button
{
	[sheet dismissWithClickedButtonIndex:button animated:YES];
#else
-(void)alertSheet:(UIAlertSheet*)sheet buttonClicked:(int)button{
	[sheet dismiss];
#endif
	if(sheet == deleteAlert){
		if(button <= 2){
			Message* msg = [messageList objectAtIndex:currentMessageIdx];
			if(!msg){
				LOG(@"ERROR - Message at index %d is null!",currentMessageIdx);
				return;
			}
			if(button == 2){
				// Also block the sender
				[[BlackList sharedInstance]block:[msg phoneNumber]];
			}
			// delete
			if([msg delete]){
				// switch back to the message list view
				// Show the delete animation ???
				[self _backToMessageList];
			}
		}
	}
}


-(void)_deleteCurrentMessage{
	// Popup the delete alert sheet
	if(deleteAlert == nil){
		NSArray *buttons = [NSArray arrayWithObjects:
			NSLocalizedStringFromTable(@"Delete",@"iSMS",@""), 
			NSLocalizedStringFromTable(@"Delete and block",@"iSMS",@""),
			NSLocalizedStringFromTable(@"Cancel",@"iSMS",@""), 
			nil];
#ifdef __BUILD_FOR_2_0__
		deleteAlert = [[UIActionSheet alloc] initWithTitle:NSLocalizedStringFromTable(@"Delete this message ?",@"iSMS",@"")
                                                          delegate:self
                                                 cancelButtonTitle:[buttons objectAtIndex:2]
                                            destructiveButtonTitle:[buttons objectAtIndex:0]
                                                 otherButtonTitles:nil];
		[deleteAlert addButtonWithTitle:[buttons objectAtIndex:1]];
		[deleteAlert setCancelButtonIndex:2];
		[deleteAlert setDestructiveButtonIndex:0];
#else
		deleteAlert = [[UIAlertSheet alloc] initWithTitle:NSLocalizedStringFromTable(@"Delete this message ?",@"iSMS",@"") buttons:buttons defaultButtonIndex:2 delegate:self context:nil];
		[deleteAlert setDestructiveButton:[[deleteAlert buttons] objectAtIndex:0]];
		[deleteAlert setAlertSheetStyle:2];
#endif
	}
	
#ifdef __BUILD_FOR_2_0__
	[deleteAlert showInView:self];
#else
	[deleteAlert presentSheetFromAboveView:self];
#endif
}

-(void)_forwardOrReplyMessage:(BOOL)isForward{
	Message* msg = [messageList objectAtIndex:currentMessageIdx];
	if(isForward){
		// Forward
		UIComposeSMSView *composeView = (UIComposeSMSView*)[[iSMSApp getInstance] getViewForName:@"UIComposeSMSView"];
		[composeView clearAllData];
		[composeView setTitle:NSLocalizedStringFromTable(@"Forward Message",@"iSMS",@"")];
		[composeView setInitialText:[msg body]];
		[[UIController defaultController] switchToView:composeView from:self withStyle:UITransitionZoomOut];
	}else{
		// Reply
		if([[iSMSPreference sharedInstance]useConversationView]){
			// use the conversation view
			ISMSConversationView *convView = (ISMSConversationView*)[[iSMSApp getInstance] getViewForName:@"ISMSConversationView"];
			[convView setConversationName:[msg getSenderName] phoneNumber:[msg phoneNumber]];
			[[UIController defaultController] switchToView:convView from:self withStyle:UITransitionZoomOut];			
		}else{
			// use the compose view
			UIComposeSMSView *composeView = (UIComposeSMSView*)[[iSMSApp getInstance] getViewForName:@"UIComposeSMSView"];
			[composeView clearAllData];
			[composeView setTitle:NSLocalizedStringFromTable(@"Reply Message",@"iSMS",@"")];
			[composeView addRecipient:[msg getSenderName] withNumber:[msg phoneNumber]];
			[[UIController defaultController] switchToView:composeView from:self withStyle:UITransitionZoomOut];
		}
	}	

}

- (void)buttonBarItemTapped:(id) sender {
	int button = [ sender tag ];
	switch (button) {
		case 1: // reply
		{
			[self _forwardOrReplyMessage:NO];
			break;
		}
		case 2: // forward
			[self _forwardOrReplyMessage:YES];
			break;
		case 3: // delete
			[self _deleteCurrentMessage];
			break;
		case 4: // previous
			//[self setCurrentMessageIndex:(--currentMessageIdx)];
			[self movePrevious];
			break;
		case 5: // next
			//[self setCurrentMessageIndex:(++currentMessageIdx)];
			[self moveNext];
			break;
	}
}

-(void)disableAllButtons{
	[self setButtonEnabled:1 enabled:NO];
	[self setButtonEnabled:2 enabled:NO];
	[self setButtonEnabled:3 enabled:NO];
	[self setButtonEnabled:4 enabled:NO];
	[self setButtonEnabled:5 enabled:NO];
}

// Will be called by the UIController before transition and after transition
-(void)clearAllData{
	currentMessageIdx = 0;
	RELEASE(messageList);
	messageChanged = NO;
	[textView setText:@""];
}

-(void)resetAllState{
	[self clearAllData];
	[self setButtonEnabled:1 enabled:YES];
	[self setButtonEnabled:2 enabled:YES];
	[self setButtonEnabled:3 enabled:YES];
	[self setButtonEnabled:4 enabled:YES];
	[self setButtonEnabled:5 enabled:YES];
}

@end
