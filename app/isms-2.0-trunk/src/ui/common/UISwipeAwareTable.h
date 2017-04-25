//==============================================================================
//	Created on 2007-11-18
//==============================================================================
//	$Id: UISwipeAwareTable.h 195 2008-04-15 17:26:51Z shawn $
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

#ifndef UISWIPEAWARETABLE_H_
#define UISWIPEAWARETABLE_H_

#import "UITableEx.h"

/**
 * Customized Table support "slide to delete" cool effect
 * 
 * @Author Shawn
 * 
 */
@interface UISwipeAwareTable : UITableEx{
	BOOL canHandleSwipes;
}

//-(id)initWithFrame:(CGRect) rect;
//-(int)swipe:(int)direction withEvent:(struct __GSEvent *)event;
-(void)setCanHandleSwipes:(BOOL)flag;

//- (void) animateDeletionOfRowWithCell:(id)cell;
//- (void) animateDeletionOfCellAtRow:(int)rowId column:(int)colId viaEdge:(int)edgeId;
@end
#endif /*UISWIPEAWARETABLE_H_*/
