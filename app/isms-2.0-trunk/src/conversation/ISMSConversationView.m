//==============================================================================
//	Created on 2008-4-11
//==============================================================================
//	$Id$
//==============================================================================
//	Copyright (C) <2008>  Shawn Qian(shawn.chain@gmail.com)
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
#import "ISMSConversationView.h"
#import "ISMSConversationModel.h"
#import <UIKit/UIKit.h>
#import <UIKit/UIFieldEditor.h>
#import <WebCore/WebFontCache.h>
#import <GraphicsServices/GraphicsServices.h>
#import "UIController.h"
#import "BalloonCell.h"
#import "Message.h"
#import "QXGestureMaskView.h"
#import "SMSCenter.h"
#import "ui/compose/SMSProgressView.h"
#import <MessageUI/SMSComposeRecipient.h>
#import "UITableEx.h"
#import <UIKit/UINavigationItem.h>
#import <UIKit/UItableColumn.h>
#import <UIKit/UITextField.h>

#ifdef __BUILD_FOR_2_0__
#import <UIKit/UIView-Rendering.h>
#import <UIKit/UIView-Hierarchy.h>
#import <UIKit/UIView-Geometry.h>
#import <UIKit/UIView-Animation.h>
#import <UIKit/UIImage-UIImageDeprecated.h>
#import <UIKit/UIImage-UIImagePrivate.h>
#import <UIKit/UIKeyboardImpl.h>
#import <UIKit/UIActionSheet.h>
#endif

#import "ui/compose/ISMSComposeViewController.h"

@interface BubbleInputField : UITextField{
	//UIImage	*bgImage;
}
@end

@implementation ISMSConversationView : UIView

-(id)initWithFrame:(CGRect)rect{
	[super initWithFrame:rect];
	
	// Set the light blue background
	float bgColorData[4] = {0.86f, 0.89f, 0.93f,1};
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	struct CGColor *bgColor = CGColorCreate(colorSpace, bgColorData);
#ifdef __BUILD_FOR_2_0__
	[self setBackgroundColor:[UIColor colorWithCGColor:bgColor]];
#else
	[self setBackgroundColor:bgColor];
#endif
        CGColorRelease(bgColor);
	CGColorSpaceRelease(colorSpace);

	[self _createSubviews];
	return self;
}

-(void)dealloc{
	RELEASE(topBar);
	RELEASE(topBarTitle);
	RELEASE(table);
	RELEASE(input);
	RELEASE(inputBar);
#ifdef __BUILD_FOR_2_0__
#else
	RELEASE(keyboard);
#endif
	RELEASE(modelData);
	RELEASE(cells);
	RELEASE(progressViewController);
	RELEASE(clearConversationAlert);
	[super dealloc];
}

//==============================================================================
// internal methods
//==============================================================================
-(void)_createSubviews{
	float y = 0.f;
	CGRect clientArea = [self bounds];
	// Get the default size for a navigation bar with a prompt
	CGSize topBarSize = [UINavigationBar defaultSize];
	// Position the navigation bar in the top left corner and use the default sizes
	CGRect topBarRect = CGRectMake(0.0f, 0.0f, clientArea.size.width, topBarSize.height);
	topBar = [[UINavigationBar alloc] initWithFrame:topBarRect];
	[topBar setBarStyle:3];
	topBarTitle = [[UINavigationItem alloc] initWithTitle: NSLocalizedStringFromTable(@"Conversation",@"iSMS",@"")];
	[topBar pushNavigationItem:topBarTitle];
	[topBar showButtonsWithLeftTitle:NSLocalizedStringFromTable(@"Messages",@"iSMS",@"") rightTitle:NSLocalizedStringFromTable(@"Clear",@"iSMS",@"") leftBack:YES];
	[topBar enableAnimation];
	[topBar setDelegate:self];
	[self addSubview:topBar];
	
	y+=topBarSize.height;
#ifdef __BUILD_FOR_2_0__
	CGSize kbSize = [[UIKeyboardImpl sharedInstance] defaultSize];
#else
	CGSize kbSize = [UIKeyboard defaultSize];
#endif
	CGRect tableRect = CGRectMake(0.0f,y,clientArea.size.width,160 + kbSize.height);
	table = [[UITable alloc]initWithFrame:tableRect];	
	UITableColumn *col = [[UITableColumn alloc] initWithTitle: @"conversation" identifier:@"col0" width:clientArea.size.width ];
	[table addTableColumn: col];
	[table setSeparatorStyle: 3];
//	[table setRowHeight:75.];
	[table setReusesTableCells:YES];
	[table setShowScrollerIndicators:YES];

	[table setDataSource:self];
	[table setDelegate:self];

	[self addSubview:table];
	
	QXGestureMaskView *gestureView = [[QXGestureMaskView alloc] initWithFrame: tableRect andScroller: table];
	[gestureView setTapDelegate:self];
	[self addSubview: gestureView];
	[gestureView release];
	
	// The input area
	y+=tableRect.size.height;
	inputBar = [[UIView alloc]initWithFrame:CGRectMake(0,y,clientArea.size.width, 40.0f)];
//	struct CGColor *bgColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), bgColorData);
//	[inputBar setBackgroundColor:bgColor];
	input = [[BubbleInputField /*UITextField*/ alloc] initWithFrame:CGRectMake(5.0f,8.0f,clientArea.size.width - 10.0f, 26.0f)];

#ifdef __BUILD_FOR_2_0__
	UIFont * font = [UIFont systemFontOfSize:16];
#else
	struct __GSFont * font=[NSClassFromString(@"WebFontCache") createFontWithFamily:@"Helvetica" traits:0 size:16.];
#endif

	[input setFont:font];
	[input setPaddingTop:5.0f];
	[input setPaddingLeft:10.0f];
	[input setPaddingRight:10.0f];
	[input setPaddingBottom:4.0f];
	//[input becomeFirstResponder];
	
#ifdef __BUILD_FOR_2_0__
	[input setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	[input setEnablesReturnKeyAutomatically:YES];
#else
	[input setAutoCapsType:0];
	[input setAutoEnablesReturnKey:YES];
#endif

	[input setReturnKeyType:7];
	[input setDelegate:self];
#ifdef __BUILD_FOR_2_0__
#else
	[input setEditingDelegate:self];
#endif
	[inputBar addSubview:input];
	[self addSubview:inputBar];
	
	y+=40.0f;
	DBG(@"After input setup, y is %f",y);

#ifdef __BUILD_FOR_2_0__
#else
	// Add keyboard
	//[UIKeyboard initImplementationNow];
	//CGRect rect = CGRectMake(0.0f, 460.0f - 215.f, 320.0f, 215.0f );
	CGRect kbRect = CGRectMake(0.0f, y/*460.0f - kbSize.height*/, kbSize.width, kbSize.height);
	keyboard = [[UIKeyboard alloc] initWithFrame:kbRect];
	[keyboard deactivate];
	[self addSubview:keyboard];
#endif
	
}

//TODO active/deactive when animation is done
-(void)showKeyboard:(BOOL)show{
	CGRect tableRect = [table frame];
	CGRect inputBarRect = [inputBar frame];
#ifdef __BUILD_FOR_2_0__
	float kbHeight = [[UIKeyboardImpl sharedInstance] defaultSize].height;
#else
	CGRect kbRect = [keyboard frame];
	float kbHeight = kbRect.size.height;
#endif
	NSString *aniName;
	if(show){
		tableRect.size.height -= kbHeight;
		inputBarRect.origin.y-=kbHeight;
#ifdef __BUILD_FOR_2_0__
#else
		kbRect.origin.y-=kbHeight;
#endif
		aniName = @"kbSlideUp";
	}else{
#ifdef __BUILD_FOR_2_0__
#else
		[keyboard deactivate];
#endif
		tableRect.size.height += kbHeight;
		inputBarRect.origin.y += kbHeight;
#ifdef __BUILD_FOR_2_0__
#else
		kbRect.origin.y+=kbHeight;
#endif
		aniName = @"kbSlideDown";
	}

	[UIView beginAnimations:aniName];
	[UIView setAnimationDuration:0.3f];
	if(show){
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(didFinishUpTransition)];	
	}
	[table setFrame:tableRect];
	[inputBar setFrame:inputBarRect];
#ifdef __BUILD_FOR_2_0__
#else
	[keyboard setFrame:kbRect];
#endif
	[UIView endAnimations];
}

-(void)didFinishUpTransition{
	[table showLastRow];
#ifdef __BUILD_FOR_2_0__
#else
	[keyboard setNeedsDisplay];
	[keyboard activate];
#endif
}

//==============================================================================
// UIView tap delegate methods
//==============================================================================
-(void)view:(UIView*) aView handleTapWithCount:(int) count event:(id)aEvent{
	DBG(@"Tap on view %@ with count %d with event %@",aView,count,aEvent);
	[input resignFirstResponder];	
}

//==============================================================================
// UINavigationBar delegate methods
//==============================================================================
-(void)navigationBar:(UINavigationBar*)bar buttonClicked:(int)button {
	DBG(@"navBar %@ button %d tapped",bar,button);
	if(button == 0){
		// Refresh ?
		//[self reloadData];
		if(clearConversationAlert == nil){
			NSArray *buttons = [NSArray arrayWithObjects:
				NSLocalizedStringFromTable(@"Clear Conversation",@"iSMS",@""), 
				NSLocalizedStringFromTable(@"Cancel",@"iSMS",@""),
				nil];
#ifdef __BUILD_FOR_2_0__
			clearConversationAlert = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:[buttons objectAtIndex:1]
                                                                        destructiveButtonTitle:[buttons objectAtIndex:0] otherButtonTitles:nil];
		}
		[clearConversationAlert showInView:self];
#else
			clearConversationAlert = [[UIAlertSheet alloc] initWithTitle:@"" buttons:buttons defaultButtonIndex:1 delegate:self context:nil];
			[clearConversationAlert setDestructiveButton:[[clearConversationAlert buttons] objectAtIndex:0]];
			//[clearConversationAlert setAlertSheetStyle:2];
			//UIAlertSheet *alertSheet = [[UIModalAlertSheet alloc] initWithTitle:@"" buttons:buttons defaultButtonIndex:3];
			//[saveAlert setBodyText:NSLocalizedStringFromTable(@"UNSAVED_MESSAGE_CONFIRMATION",@"iSMS",@"")];
		}
		[clearConversationAlert presentSheetFromAboveView:self];
#endif
	}else if (button == 1) {
		// Clear the input text, then switch back to previous view
		[input setText:@""];
		[[UIController defaultController] switchBackFrom:self];
	}
}

#ifdef __BUILD_FOR_2_0__
-(void) actionSheet:(UIActionSheet *)sheet clickedButtonAtIndex:(NSInteger)button
{
        [sheet dismissWithClickedButtonIndex:button animated:YES];
#else
-(void)alertSheet:(UIAlertSheet*)sheet buttonClicked:(int)button {
	[sheet dismiss];
#endif
	if(sheet == clearConversationAlert){
		switch(button){
			case 1:{
				[modelData clear];
				[self reloadData];
				//DBG(@"Clear conversation");
				break;
			}case 2:{
				DBG(@"Canceled");
				break;
			}
		}
	}
}

//==============================================================================
// Text input field delegate methods
//==============================================================================
#ifdef __BUILD_FOR_2_0__
-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)aText
{
#else
- (BOOL) keyboardInput:(UIFieldEditor*) editor shouldInsertText:(NSString *) aText isMarkedText:(BOOL) marked {
#endif
	if([aText length] == 1 && [aText characterAtIndex:0] == '\n') {
		DBG(@"Send button pressed");
		[self sendMessage];
		return NO;
	}
	return YES;
}

#ifdef __BUILD_FOR_2_0__
#else
- (int) keyboardInput:(UIFieldEditor*) editor positionForAutocorrection:(id) autoCorrection {
	return 1;
}
#endif

-(void) textFieldDidBecomeFirstResponder:(id)something{
	// Show the keyboard
	[self showKeyboard:YES];
}

-(void) textFieldDidResignFirstResponder:(id)something{
	// Hide the keyboard
	[self showKeyboard:NO];
}


//==============================================================================
// Table delegate protocol
//==============================================================================
-(UITableCell*)_createCellAtIndex:(int)idx preload:(int)preloadSize{
	int cellCount = [cells count];
	id null = [NSNull null];
	UITableCell *result = nil;
	DBG(@"Trying to loading %d cells since cell[%d]",preloadSize,idx);
	for(int i = 0;i<preloadSize && idx < cellCount;i++){
		if([cells objectAtIndex:idx] == null){
			Message	*msg = [modelData messageAtIndex:idx];
			if(![msg hasBeenRead]){
				[msg markAsRead:YES];
			}
			BalloonCell *aCell = [[BalloonCell alloc]initWithText:[msg text] direction:[msg isOutgoing]];
			[cells replaceObjectAtIndex:idx withObject:aCell];
			[aCell release];
			// The result we'd like to return back
			if(!result){
				result = [cells objectAtIndex:idx];
			}
		}
		idx++;
	}
	return result;
}

-(UITableCell*)_cellAtIndex:(int)idx{
	if(idx < 0 || idx >=[cells count]){
		WARN(@"Invalid cell index %d",idx);
		return nil;
	}
	id obj = [cells objectAtIndex:idx];
	if(obj == [NSNull null]){
		/*
		DBG(@"Creating Cell[%d]",idx);
		Message	*msg = [modelData messageAtIndex:idx];
		BalloonCell *aCell = [[BalloonCell alloc]initWithText:[msg text] direction:[msg isOutgoing]];
		//UIImageAndTextTableCell *aCell = [[UIImageAndTextTableCell alloc]init];
		//[aCell setTitle:[msg text]];
		//[aCell setTitle:@"Cell"];
		//[aCell setText:[msg text] send:[msg isOutgoing]];
		[cells replaceObjectAtIndex:idx withObject:aCell];
		[aCell release];
		obj = aCell;
		*/
		obj = [self _createCellAtIndex:idx preload:2];
	}
//	UITableCell aCell = (UITableCell*)obj;
	//DBG(@"Cell %@ loaded",obj);
	return obj;
}

- (int) numberOfRowsInTable:(UITable *)table{
	return [cells count];
	//return 10;
}

- (UITableCell*) table:(UITable*)atable cellForRow:(int)row column:(int)column reusing:(BOOL)reusing{
	DBG(@"Request cell[%d], reusing: %d",row,reusing);
	//Message *aMsg = [modelData messageAtIndex:row];
	//TODO build table cell and return
	//UIImageAndTextTableCell *aCell = [[UIImageAndTextTableCell alloc]init];
//	BalloonCell *aCell = [[BalloonCell alloc]init];
//	//[aCell setTitle:@"Cell"];
//	[aCell setText:@"Cell :)" send:NO];
//	return [aCell autorelease];
	
	//[ setNeedsDisplay];
	UITableCell *aCell = [self _cellAtIndex:row];
	//[aCell setNeedsDisplay];
	return aCell;
}

- (UITableCell*) table:(UITable*)atable cellForRow:(int)row column:(int)column{
	return [self table:atable cellForRow:row column:column reusing:NO];
}

- (void)tableRowSelected:(NSNotification *)notification {
	//[controller categorySelected:[self _categoryAtRow:[table selectedRow]] sender:self];
}

- (BOOL)tableView:(UITable *)table shouldSelectRow:(int)row {
	return NO;
}

- (float) table:(UITable *)table heightForRow:(int)row {
	float height = 0.0f;

//	DBG(@"BalloonClass type: %d", [[cells objectAtIndex: row] isKindOfClass:[BalloonCell class]]);
//	
	UITableCell *cell =  [self _cellAtIndex:row];//[cells objectAtIndex: row];
	if(cell){
		if([ cell isKindOfClass:[BalloonCell class]]) {
			height = [(BalloonCell*)cell height] - 5.0f;
		} else{
			// For the timestamp cell
			height = 25.0f;
		}		
	}

	DBG(@"heightForRow: %d is %f", row,height);
	return height;
}

-(void)setConversationModel:(ISMSConversationModel*)aData{
	RETAIN(modelData,aData);
}

-(NSString*)conversationPhoneNumber{
	return [modelData phoneNumber];
}

-(void)setConversationName:(NSString*)aName phoneNumber:(NSString*)aNumber{
	// setup the title ?
	[topBarTitle setTitle:[NSString stringWithFormat:@"%@",aName]];
	ISMSConversationModel *aModel = [ISMSConversationModel load:aNumber];
	[self setConversationModel:aModel];
}

-(void)setConversationPhoneNumber:(NSString*)aNumber{
	SMSComposeRecipient *rcpt = [SMSComposeRecipient recipientWithAddress:aNumber];
	NSString *buddyName = [rcpt displayString];
	[self setConversationName:buddyName phoneNumber:aNumber];
}

-(void)clearAllData{
	NSMutableArray *emptyCells = [[NSMutableArray alloc]init];
	int mc = [modelData messageCount];
	for(int i = 0;i < mc;i++){
		[emptyCells addObject:[NSNull null]];
	}
	RETAIN(cells,emptyCells);
	[table clearAllData];
}

-(void)reloadData{
	if(reloadingData){
		return;
	}
	reloadingData = YES;
	[self clearAllData];
	
	[table reloadData];
	
	[table showLastRow];
//	int rows = [table numberOfRows];
//	if(rows>0){
//		[table scrollRowToVisible: rows-1];
//		//[table scrollAndCenterTableCell:[table cellAtRow:rows-1 column:0] animated:YES];
//	}
	reloadingData = NO;
}

//-(void)_rebuildCells{
//	LOG(@"Rebuilding cells");
//	NSArray *msgs = [modelData messages];
//	NSMutableArray *newCells = [[NSMutableArray alloc]init];
//	for(int i = 0;i <[msgs count];i++){
//		Message	*msg = [msgs objectAtIndex:i];
//		BalloonCell *aCell = [[BalloonCell alloc]init];
//		//[aCell setTitle:@"Cell"];
//		[aCell setText:[msg text] send:[msg isOutgoing]];
//		[newCells addObject:aCell];
//		[aCell release];
//	}
//	RETAIN(cells,newCells);
//}

//==============================================================================
// Controller callback methods
//==============================================================================
-(BOOL)willShow:(NSDictionary*)dict{
	if(!modelData){
		WARN(@"No data to display!");
		return NO;
	}
	[self reloadData];
	
	//[table setNeedsDisplay];
	//[self setNeedsDisplay];
	return YES;
}

-(void)didShow:(NSDictionary*)param{
	
}

-(void)sendMessage{
	NSString *smsText = [input text];
	if(!smsText || [smsText length] == 0){
		WARN(@"Message text is nil, sendMessage() aborted!");
		return;
	}
	
	NSMutableArray* rcpts = [[NSMutableArray alloc] init];
	SMSComposeRecipient *rcpt = [SMSComposeRecipient recipientWithAddress:[modelData phoneNumber]];
	DBG(@"Rcpt is: %@,%@",[rcpt displayString],[rcpt address]);
	[rcpts addObject:rcpt];
	
	// well, let's go
	if(!progressViewController){
		progressViewController = [[ISMSProgressViewController alloc]initWithNibName:nil bundle:nil];
	}
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_messageSent:) name:PROGRESS_FINISHED_NOTIFICATION object:nil];
	SMSCenter *smsSendController = [SMSCenter getInstance];
	DBG(@"Will send message %@ to %@",smsText,rcpts);
	[smsSendController setSendTask:smsText to:rcpts statusCallback:(SMSSendStatusCallback*)progressViewController];
	
	[[[ISMSComposeViewController sharedInstance]navigationController] presentModalViewController:progressViewController animated:NO];
	//[progressView showFrom:self]; //[smsSendController send]; will be called in progress view when the animation is done.
}
	
- (void) _messageSent:(NSNotification *) notification {
	//TODO get the new message from notification
	DBG(@"Message sent! %@",[notification userInfo]);
	
	//unregister the progress notification listener.
	[[NSNotificationCenter defaultCenter] removeObserver:self name:PROGRESS_FINISHED_NOTIFICATION object:nil];
	
	//dismiss the progress view
	[[[ISMSComposeViewController sharedInstance]navigationController] dismissModalViewControllerAnimated:NO];
	
	//TODO broadcast MESSAGE_ADDED change notification
	id _notifyType = [NSNumber numberWithInt:MESSAGE_CHANGED];
	NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
			_notifyType,@"type",
			nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_CHANGE_NOTIFICATION object:self userInfo:userInfo];

	[input setText:@""];
	[self reloadData];

	/*	
	// Notify message update

	// Check the notification data
	NSArray* failedList = [[notification userInfo] retain];
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
		[[UIController defaultController] switchBackFrom:self];
	} else {
		//TODO enumerate the failed rcpt list
		if(sendFailedAlert == nil){
			sendFailedAlert = [[UIAlertSheet alloc] initWithFrame:CGRectMake(0,240,320,240)];
			[sendFailedAlert addButtonWithTitle:NSLocalizedStringFromTable(@"OK",@"iSMS",@"")];
			[sendFailedAlert setDelegate: self];
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
		[sendFailedAlert setBodyText:badMess];
		[sendFailedAlert popupAlertAnimated:YES];
		//Note we'll switch back in the alertSheet callback
	}
	
	[failedList release];
*/
}

#ifdef DEBUG
-(BOOL)respondsToSelector:(SEL)sel {
  BOOL rts = [super respondsToSelector:sel];
  LOG(@"%@ respondsToSelector \"%@\" (%d)\n",[self class],NSStringFromSelector(sel), rts);
  return rts;
}
#endif

@end


/***************************************************************
 * Class Comments
 * 
 * @Author Shawn
 ***************************************************************/
@implementation BubbleInputField : UITextField
- (id) initWithFrame:(CGRect) frame {
	[super initWithFrame:frame];
	//bgImage = [[UIImage applicationImageNamed:@"bubble_input_field_bg.png"] retain];
	DBG(@"BubbleInputField initWithFrame()");
	return self;
}

-(void)dealloc{
	//RELEASE(bgImage);
	[super dealloc];
}

- (void) setFrame: (CGRect) rect {
	[super setFrame:rect];
	DBG(@"BubbleInputField setFrame()");
	[self setNeedsDisplay];
}

- (void) drawRect:(CGRect) rect {
	DBG(@"BubbleInputField drawRect()");

	UIImage *bgImage = [[UIImage applicationImageNamed:@"bubble_input_field_bg.png"] retain];
	
	DBG(@"Drawing rect %f,%f,%f,%f",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
	CGRect left = CGRectMake(0.0f,		0.0f,	13.0f,	12.0f);
	CGRect middle = CGRectMake(13.0f,	0.0f,	1.0f,	12.0f);
	CGRect right = CGRectMake(14.0f,	0.0f,	13.0f,	12.0f);
	// CDAnonymousStruct4 top = {left, middle, right};
	
	CGRect m_left = CGRectMake(0.0f,	12.0f,	13.0f,	2.0f);
	CGRect m_middle = CGRectMake(13.0f,	12.0f,	1.0f,	2.0f);
	CGRect m_right = CGRectMake(14.0f,	12.0f,	13.0f,	2.0f);
	
	CGRect b_left = CGRectMake(0.0f,	14.0f,	13.0f,	12.0f);
	CGRect b_middle = CGRectMake(13.0f, 14.0f,	1.0f,	12.0f);
	CGRect b_right = CGRectMake(14.0f,	14.0f,	13.0f,	12.0f);
	
#ifdef __BUILD_FOR_2_0__
	CDAnonymousStruct13 slices = 
                           {{left, middle, right}, {m_left, m_middle, m_right}, {b_left, b_middle, b_right}};
#else
	CDAnonymousStruct11 slices = 
                           {{left, middle, right}, {m_left, m_middle, m_right}, {b_left, b_middle, b_right}};
#endif

	[bgImage draw9PartImageWithSliceRects:slices inRect:[self bounds]];

	[super drawRect:rect];
}
@end
