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
#import <UIKit/UIKit.h>
#import <UIKit/UIView.h>
#import "UIMessageListTable.h"

#ifdef __BUILD_FOR_2_0__
#import <UIKit/UIAlertView.h>
#endif

/**
 * Table view that lists all messages in the phone
 * In this table view, we'll handle:
 *
 * @Author Shawn
 * 
 */
@interface MessageListView : UIView <UIMessageListTableDelegate,UIMessageListTableDataSource>{
	UINavigationBar		*topBar;
	UINavigationItem	*topBarTitle;
	UIMessageListTable	*table;
	id				_delegate;
	BOOL			editMode;
	BOOL			dataIsStale;
	BOOL			ignoreMessageChangeNotification;
	
	int				messageType;
#ifdef __BUILD_FOR_2_0__
	UIAlertView * clearListAlert;
 	UIAlertView * errorAlert;
#else
	UIAlertSheet	*clearListAlert;
	UIAlertSheet	*errorAlert;
#endif
}

//-(id)initWithFrame:(CGRect)rect;
- (id)initWithFrame:(struct CGRect)frame messageType:(int)msgType;
- (id)initWithFrame:(struct CGRect)frame messageType:(int)msgType showMessageDirection:(BOOL)value;
-(void)reloadData;
//-(void)cleanTable;
-(void)setDelegate:(id)delegate;
-(void)setMessageType:(int)type;


//// Delegated method from UITable
//-(void)tableRowSelected:(NSNotification *)notification;
//
//// Data source callbacks
//-(int)numberOfRowsInTable:(UITable *)table;
//-(UITableCell *)table:(UITable *)table cellForRow:(int)row column:(int)col;

////other callbacks
//- (BOOL)table: (UITable *)table canDeleteRow: (int)row;
//- (BOOL)table: (UITable *)table canSelectRow: (int)row;
//- (void)table:(UITable*)table deleteRow:(int)row;
//
////NOT USED YET
//- (BOOL)table:(UITable*)table canMoveRow:(int)row;
//- (BOOL)table: (UITable *)table confirmDeleteRow: (int)row;
//- (void)table: (UITable *)table willSwipeToDeleteRow:(int)row;
//- (BOOL)table:(UITable *)table showDisclosureForRow:(int)row;


@end
