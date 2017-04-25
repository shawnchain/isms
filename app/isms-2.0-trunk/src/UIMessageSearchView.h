//==============================================================================
//	Created on 2007-12-6
//==============================================================================
//	$Id: UIMessageSearchView.h 251 2008-09-11 13:16:22Z shawn $
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
#ifndef UIMESSAGESEARCHVIEW_H_
#define UIMESSAGESEARCHVIEW_H_
#import "Prefix.h"
#import <UIKit/UIKit.h>
#import <UIKit/UISearchField.h>
#import "UIMessageListTable.h"

@interface UIMessageSearchField : UISearchField
- (void)fieldEditorDidBecomeFirstResponder: (id) editor;
- (void)fieldEditorDidResignFirstResponder: (id) editor;
@end
/***************************************************************
 * Extended UIView that is transition aware
 * 
 * @Author Shawn
 ***************************************************************/

@interface UIMessageSearchView : UIView <UIMessageListTableDelegate,UIMessageListTableDataSource>{
	UINavigationBar	*topBar;
	UISearchField	*searchBar;
	UIMessageListTable			*table;
	
#ifdef __BUILD_FOR_2_0__
#else
	UIKeyboard		*keyboard;
#endif
	//BOOL			keyboardVisible;
	UIView			*maskView;
	BOOL			dataIsStale;
}
+(UIMessageSearchView*)sharedInstance;
- (void)searchBarDidBecomeFirstResponder:(id)textField;
- (void)searchBarDidResignFirstResponder:(id)textField;
@end
#endif /*UIMESSAGESEARCHVIEW_H_*/
