//==============================================================================
//	Created on 2007-12-6
//==============================================================================
//	$Id: UIMessageListTable.h 195 2008-04-15 17:26:51Z shawn $
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
#ifndef UIMESSAGELISTTABLE_H_
#define UIMESSAGELISTTABLE_H_
#import "Prefix.h"
#import <UIKit/UIKit.h>
#import "UISwipeAwareTable.h"
#import "Message.h"

/***************************************************************
 * Customized table that display message list only.
 * 
 * Delegate method "messageSelected" will be called when a row is selected.
 * Datasource method "getMessageList" will be called when loading data;
 * 
 * @Author Shawn
 ***************************************************************/

@protocol UIMessageListTableDelegate
-(void) messageSelected:(Message*)selectedMessage atRow:(int)row;
-(BOOL) canDeleteMessage:(Message*)msg atRow:(int)row;
-(void) didDeleteMessage:(Message*)msg atRow:(int)row;
@end

@protocol UIMessageListTableDataSource
-(NSArray*) getMessageList;
@end

@interface UIMessageListTable : UISwipeAwareTable {
	id<UIMessageListTableDelegate>		delegate;
	id<UIMessageListTableDataSource>	dataSource;
	NSMutableArray	*messageList;
	NSMutableArray	*cachedCellList;
	BOOL showMessageDirection;
}

-(void)setDelegate:(id<UIMessageListTableDelegate>)aDelegate;
-(void)setDataSource:(id<UIMessageListTableDataSource>)aDataSource;
-(Message*) getSelectedMessage;
-(NSArray*) messageList;

-(void)setShowMessageDirection:(BOOL)value;
@end
#endif /*UIMESSAGELISTTABLE_H_*/
