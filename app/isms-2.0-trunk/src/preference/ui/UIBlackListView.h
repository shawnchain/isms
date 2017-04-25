//==============================================================================
//	Created on 2008-1-30
//==============================================================================
//	$Id: UIBlackListView.h 182 2008-03-13 10:16:18Z shawn $
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
#ifndef UIBLACKLISTVIEW_H_
#define UIBLACKLISTVIEW_H_

#import <UIKit/UIView.h>

@class UINavigationBar;
@class UITable;
@interface UIBlackListView : UIView{
	UINavigationBar	*topBar;
	UITable			*table;
	UIView			*addBlackListView;
}

-(void)	_setupNavBarButton:(BOOL) isEditMode;
// Reload data and refresh the table
-(void)	_reloadData;
@end

#endif /*UIBLACKLISTVIEW_H_*/
