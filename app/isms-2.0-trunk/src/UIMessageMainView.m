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

#import "Prefix.h"
#import "UIMessageMainView.h"
#import "ui/common/UIImageNavigationBar.h"
#import "UIController.h"
#import "iSMSApp.h"
#import "ui/compose/UIComposeSMSView.h"
#import "UIMainView.h"
#import "Log.h"
#import "MessageListView.h";

//#import <UIKit/UIKit.h>
//#import <UIKit/UIView.h>
#import "ui/common/UITableEx.h"

#ifdef __BUILD_FOR_2_0__
#import <UIKit/UIImageAndTextTableCell.h>
#import <UIKit/UIImage-UIImagePrivate.h>
#import <UIKit/UIView-Rendering.h>
#import <UIKit/UIView-Hierarchy.h>
#import <UIKit/UIView-Geometry.h>
#import <UIKit/UINavigationItem.h>
#import <UIKit/UITableColumn.h>
#endif

#import "ui/compose/ISMSComposeViewController.h"
#import "controller/ISMSRootViewController.h"

typedef enum {
	ITEM_INBOX = 0,
	ITEM_DRAFTS = 1,
	ITEM_SENT = 2,
	ITEM_PROTECTED = 3,
	ITEM_SEARCH = 4
} TableItem;

/***************************************************************
 * Customized draft message list view 
 * 
 * @Author Shawn
 ***************************************************************/
@interface DraftMessageListView : MessageListView
-(void) messageSelected:(Message*)selectedMessage atRow:(int)row;
@end
@implementation DraftMessageListView
-(void) messageSelected:(Message*)selectedMessage atRow:(int)row{
	// switch to the compose view
	if(selectedMessage) {
		/*
		UIViewController *cc = [ISMSComposeViewController sharedInstance];
		
		UIComposeSMSView *composeView = cc.view;
		[composeView clearAllData];
		[composeView setMessage:selectedMessage];
//		[[UIController defaultController] switchToView:composeView from:_mainView withStyle:UITransitionFlipRight withParam:nil];
		UIMainView *_mainView = [UIMainView sharedInstance]; 
		 
		[[UIController defaultController] switchToView:composeView from:nil withStyle:UITransitionShiftLeft];
		//[(iSMSApp*)UIApp switchToViewForName:@"UIComposeSMSView" from:nil withStyle:UITransitionFlipRight];
		*/
	}
}
@end

/***************************************************************
 * Class Comments
 * 
 * @Author Shawn
 ***************************************************************/
@implementation UIMessageMainView

//@synthesize smsNavigationController;

+(UIMessageMainView*) sharedInstance{
	return (UIMessageMainView*)[[iSMSApp getInstance]getViewForName:@"UIMessageMainView"];
}

-(void)_initTableCells{
	if(tableCells){
		[tableCells release];
	}	
	tableCells = [[NSMutableArray alloc] init];
	UIImageAndTextTableCell *cell = [[UIImageAndTextTableCell alloc] init];
	
	// count the unread messages and display it in main view
	int count = [Message countInbox];
	int unreadCount = [Message countUnreadMessages];//[Message countByType:UNREAD_MESSAGE];
	NSString* inboxTitle;
	if(unreadCount > 0){
		inboxTitle = [NSString stringWithFormat:NSLocalizedStringFromTable(@"Inbox(total %d, unread %d)",@"iSMS",@"Inbox with unread message count"),count,unreadCount];
	}else{
		inboxTitle = [NSString stringWithFormat:NSLocalizedStringFromTable(@"Inbox(%d)",@"iSMS",@"Inbox with all message count"),count];
	}
	[cell setTitle:inboxTitle];
	UIImage *image = [UIImage applicationImageNamed:@"icon_message_main_inbox.png"];
	[cell setImage:image];
	[tableCells addObject:cell];
	[cell release];

	cell = [[UIImageAndTextTableCell alloc] init];
	count = [Message countDraftMessages];//[Message countByType:DRAFT_MESSAGE];
	[cell setTitle:[NSString stringWithFormat:NSLocalizedStringFromTable(@"Draft(%d)",@"iSMS",@""),count]];	
	image = [UIImage applicationImageNamed:@"icon_message_main_draft.png"];
	[cell setImage:image];
	[tableCells addObject:cell];
	[cell release];

	cell = [[UIImageAndTextTableCell alloc] init];
	count = [Message countByType:SENT_MESSAGE];
	[cell setTitle:[NSString stringWithFormat:NSLocalizedStringFromTable(@"Sent(%d)",@"iSMS",@""),count]];	
	image = [UIImage applicationImageNamed:@"icon_message_main_sent.png"];
	[cell setImage:image];
	[tableCells addObject:cell];
	[cell release];

//	cell = [[UIImageAndTextTableCell alloc] init];
//	[cell setTitle:@"Protected"];
//	image = [UIImage applicationImageNamed:@"icon_message_main_protected.png"];
//	[cell setImage:image];
//	[tableCells addObject:cell];
//	[cell release];
	
//	cell = [[UIImageAndTextTableCell alloc] init];
//	[cell setTitle:@"Search"];
//	image = [UIImage applicationImageNamed:@"icon_message_main_search.png"];
//	[cell setImage:image];	
//	[tableCells addObject:cell];
//	[cell release];

}

-(id)initWithFrame:(struct CGRect)frame{
	DBG(@"UIMessageMainView:initWithFrame()");
	self = [super initWithFrame:frame];
	if(self == nil) {
		return nil;
	}
	
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
	
	DBG(@"setBackgroundColor done!");

	topBar = [[UIImageNavigationBar alloc] init];
	[topBar setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width,UI_TOP_NAVIGATION_BAR_HEIGHT)];
	[topBar setBarStyle:3];
	[topBar pushNavigationItem: [[[UINavigationItem alloc] initWithTitle: NSLocalizedStringFromTable(@"Message",@"iSMS",@"")] autorelease]];
	[topBar showButtonsWithLeftTitle:nil rightTitle:BUTTON_COMPOSE leftBack:NO];
	[topBar enableAnimation];
	[topBar setDelegate:self];
	[self addSubview:topBar];
	DBG(@"topBar done!");
	
	// We only have one table, so use the full client area
	[self _initTableCells];
	DBG(@"_initTableCell done!");
	
	table = [[UITableEx alloc] initWithFrame: CGRectMake(0.0f, UI_TOP_NAVIGATION_BAR_HEIGHT, frame.size.width, frame.size.height-UI_TOP_NAVIGATION_BAR_HEIGHT)];
	UITableColumn *col = [[UITableColumn alloc] initWithTitle: @"Message" identifier:@"Message" width: frame.size.width];
	[table addTableColumn: col];
	[table setSeparatorStyle: 1];
	[table setRowHeight:44.];
	[table setDelegate:self]; // handle selection
	[table setDataSource:self];// provide cell
	//[table setReusesTableCells:YES];
	[table reloadData];
	[self addSubview: table];
	DBG(@"table done!");
	
	dataIsStale = NO;

	//TODO register for message change notifications, such as new message incoming...
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_messageChanged:) name:MESSAGE_CHANGE_NOTIFICATION object:nil];

	//Initialize the compose navigation 
	UIViewController *cc = [ISMSComposeViewController sharedInstance];
	composeNavigationController = [[UINavigationController alloc]initWithRootViewController:cc];
	[cc release];
	
	DBG(@"init done!");
	return self;
}

- (void) _messageChanged:(NSNotification *) notification{
	dataIsStale = YES;
}

-(void)navigationBar:(UINavigationBar*)bar buttonClicked:(int)button {
	if (button == 0) {
		//Note here we pass nill as the fromView so that the ComposeView could switch back to the main view.
		// because this view is inside the mainview.
		// UIMessageMainView is always belong to the UIMainView
		UIMainView *_mainView = [UIMainView sharedInstance]; 
		
		UIView *composeView = [composeNavigationController view];
		[[UIController defaultController] switchToView:composeView from:_mainView withStyle:UITransitionFlipRight withParam:nil];
		
		//[[iSMSApp getInstance] switchToViewForName:@"UIComposeSMSView" from:_mainView withStyle:UITransitionFlipRight];
		
		/*
		if(smsNavigationController == nil){
			ISMSRootViewController *root = [[ISMSRootViewController alloc] initWithNibName:nil bundle:nil];
			root.view = self;
			smsNavigationController = [[UINavigationController alloc] initWithRootViewController:root];
			[root release];
		}
		[smsNavigationController presentModalViewController:[ISMSComposeViewController sharedInstance] animated:YES];
		*/
	}
}

-(void)dealloc {
	RELEASE(topBar);
	RELEASE(table);
	RELEASE(tableCells);
	RELEASE(inboxMessageListView);
	RELEASE(sentMessageListView);
	RELEASE(draftMessageListView);
	
	RELEASE(composeNavigationController);
	[super dealloc];
}

- (void)tableRowSelected:(NSNotification *)notification
{
	int row = [table selectedRow];
	if(row == NSNotFound) {
		// Nothing really selected
		return;
	}
	// Switch to the next view according to the row id
	switch(row){
	case ITEM_INBOX:{
		//FIXME lazy-load ?
		if(	inboxMessageListView == nil){
			inboxMessageListView = [[MessageListView alloc]initWithFrame:[self frame] messageType:INBOX_MESSAGE showMessageDirection:NO];
		}
		[[UIController controllerForName:@"main"] switchToView:inboxMessageListView from:self withStyle:UITransitionShiftLeft];
		break;
	}
	case ITEM_SENT:{
		if(	sentMessageListView == nil){
			sentMessageListView = [[MessageListView alloc]initWithFrame:[self frame] messageType:SENT_MESSAGE showMessageDirection:NO];
		}
		[[UIController controllerForName:@"main"] switchToView:sentMessageListView from:self withStyle:UITransitionShiftLeft];
		break;
	}
	case ITEM_DRAFTS:{
		//
		if(draftMessageListView == nil){
			draftMessageListView = [[DraftMessageListView alloc]initWithFrame:[self frame] messageType:DRAFT_MESSAGE showMessageDirection:NO];
		}
		[[UIController controllerForName:@"main"] switchToView:draftMessageListView from:self withStyle:UITransitionShiftLeft];
		break;
	}
	}
}

- (int)numberOfRowsInTable:(UITable *)table {
	return [tableCells count];
}

- (UITableCell *)table:(UITable *)atable cellForRow:(int)arow column:(int)acol {
	return [tableCells objectAtIndex:arow];
}

// Reload data and refresh the table
- (void)reloadData {
//	[self _updateBarTitle];
//	[table clearRowSelection];
//	[table clearAllData];
//	[table reloadData];
	[self _initTableCells];
	[table reloadData];
	dataIsStale = NO;
}

-(BOOL)willShow:(NSDictionary*) param{
	LOG(@"UIMessageMainView - willShow()");
	[table clearRowSelection];
	if(dataIsStale){
		[self reloadData];
	}
	return YES;
}

-(BOOL)willHide:(NSDictionary*) param{
	LOG(@"UIMessageMainView - willHide()");
	return YES;
}

@end

@implementation ISMSMessageFolderViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if(self){
		self.title = NSLocalizedStringFromTable(@"Message",@"iSMS",@"");		
//		self.navigationItem = 
	}
	return self;
}

- (void)loadView{
	self.view = [[iSMSApp getInstance] getViewForName:@"UIMessageMainView"];
}

@end
