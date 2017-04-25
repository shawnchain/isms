//==============================================================================
//	Created on 2008-1-17
//==============================================================================
//	$Id: UIPreferenceView.h 251 2008-09-11 13:16:22Z shawn $
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
#ifndef UIPREFERENCEVIEW_H_
#define UIPREFERENCEVIEW_H_

#import "Prefix.h"
#import <UIKit/UIView.h>

@class UINavigationBar;
@class UIPreferencesTable;
#ifdef __BUILD_FOR_2_0__
@class UISwitch;
#else
@class UISwitchControl;
#endif
@class UIPreferencesTableCell;
#ifdef __BUILD_FOR_2_0__
@class UIActionSheet;
#else
@class UIAlertSheet;
#endif

/***************************************************************
 * UIPreferenceView
 * 
 * @Author Shawn
 ***************************************************************/
@interface UIPreferenceView : UIView{
	UINavigationBar *navBar;
	UIPreferencesTable *table;
#ifdef __BUILD_FOR_2_0__		
	UISwitch *swConfirmBeforeSend;
	UISwitch *swUseConversationView;
	UISwitch *swHookEnabled;
	UISwitch *swDefaultApp;
	UISwitch *swNewMessagePreview;
#else
	UISwitchControl *swConfirmBeforeSend;
	UISwitchControl *swUseConversationView;
	UISwitchControl *swHookEnabled;
	UISwitchControl *swDefaultApp;
	UISwitchControl *swNewMessagePreview;
#endif	
	UIPreferencesTableCell	*cellBlackList;
	// Subviews
	UIView*	blackListView;
	
#ifdef __BUILD_FOR_2_0__
	UIActionSheet * restartAlert;
#else
	UIAlertSheet	*restartAlert;
#endif
}

-(void)save;
@end
#endif /*UIPREFERENCEVIEW_H_*/
