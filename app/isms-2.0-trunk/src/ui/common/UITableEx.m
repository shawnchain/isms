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
#import "UITableEx.h"
#import <UIKit/UITableCell.h>
@implementation UITable (RowSelectionEnhancement)
-(int)clearRowSelection:(BOOL)animated{
	int result = [self selectedRow];
	
	// This way will notify the rowSelecte event
	//[[self cellAtRow:[self selectedRow] column:0] setSelected:FALSE withFade:animated];
	
	if(result != NSNotFound /*&& result < [self dataSourceGetRowCount]*/) {
		// We have something selected
		// TODO handle more columns
		UITableCell* cell = (UITableCell*)[self visibleCellForRow:result column:0];
		if(cell && [cell isSelected]) {
			[cell setSelected:NO withFade:animated];
		}
		_selectedRow = NSNotFound;
	}
	return result;
}

-(int)clearRowSelection{
	return [self clearRowSelection:YES];
}

-(void)showLastRow{
	int rows = [self numberOfRows];
	if(rows>0){
		[self scrollRowToVisible: rows-1];
	}
}
@end

@implementation UITableEx : UITable
//-(int)clearRowSelection {
//	int result = _selectedRow;
//	if(_selectedRow >= 0 && _selectedRow < [self dataSourceGetRowCount]) {
//		// We have something selected
//		// TODO handle more columns
//		UITableCell* cell = (UITableCell*)[self visibleCellForRow:_selectedRow column:0];
//		if(cell && [cell isSelected]) {
//			[cell setSelected:NO withFade:NO];
//		}
//		_selectedRow = -1;
//	}
//	return result;
//}
@end