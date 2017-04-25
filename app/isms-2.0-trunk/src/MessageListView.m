//==============================================================================
//	Created on 2007-11-18
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

#import "Prefix.h"
#import "MessageListView.h"
#import <UIKit/UITableColumn.h>
#import "UISwipeAwareTable.h"
#import "UIMessageTableCell.h"
#import "ui/compose/UIComposeSMSView.h"
#import "iSMSApp.h"
#import "UIController.h"
#import "Message.h"
#import "UIMessageView.h"
#import "Log.h"
#import "ui/common/UIImageNavigationBar.h"
#import "UIMainView.h"

#ifdef __BUILD_FOR_2_0__
#import <UIKit/UIView-Rendering.h>
#import <UIKit/UIView-Hierarchy.h>
#import <UIKit/UIAlertView-Private.h>
#endif

#import <UIKit/UINavigationItem.h>

@implementation MessageListView

-(void)setupNavBarButton:(BOOL) isEditMode{
	if(isEditMode){
		[topBar showLeftButton:NSLocalizedStringFromTable(@"Clear",@"iSMS",@"") withStyle:4 rightButton:NSLocalizedStringFromTable(@"Done",@"iSMS",@"") withStyle:3];
	}else{
		[topBar showButtonsWithLeftTitle:NSLocalizedStringFromTable(@"Main",@"iSMS",@"") rightTitle:NSLocalizedStringFromTable(@"Edit",@"iSMS",@"") leftBack:YES];
	}
}

- (id)initWithFrame:(struct CGRect)frame{
	return [self initWithFrame:frame messageType:0];
}
/**
 * Message List View
 * 
 *  List/Remove/Switch to detail/Switch to forward/Switch to new
 * 
 */
- (id)initWithFrame:(struct CGRect)frame messageType:(int)msgType{
	return [self initWithFrame:frame messageType:msgType showMessageDirection:YES];
}

- (id)initWithFrame:(struct CGRect)frame messageType:(int)msgType showMessageDirection:(BOOL)showMessageDirection{
	LOG(@"MessageListView:initWithFrame");
	self=[super initWithFrame: frame];
	if(self==nil) {
		return nil;
	}

	editMode = NO;
	messageType = msgType;
	
	// BG color - WHITE
	float c[4] = {1.0, 1.0, 1.0, 1.0};
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	struct CGColor *whiteColor = CGColorCreate(colorSpace, c);
#ifdef __BUILD_FOR_2_0__
	[self setBackgroundColor:[UIColor colorWithCGColor:whiteColor]];
#else
	[self setBackgroundColor:whiteColor];
#endif
	CGColorRelease(whiteColor);
	CGColorSpaceRelease(colorSpace);

	topBar = [[UIImageNavigationBar alloc] init];
	[topBar setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width,UI_TOP_NAVIGATION_BAR_HEIGHT)];
	[topBar setBarStyle:3];
	topBarTitle = [[UINavigationItem alloc] initWithTitle: @"Message List"];
	[topBar pushNavigationItem:topBarTitle];
	//[topBar showButtonsWithLeftTitle:@"Edit" rightTitle:BUTTON_COMPOSE leftBack:NO];
	//[topBar showButtonsWithLeftTitle:@"Main" rightTitle:@"Edit" leftBack:YES];
	[self setupNavBarButton:NO];
	[topBar enableAnimation];
	[topBar setDelegate:self];	        
	[self addSubview:topBar];

	// We only have one table, so use the full client area
	CGRect _tableFrame = CGRectMake(0.0f, UI_TOP_NAVIGATION_BAR_HEIGHT, frame.size.width, frame.size.height-UI_TOP_NAVIGATION_BAR_HEIGHT); 
	table = [[UIMessageListTable alloc] initWithFrame:_tableFrame];
	[table setShowMessageDirection:showMessageDirection];
	UITableColumn *col = [[UITableColumn alloc] initWithTitle: @"" identifier:@"col0" width: frame.size.width ];
	[table addTableColumn: col];
	[table setSeparatorStyle: 1];
	[table setRowHeight:60.];

	[table setShowScrollerIndicators:YES];
	[table setAllowSelectionDuringRowDeletion:NO];
	[table setReusesTableCells:YES];
	//[table enableRowDeletion: YES animated: YES];	// Enable deletion
	
	[table setDelegate:self];
	[table setDataSource:self];

	[self reloadData];
	[self addSubview: table];
	DBG(@"table done!");

	_delegate = nil;
	ignoreMessageChangeNotification = NO;
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_messageChanged:) name:MESSAGE_CHANGE_NOTIFICATION object:nil];
	return self;
}

//-(void)showComposeView{
//  [[iSMSApp getInstance] switchToViewForName:@"UIComposeSMSView" from:nil withStyle:UITransitionFlipRight];
//}

- (void)dealloc{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	RELEASE(topBarTitle);
	RELEASE(topBar);
	RELEASE(table);
	RELEASE(clearListAlert);
	RELEASE(errorAlert);
	_delegate = nil;
	[super dealloc];
}

// If message is deleted or saved, update the list
- (void) _messageChanged:(NSNotification *) notification{
	if(!ignoreMessageChangeNotification){
		// Mark data is stale and we'll reload it when show
		dataIsStale = YES;
	}
}

// See enum MessageType in Message.h
-(void)setMessageType:(int)type{
	messageType = type;
	[self reloadData];
}

-(int)_getMessageCount{
	return [[table messageList] count];
}

-(NSString*)_getListName{
	NSString *name;
	if(messageType == DRAFT_MESSAGE){
		name = [NSString stringWithFormat:NSLocalizedStringFromTable(@"Draft",@"iSMS",@"")];
	}else if(messageType == INBOX_MESSAGE ){
		name = [NSString stringWithFormat:NSLocalizedStringFromTable(@"Inbox",@"iSMS",@"")];
	}else if(messageType == SENT_MESSAGE){
		name = [NSString stringWithFormat:NSLocalizedStringFromTable(@"Sent",@"iSMS",@"")];
	}else{
		name = [NSString stringWithFormat:NSLocalizedStringFromTable(@"Message",@"iSMS",@"")];
	}
	return name;
}

-(void)_updateBarTitle{
	NSString *listName = [self _getListName];
	int msgCount = [self _getMessageCount];	
	//[topBar setPrompt:@"Message List"];
	NSString* barTitle = [NSString stringWithFormat:@"%@(%d)",listName,msgCount];
	/*
	if(messageType == DRAFT_MESSAGE){
		barTitle = [NSString stringWithFormat:NSLocalizedStringFromTable(@"Draft(%d)",@"iSMS",@""),msgCount];
	}else if(messageType == INBOX_MESSAGE ){
		barTitle = [NSString stringWithFormat:NSLocalizedStringFromTable(@"Inbox(%d)",@"iSMS",@""),msgCount];
	}else if(messageType == SENT_MESSAGE){
		barTitle = [NSString stringWithFormat:NSLocalizedStringFromTable(@"Sent(%d)",@"iSMS",@""),msgCount];
	}else{
		barTitle = [NSString stringWithFormat:NSLocalizedStringFromTable(@"Message(%d)",@"iSMS",@""),msgCount];
	}
	*/
	[topBarTitle setTitle:barTitle];	
}

// Reload data and refresh the table
- (void)reloadData {
	[table clearRowSelection:NO];
	[table clearAllData];
	[table reloadData];
	[self _updateBarTitle];
	dataIsStale = NO;
}

-(void)navigationBar:(UINavigationBar*)bar buttonClicked:(int)button {
	if (button == 1) {
		if(editMode){
			DBG(@"TODO - Clear all messages in this list");
			if(clearListAlert == nil){
				NSString *clearBtnTitle = [NSString stringWithFormat:@"%@ %@"
				                           ,NSLocalizedStringFromTable(@"Clear",@"iSMS",@"")
				                           ,[self _getListName]
										];
				NSArray *buttons = [NSArray arrayWithObjects:
					//NSLocalizedStringFromTable(@"Clear Folder",@"iSMS",@""),
					clearBtnTitle,
					NSLocalizedStringFromTable(@"Cancel",@"iSMS",@""),
					nil];
#ifdef __BUILD_FOR_2_0__
				clearListAlert = [[UIAlertView alloc] initWithTitle:@"" buttons:buttons defaultButtonIndex:1 delegate:self context:nil];
#else
				clearListAlert = [[UIAlertSheet alloc] initWithTitle:@"" buttons:buttons defaultButtonIndex:1 delegate:self context:nil];
#endif
				[clearListAlert setDestructiveButton:[[clearListAlert buttons] objectAtIndex:0]];
			}
			[clearListAlert presentSheetFromAboveView:[[UIController defaultController] currentView]];
		}else{
			// Switch back to the sms-main-view	
			[[UIController controllerForName:@"main"] switchBackFrom:self];
		}
	} else if(button == 0) {
		editMode = !editMode;
		[self setupNavBarButton:editMode];
		NSArray* rows = (NSArray*)[table visibleCells];
		int i,j;
		if(editMode) {
			// Swich to edit mode
			// 1. Hide "New" button
			// 2. Change "Edit" button to "Done" button
			// 3. Show delete icons on table row
			// 4. Redraw the visible rows
			//[topBar showButtonsWithLeftTitle:@"Done" rightTitle:nil leftBack:NO];
			[table clearRowSelection:NO];
			[table enableRowDeletion: editMode animated: YES];
			for(i = 0;i < [rows count];i++) {
				NSArray* cells = (NSArray*)[rows objectAtIndex:i];
				for(j = 0;j < [cells count];j++) {
					UITableCell* cell = [cells objectAtIndex:j];
					//NSLog(@"Visible Cell: %@ 0x%x",[cell class], cell);
					if(cell){
						[cell _showDeleteOrInsertion:YES withDisclosure:NO animated:YES isDelete:YES andRemoveConfirmation:YES];
					}
				}
			}
		} else {
			// Switch back to normal mode
			//[topBar showButtonsWithLeftTitle:@"Edit" rightTitle:BUTTON_COMPOSE leftBack:NO];
			for(i = 0;i < [rows count];i++) {
				NSArray* cells = (NSArray*)[rows objectAtIndex:i];
				for(j = 0;j < [cells count];j++) {
					UITableCell* cell = [cells objectAtIndex:j];
					//NSLog(@"Visible Cell: %@ 0x%x",[cell class], cell);
					if(cell){
						/*TEST code
						if([cell isRemoveControlVisible]){
							// release the remove control first
							UIView* removeCtrl = [cell removeControl];
							//[cell  removeControlWillHideRemoveConfirmation:removeCtrl];
							//[removeCtrl removeFromSuperview];
							[cell _releaseRemoveControl];
							
						}
						*/
						[cell _showDeleteOrInsertion:NO withDisclosure:YES animated:YES isDelete:NO andRemoveConfirmation:NO];
					}
				}
			}
			[table enableRowDeletion: editMode animated: YES];
		}

	}
}

#ifdef __BUILD_FOR_2_0__
-(void) alertView:(UIAlertView *)sheet clickedButtonAtIndex:(NSInteger)button
{
#else
-(void)alertSheet:(UIAlertSheet*)sheet buttonClicked:(int)button {
#endif
	[sheet dismiss];
	if(sheet == clearListAlert){
		switch(button){
			case 1:{
				[Message deleteByType:messageType];
				[self reloadData];
				editMode = NO;
				[table enableRowDeletion: NO animated: NO];
				[self setupNavBarButton:NO];
				//[[UIController controllerForName:@"main"] switchBackFrom:self];
				DBG(@"Clear message list");
				break;
			}case 2:{
				DBG(@"Canceled");
				break;
			}
		}
	}else if(sheet == errorAlert){
		[table clearAllData];
		[table reloadData];
	}
}

- (void)setDelegate:(id)delegate
{
	_delegate = delegate;
}

-(void) messageSelected:(Message*)selectedMessage atRow:(int)row{
	// switch to the message view page
	if(selectedMessage) {
		UIMessageView *msgView = [UIMessageView sharedInstance];
		if(msgView){
			[msgView resetAllState];
			[msgView setMessageList:[table messageList]];
			[msgView setCurrentMessageIndex:row];
			UIController* controller = [UIController defaultController];
			[controller switchToView:msgView from:nil withStyle:UITransitionShiftLeft];
		}else{
			LOG(@"ERROR - UIMessageView is not initialized");
		}
	} else {
		LOG(@"MessageListView:tableRowSelected() - No associated message found, will do nothing!");
	}
}

-(BOOL) canDeleteMessage:(Message*)msg atRow:(int)row{
	//Return NO here is some message is important and could not be deleted
	return YES;
}

-(void) didDeleteMessage:(Message*)message atRow:(int)row{
	// Message table cell is removed. Now really remove the message data
	ignoreMessageChangeNotification = YES;
	BOOL success = message && [message delete];
	ignoreMessageChangeNotification = NO;
	[self _updateBarTitle];
	
	if(success) {
		// Check message count and if is 0, swith back to previous 
		if([self _getMessageCount] == 0){
			[[UIController controllerForName:@"main"] switchBackFrom:self];
		}
	}else{
		// Error removing the message ??
		NSString* title;
		NSString* text;
		title = @"FAILED";
		text = [NSString stringWithFormat:@"Could not delete Message #%d !",row];
		// Prompt user
		if(errorAlert == nil){
#ifdef __BUILD_FOR_2_0__
			errorAlert = [[UIAlertView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, 320.0f, 240.0f)];
#else
			errorAlert = [[UIAlertSheet alloc] initWithFrame: CGRectMake(0.0f, 0.0f, 320.0f, 240.0f)];
#endif
			[errorAlert setTitle: title];
			[errorAlert addButtonWithTitle: @"OK"];
			[errorAlert setDelegate: self];
		}
		[errorAlert setBodyText: text];
		[errorAlert popupAlertAnimated: YES];
		/*
		 [alertSheet setTitle: @"Remove Message"];
		 [alertSheet setBodyText: @"Are you sure to remove this message?"];
		 [alertSheet addButtonWithTitle: @"YES"];
		 [alertSheet addButtonWithTitle: @"NO"];
		 */

	}
}

-(BOOL)willShow:(NSDictionary*) param{
	LOG(@"MessageListView - willShow()");
	// If data is stale, reload data
	if(dataIsStale){
		[self reloadData];
	}
	return YES;
}

-(void)didShow:(NSDictionary*) param{
	// Clear the table selection
	[table clearRowSelection:NO];
	[table displayScrollerIndicators];
	// If current message count is 0, slide back to the main view!
	if([self _getMessageCount] == 0){
//		UIController* controller = [UIController controllerForName:@"main"];
//		[controller switchToView]
//		[controller clearAllState];
		[[UIController controllerForName:@"main"] switchBackFrom:self];
	}	
}

-(BOOL)willHide:(NSDictionary*) param{
	LOG(@"MessageListView - willHide()");
	return YES;
}

/**
 * This method will be called by MessageTable
 */
-(NSArray*) getMessageList{
	NSArray* result = nil;
	switch(messageType){
	case INBOX_MESSAGE:
		result = [Message listInbox];
		break;
	case SENT_MESSAGE:
		result = [Message listByType:SENT_MESSAGE];
		break;
	case DRAFT_MESSAGE:
		//result = [Message listByType:DRAFT_MESSAGE];
		result = [Message listDraftMessages];
		break;
	default:
		result = [Message list];
	}

	return result;
}
@end
