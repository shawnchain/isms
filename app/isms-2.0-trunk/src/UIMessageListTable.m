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
#import "UIMessageListTable.h"
#import "UIMessageTableCell.h"
#import "Log.h"

@implementation UIMessageListTable

- (id)initWithFrame:(struct CGRect)frame {
	LOG(@"UIMessageListTable:initWithFrame");
	self = [super initWithFrame:frame];
	if(!self){
		return nil;
	}
	
	messageList = nil;
	cachedCellList = nil;
	showMessageDirection = YES;
	canHandleSwipes = YES;
	
	[super setDelegate:self];
	[super setDataSource:self];
	//[self setReusesTableCells:YES];
	
	// Reload data will really load the messages from db
	//[self reloadData];
	return self;
}

static id PLACE_HOLDER = @"";

-(NSArray*)getMessageListFromDataSource{
	if(dataSource /*&& [(id)dataSource respondsToSelector:@selector(getMessageList)]*/){
		NSArray* result = [dataSource getMessageList];
		if(result != nil){
			return result;
		}
	}
	
	// Return empty array
	return [NSArray array];
}

-(NSArray*) messageList{
	return messageList;
}

-(void)reloadData{
	LOG(@">>> Reloading table data");
	RETAIN(messageList,/*[Message list]*/[self getMessageListFromDataSource]);
	RETAIN(cachedCellList,[NSMutableArray array]);
	int i;
	for(i = 0;i < [messageList count];i++) {
		[cachedCellList addObject:PLACE_HOLDER];
	}
	[super reloadData];
}

-(Message*)getSelectedMessage{
	int row = [self selectedRow];
	//[table reloadCellAtRow:row column:0 animated:YES];
	if(row < 0 || row >= [messageList count]) {
		// Nothing really selected
		return nil;
	}
	return [messageList objectAtIndex:row];
}

- (void)tableRowSelected:(NSNotification *)notification {
	int row = [self selectedRow];
	if(row < 0 || row >= [messageList count]){
		// Select nothing!
		return;
	}
	if(delegate){
		//[notification userinfo:[self getSelectedMessage]];
		[delegate messageSelected:[self getSelectedMessage] atRow:[self selectedRow]];
	}
}

//===============================================
// Table Data Provider callbacks
//===============================================
- (int)numberOfRowsInTable:(UITable *)table {
	//NSLog(@"numberOfRowsInTable called, %d returned",c);
	if(messageList) {
		return [messageList count];
	} else {
		return 0;
	}
}

- (UITableCell*)table:(UITable*)table cellForRow:(int)row column:(int)column reusing:(BOOL)flag {
	LOG(@"Load cell for row %d",row);
	UITableCell *cell = nil;
	// Use cached one if possible
	if(flag) {
		if(row < [cachedCellList count]) {
			id cachedOne = [cachedCellList objectAtIndex:row];
			if(cachedOne != PLACE_HOLDER) {
				cell = cachedOne;
			}
			if(cell) {
				LOG(@"Found cached cell(0x%x) for row %d",cell,row);
				return cell;
			}
		}
	}
	// else create a new cell from scratch
	Message* msg = [messageList objectAtIndex:row];
	cell = [[UIMessageTableCell alloc] initWithMessage:msg showMessageDirection:showMessageDirection];
	[cell setDisclosureStyle: 0];
	// We will cache the newly created cell anyway
	if(row < [cachedCellList count]) {
		[cachedCellList replaceObjectAtIndex:row withObject:cell];
		LOG(@"New cell(0x%x) for row %d created and cached",cell,row);
	}
	return [cell autorelease];
}

//- (UITableCell *)table:(UITable *)atable cellForRow:(int)arow column:(int)acol {
//	return [self table:atable cellForRow:arow column:acol reusing:NO];
//}

//===============================================
// Table delegate callbacks
//===============================================
// Selection is not allowed under edit/deletion mode
- (BOOL)table: (UITable *)table canSelectRow: (int)row {
	if(delegate && [(id)delegate respondsToSelector:@selector(table:canSelectRow:)]){
		return [(id)delegate table:table canSelectRow:row];	
	}else{
		return ![self isRowDeletionEnabled];
	}
}

- (BOOL)table: (UITable *)table confirmDeleteRow: (int)row {
	if(delegate && [(id)delegate respondsToSelector:@selector(table:confirmDeleteRow:)]){
		return [(id)delegate table:table confirmDeleteRow:row];	
	}else{
		return YES;
	}
}

- (BOOL)table:(UITable*)table canMoveRow:(int)row {
	if(delegate && [(id)delegate respondsToSelector:@selector(table:canMoveRow:)]){
		return [(id)delegate table:table canMoveRow:row];	
	}else{
		return NO;
	}
}

- (BOOL)table:(UITable *)table showDisclosureForRow:(int)row {
	if(delegate && [(id)delegate respondsToSelector:@selector(table:showDisclosureForRow:)]){
		return [(id)delegate table:table showDisclosureForRow:row];	
	}else{
		return ![self isRowDeletionEnabled]; // THIS IS A SPECIAL TABLE FOR MESSAGE LIST!
	}
}

/// The delegate methods for delete operation
-(void)table: (UITable *)table willSwipeToDeleteRow:(int)row {
	DBG(@"willSwipeToDeleteRow %d",row);
	if(delegate && [(id)delegate respondsToSelector:@selector(table:willSwipeToDeleteRow:)]){
		[(id)delegate table:table willSwipeToDeleteRow:row];	
	}
	if ( row >= 0 && row < [messageList count] ) {
		Message* msg = [messageList objectAtIndex:row];//[self getSelectedMessage];
	 	if(delegate && [(id)delegate respondsToSelector:@selector(canDeleteMessage:atRow:)]){
	 		if([delegate canDeleteMessage:msg atRow:row]){
	 	        [self setDeleteConfirmationRow: row]; //Show delete button		
	 		}
	 	}
	}
}

- (BOOL)table: (UITable *)table canDeleteRow: (int)row {
	if(delegate && [(id)delegate respondsToSelector:@selector(table:canDeleteRow:)]){
		return [(id)delegate table:table canDeleteRow:row];	
	}
	
	if(row < 0 || row >= [messageList count]){
		return NO;
	}
	Message* msg = [messageList objectAtIndex:row];//[self getSelectedMessage];
	if(delegate && [(id)delegate respondsToSelector:@selector(canDeleteMessage:atRow:)]){
		return [delegate canDeleteMessage:msg atRow:row];
	}
	return NO;
}

- (void)table:(UITable*)table deleteRow:(int)row {
	Message* msg = [messageList objectAtIndex:row];//[self getSelectedMessage];
	if(delegate && [(id)delegate respondsToSelector:@selector(canDeleteMessage:atRow:)]){
		BOOL willDelete = [delegate canDeleteMessage:msg atRow:row];
		if(!willDelete){
			// The delegate takes the responsibility to notify user about why could not delete.
			return;
		}
	}
	
	if(delegate && [(id)delegate respondsToSelector:@selector(table:deleteRow:)]){
		// We have a delegate object that want handle the state
		[(id)delegate table:table deleteRow:row];
		return;
	}

	msg = [msg retain];
	// Remove the internal cached cell/data first
	[cachedCellList removeObjectAtIndex:row];
	LOG(@"Cached cell #%d is removed", row);
	[messageList removeObjectAtIndex:row];
	LOG(@"Cached message #%d is removed",row);
	
	if(delegate && [(id)delegate respondsToSelector:@selector(didDeleteMessage:atRow:)]){
		[delegate didDeleteMessage:msg atRow:row];
		[msg release];
		return;
	}
	[msg release];
	
	// What if no delegate found ? shall we will delete the message here ?
	//[message delete];
}

-(void)setDelegate:(id<UIMessageListTableDelegate>)aDelegate{
	delegate = aDelegate;
}

-(void)setDataSource:(id<UIMessageListTableDataSource>)aDataSource{
	dataSource = aDataSource;
}

-(void)setShowMessageDirection:(BOOL)value{
	showMessageDirection = value;
}

- (void)dealloc{
	RELEASE(cachedCellList);
	RELEASE(messageList);
	delegate = nil;
	dataSource = nil;
	[super dealloc];
}
@end