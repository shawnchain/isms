//==============================================================================
//	Created on 2008-1-3
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
#import <UIKit/UIView.h>

@class UITable;
@class UIImageView;
@class UITable;
@class UITableCell;
@class UITableColumn;

//#define UIQuickContactList @"UIQuickContactList"

@interface UIQuickContactList : UIView{
	NSArray			*searchResult;
	NSMutableArray	*tableCells;
	
	UIImageView *bgView;
	UITable *table;
	
	NSString *searchString;
	BOOL visible;
}

-(id)initWithFrame:(CGRect)rect ;
-(void)reloadData;
-(BOOL)hasResults;
-(BOOL)hasContactSelected;
-(void)setVisible:(BOOL) flag;
-(BOOL)visible;
-(void)clearAllData;

-(id)_loadTableCell:(int)row;
-(void)_selectAllContact:(BOOL)flag;

-(int)numberOfRowsInTable:(UITable *)table;
//-(UITableCell*)table:(UITable *)table cellForRow:(int)row column:(UITableColumn *)col;
-(void)tableRowSelected:(NSNotification *)notification;

-(NSArray*)selectedContacts;
-(void)setSearchString:(NSString *)aString;

-(UIView*)_createTableAccessoryView;
-(void)onFinishContactSelect;
@end