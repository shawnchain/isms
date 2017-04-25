//==============================================================================
//	Created on 2007-12-6
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
#import "UIMessageSearchView.h"
#import <WebCore/WebFontCache.h>
#import <GraphicsServices/GraphicsServices.h>
#import "UIMainView.h"
#import <UIKit/UIFrameAnimation.h>
#import <UIKit/UIFieldEditor.h>
#import "Message.h"
#import "UIMessageView.h"
#import "UIController.h"
#import "iSMSApp.h"
#import "Log.h"


#ifdef __BUILD_FOR_2_0__
#import <UIKit/UIView-Hierarchy.h>
#import <UIKit/UIView-Rendering.h>
#import <UIKit/UINavigationItem.h>
#import <UIKit/UITableColumn.h>
#endif

/***************************************************************
 * Search Field Class
 * 
 * @Author Shawn
 ***************************************************************/
@implementation UIMessageSearchField
- (void)fieldEditorDidBecomeFirstResponder: (id) editor{
	[super fieldEditorDidBecomeFirstResponder:editor];
	[[UIMessageSearchView sharedInstance] searchBarDidBecomeFirstResponder:editor];
}

- (void)fieldEditorDidResignFirstResponder: (id) editor{
	[super fieldEditorDidResignFirstResponder:editor];
	[[UIMessageSearchView sharedInstance] searchBarDidResignFirstResponder:editor];
}

@end


/***************************************************************
 * View Class
 * 
 * @Author Shawn
 ***************************************************************/
#define SEARCH_MESSAGE NSLocalizedStringFromTable(@"Type here to search message",@"iSMS",@"")

@implementation UIMessageSearchView

+(UIMessageSearchView*)sharedInstance{
	return (UIMessageSearchView*)[[iSMSApp getInstance]getViewForName:@"UIMessageSearchView"];
}

#ifdef __BUILD_FOR_2_0__
-(void) showKeyboard:(BOOL)show
{
        [maskView setBackgroundColor:(show ? [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5] : [UIColor colorWithRed:0 green:0 blue:0 alpha:0])];
}
#else
-(void)showKeyboard:(BOOL)show{
	CGRect kbRect = [keyboard frame];
	
	float kbHeight = kbRect.size.height;
	NSString *aniName;
	
	
	struct CGColor *maskBGColor;

	if(show){
		kbRect.origin.y-=kbHeight;
		aniName = @"kbSlideUp";
		//[[UIMainView sharedInstance] addSubview:maskView];
		[self insertSubview:maskView below:topBar];
		//[self bringSubviewToFront:searchBar];
		[[UIMainView sharedInstance] addSubview:keyboard];
		
		float c2[4] = {0., 0., 0., 0.5f};
		maskBGColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), c2);
	}else{
		[keyboard deactivate];
		kbRect.origin.y+=kbHeight;
		aniName = @"kbSlideDown";
		float c2[4] = {0., 0., 0., 0.};
		maskBGColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), c2);
	}

	[UIView beginAnimations:aniName];
	[UIView setAnimationDuration:0.3f];
	[UIView setAnimationDelegate:self];
	if(show){
		[UIView setAnimationDidStopSelector:@selector(didFinishUpTransition)];	
	}else{
		[UIView setAnimationDidStopSelector:@selector(didFinishDownTransition)];	
	}
	[keyboard setFrame:kbRect];
	[maskView setBackgroundColor:maskBGColor];
	//FIXME change the mask view transparent
	[UIView endAnimations];
}
#endif

#ifdef __BUILD_FOR_2_0__
#else
-(void)didFinishDownTransition{
	[keyboard removeFromSuperview];
	[maskView removeFromSuperview];
}

-(void)didFinishUpTransition{
	[keyboard setNeedsDisplay];
	[keyboard activate];
}
#endif


- (void)searchBarDidBecomeFirstResponder:(id)textField {
	//TODO iPhone does not support text selection ?
//	NSString* s = [searchBar text];
//	if(s && [s length] > 0){
//		struct _NSRange range = NSMakeRange (0, [s length]);
//		//struct _NSRange range = [searchBar selectionRange];
//		[searchBar setSelectionRange:range];
//	}
	//[searchBar setPlaceholder:nil];
	//[self setKeyboardVisible:YES];
	[self showKeyboard:YES];
}

- (void)searchBarDidResignFirstResponder:(id)textField {
	//[searchBar setPlaceholder:SEARCH_MESSAGE];
	[self showKeyboard:NO];
}

// Callback from mask view
-(void)view:(UIView*) aView handleTapWithCount:(int) count event:(id)aEvent{
	[searchBar resignFirstResponder];
}

-(id)initWithFrame:(struct CGRect)frame{
	LOG(@"UIMessageMainView:initWithFrame()");
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

	CGRect _rect = CGRectMake(30.0f, ([UINavigationBar defaultSize].height - [UISearchField defaultHeight]) / 2., frame.size.width - 60., [UISearchField defaultHeight]);
	searchBar = [[UIMessageSearchField alloc] initWithFrame:_rect];
#ifdef __BUILD_FOR_2_0__
	[searchBar setFont:[UIFont systemFontOfSize:16]];
#else
	struct __GSFont * font=[NSClassFromString(@"WebFontCache") createFontWithFamily:@"Helvetica" traits:2 size:16.];
	[searchBar setFont:font];
#endif
	[searchBar setClearButtonStyle:2];
	[searchBar setPaddingLeft:8.0f];
	[searchBar setPaddingTop:6.0f];
//	[searchBar setTextCentersVertically:YES];	
#ifdef __BUILD_FOR_2_0__
	[searchBar setReturnKeyType:6];
	[searchBar setDelegate:self];
#else
	[[searchBar textTraits] setReturnKeyType:6];
	[[searchBar textTraits] setEditingDelegate:self];
	[[searchBar textTraits] setTextLoupeVisibility:3]; // Show text loupe in middle
#endif
	[searchBar setPlaceholder:SEARCH_MESSAGE];
#ifdef __BUILD_FOR_2_0__
#else
	[searchBar setDisplayEnabled:YES];
#endif
		
	topBar = [[UINavigationBar alloc] init];
	[topBar setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width,UI_TOP_NAVIGATION_BAR_HEIGHT)]; //[UINavigationBar defaultSize].height
	[topBar setBarStyle:3];
	[topBar pushNavigationItem: [[[UINavigationItem alloc] init/*initWithTitle: @"Search"*/] autorelease]];
	[topBar enableAnimation];
	[topBar setDelegate:self];
	[topBar addSubview:searchBar];
	[self addSubview:topBar];
	DBG(@"topBar done!");
	
	int y = UI_TOP_NAVIGATION_BAR_HEIGHT;
	table = [[UIMessageListTable alloc] initWithFrame: CGRectMake(0.0f, y, frame.size.width, frame.size.height-y)];
	UITableColumn *col = [[UITableColumn alloc] initWithTitle: @"" identifier:@"col0" width: frame.size.width];
	[table addTableColumn: col];
	[table setSeparatorStyle: 1];
	[table setRowHeight:60.];

	[table setShowScrollerIndicators:YES];
	[table setAllowSelectionDuringRowDeletion:NO];
	[table setReusesTableCells:YES];
	[table setCanHandleSwipes:NO];

	[table setDelegate:self]; // handle selection
	[table setDataSource:self];// provide cell
	
	[table reloadData];
	[self insertSubview:table below:topBar];
	//[self addSubview: table];
	DBG(@"table done!");
	
#ifdef __BUILD_FOR_2_0__
#else
	// Display the keyboard out of the screen, deactivated.
	y = frame.size.height;
	CGSize kbSize = [UIKeyboard defaultSize];
	CGRect kbRect = CGRectMake(0.0f, 460.0f/*460.0f*/, kbSize.width, kbSize.height);
	keyboard = [[UIKeyboard alloc] initWithFrame:kbRect];
	[keyboard deactivate];
	//[self addSubview:keyboard];
#endif
	
	//Initialize the mask view
	maskView = [[UIView alloc]initWithFrame:CGRectMake(0,UI_TOP_NAVIGATION_BAR_HEIGHT,320,460 - UI_TOP_NAVIGATION_BAR_HEIGHT)];
	float c2[4] = {0., 0., 0., 0.};
	struct CGColor *maskBGColor = CGColorCreate(colorSpace, c2);
#ifdef __BUILD_FOR_2_0__
	[maskView setBackgroundColor:[UIColor colorWithCGColor:maskBGColor]];
#else
	[maskView setBackgroundColor:maskBGColor];
#endif
	CGColorRelease(maskBGColor);

        CGColorSpaceRelease(colorSpace);

	[maskView setTapDelegate:self];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_messageChanged:) name:MESSAGE_CHANGE_NOTIFICATION object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppResumed:) name:APP_RESUMED object:nil];
	return self;
}

#ifdef __BUILD_FOR_2_0__
-(BOOL) textField:(id)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
        if ([string length] == 1 && [string characterAtIndex:0] == '\n') {
           [searchBar resignFirstResponder];
           [table clearAllData];
           [table reloadData];
           return NO;
        }

        return YES;
}
#else
//===========================================================================
// Keyboard input callback
//===========================================================================
- (BOOL)keyboardInput:(id)editor shouldInsertText:(NSString*)text isMarkedText:(BOOL)marked {
	if ([text length] == 1 && [text characterAtIndex:0] == '\n') {
		[searchBar resignFirstResponder];
		[table clearAllData];
		[table reloadData];
//		[self appendText:[NSString stringWithFormat:@"-> %@", [textField text]]];
//		[socket sendString:[NSString stringWithFormat:@"%@\r\n", [textField text]]];
//		[textField setText:@""];
		return NO;
	}
	return YES;
}

- (int) keyboardInput:(UIFieldEditor*) editor positionForAutocorrection:(id) autoCorrection {
	return 0;
}

- (int) keyboardInput:(UIFieldEditor*) editor positionForTextLoupe:(id) a {
	return 0;
}
#endif

//
//-(BOOL)respondsToSelector:(SEL)sel {
//  BOOL rts = [super respondsToSelector:sel];
//  NSLog(@"!!! %@ respondsToSelector \"%@\" (%d)\n",[self class],NSStringFromSelector(sel), rts);
//  return rts;
//}


// If message is deleted or saved, update the list
- (void) _messageChanged:(NSNotification *) notification{
	dataIsStale = YES;
}

//- (void)tableRowSelected:(NSNotification *)notification{
//	
//}
//
//- (int)numberOfRowsInTable:(UITable *)table {
//	return 0;
//}
//
//- (UITableCell *)table:(UITable *)atable cellForRow:(int)arow column:(int)acol {
//	return [[[UITableCell alloc] init] autorelease];
//}

-(void) messageSelected:(Message*)selectedMessage atRow:(int)row{
	//TODO switch to the message detail view...
	if(selectedMessage){
		//FIXME use controller 
		UIMessageView *msgView = (UIMessageView*)[[iSMSApp getInstance]getViewForName:@"UIMessageView"];
		if(msgView){
			[msgView resetAllState];
			[msgView setMessageList:[table messageList]];
			[msgView setCurrentMessageIndex:row];
			UIController* controller = [UIController defaultController];
			[controller switchToView:msgView from:nil withStyle:UITransitionShiftLeft];			
		}else{
			LOG(@"ERROR - UIMessageView is not initialized");
		}
	}
}
-(BOOL) canDeleteMessage:(Message*)msg atRow:(int)row{
	return NO;
}

-(void) didDeleteMessage:(Message*)msg atRow:(int)row{
	
}

-(NSArray*) getMessageList{
	NSString* s = [searchBar text];
	if(s && [s length] > 0){
		// start the search
		return [Message search:s];
	}else{
		return nil;	
	}
}

-(BOOL)willShow:(NSDictionary*) param{
	LOG(@"UIMessageSearchView - willShow()");
	// Clear the table selection
	[table clearRowSelection:NO];
	// If data is changed, reload data
	if(dataIsStale){
		[table reloadData];
		dataIsStale = NO;
	}
	return YES;
}

-(void) onAppResumed:(NSNotification*)aNotify{
	LOG(@"Application resumed, refreshing view");
#ifdef __BUILD_FOR_2_0__
#else
	if(keyboard){
		[keyboard setNeedsDisplay];
		[keyboard activate];
	}
#endif	
//	if(searchBar){
//		[searchBar becomeFirstResponder];
//		[searchBar setNeedsDisplay];
//	}
//	[self setNeedsDisplay];
}

-(BOOL)willHide:(NSDictionary*) param{
	LOG(@"UIMessageSearchView - willHide()");
	return YES;
}

-(void)dealloc{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	RELEASE(topBar);
	RELEASE(searchBar);
	RELEASE(table);
#ifdef __BUILD_FOR_2_0__
#else
	RELEASE(keyboard);
#endif
	RELEASE(maskView);
	[super dealloc];
}

@end
