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

#import "UISwipeAwareTable.h"
#import "Prefix.h"
#import <UIKit/UIKit.h>
#import <GraphicsServices/GraphicsServices.h>
#include "Log.h"

#define DEFAULT_TABLE_ROW_HEIGHT 60.0f

/**
 * Implementation of UISwipeAwareTable
 * 
 * 
 * @Author Shawn
 *
 */
@implementation UISwipeAwareTable

- (id)initWithFrame:(CGRect)rect{
	[super initWithFrame:rect];
	canHandleSwipes = YES;
	return self;
}
//-(id)initWithFrame:(CGRect) rect withTitle:(NSString*) aTitle withRowHeight:(float) aRowHeight{
//	self = [super initWithFrame: rect];
//	if(self == nil){
//		return nil;
//	}
//	
//	// Setup default style
//	UITableColumn *col = [[UITableColumn alloc]
//	initWithTitle: aTitle
//	identifier:aTitle
//	width: rect.size.width
//	];
//	[self addTableColumn: col];
//	[self setSeparatorStyle: 1];
//	[self setRowHeight:aRowHeight];
//	// Enable deletion
//	[self enableRowDeletion: YES animated: YES];
//	[self setShowScrollerIndicators:YES];
//	[self setAllowSelectionDuringRowDeletion:NO];
//
//	LOG(@"table:initWithFrame() table initialized ok");
//	return self;
//}
//
//-(id)initWithFrame:(CGRect) rect {
//	return [self initWithFrame:rect withTitle:@"messageList" withRowHeight:DEFAULT_TABLE_ROW_HEIGHT];
//}


-(void)clearAllData {
	[super clearAllData];
	// clear the selected row
	_selectedRow = -1;
}

- (BOOL)canHandleSwipes{
	//DBG(@"%@ can handle swipes %d",self,canHandleSwipes & 0xfff0);
	return canHandleSwipes;
}

-(void)setCanHandleSwipes:(BOOL)flag{
	canHandleSwipes = flag;
}

//slide-to-remove event handler
#ifdef __BUILD_FOR_2_0__
#else
- (int)__swipe:(int)direction withEvent:(struct __GSEvent *)event;
{
	BOOL isDelete = NO;
	int row;
	// We only handle swipe when table is in normal mode.
	// in deletion mode, we do not need to handle the swipe information
	if ((direction == kSwipeDirectionRight) || (direction == kSwipeDirectionLeft) ) {
		CGPoint point = GSEventGetLocationInWindow(event).origin;
		// subtract the titleNavBar height from rect.origin.y
		point.y-=UI_TOP_NAVIGATION_BAR_HEIGHT;
		CGPoint offset = _startOffset;
		point.x += offset.x;
		point.y += offset.y;

		//row = [self rowAtPoint:[self convertPoint:point fromView:nil]];
		row = [self rowAtPoint:point];
		float maxY = [self rowHeight] * (float)(row + 1);
		if(point.y < maxY) {
			LOG(@"MessageListTable:swipe() - User swiped on row [%d], location: x=%f,y=%f",row,point.x,point.y);

			UITableCell* cell = [self visibleCellForRow:row column:0];
			if(![self isRowDeletionEnabled] && ![cell isRemoveControlVisible]) {
				//Show the remove control
				[cell _showDeleteOrInsertion:YES withDisclosure:NO animated:YES isDelete:YES andRemoveConfirmation:YES];
				isDelete = YES;
			} else if( ![self isRowDeletionEnabled] && [cell isRemoveControlVisible]) {
				//remove controll is visible but table is not under deletion mode,
				// so just hide the remove control
				[cell _showDeleteOrInsertion:NO withDisclosure:YES animated:YES isDelete:NO andRemoveConfirmation:NO];
			}
		} else {
			LOG(@"MessageListTable:swipt() - User swipped, but in incorrect position: x=%f,y=%f. It exceeds the maxY=%f, where should no corresponding row there",point.x,point.y,maxY);
		}
	}

	int result = [super swipe:direction withEvent:event];
	//	
	//	// Call the delegate's callback method notifying we're now under delete mode
	//	if(isDelete){
	//		[_delegate table:self willSwipeToDeleteRow:row];
	//	}
	//-(void)table: (UITable *)table willSwipeToDeleteRow:(int)row 
	return result;
}
#endif

// - (void) mouseDown:(struct __GSEvent *)event {
// - (id) hitTest:(struct CGPoint)point forEvent:(struct __GSEvent *)event{
// - (void) contentMouseUpInView:(id)view withEvent:(struct __GSEvent *)event{
// - (void) _userSelectRow:(int)rowId{
// - (void) removeControlWillHideRemoveConfirmation:(id)fp8 {

//- (void) animateDeletionOfRowWithCell:(id)cell {
//	LOG(@"table.animateDeletionOfRowWithCell() - Cell 0x%x will be deleted",cell);
//	[super animateDeletionOfRowWithCell:cell];
//}
//
////FIXME never be called ?
//- (void) animateDeletionOfCellAtRow:(int)rowId column:(int)colId viaEdge:(int)edgeId {
//	LOG(@"table.animateDeletionOfCellAtRow() - Cell %d at Column %d will be deleted",rowId,colId);
//	[super animateDeletionOfCellAtRow:rowId column:colId viaEdge:edgeId];
//}

//- (void)dealloc {
//	[super dealloc];
//}

@end
