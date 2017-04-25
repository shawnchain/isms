//==============================================================================
//	Created on 2008-4-11
//==============================================================================
//	$Id: ISMSConversationView.h 266 2008-09-20 13:49:22Z shawn $
//==============================================================================
//	Copyright (C) <2008>  Shawn Qian(shawn.chain@gmail.com)
//
//	This file is part of iSMS-1.0-trunk.
//
//  iSMS-1.0-trunk is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  iSMS-1.0-trunk is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with iSMS-1.0-trunk.  If not, see <http://www.gnu.org/licenses/>.
//==============================================================================
#ifndef ISMSCONVERSATIONVIEW_H_
#define ISMSCONVERSATIONVIEW_H_

#import <UIKit/UIView.h>

@class UINavigationBar;
@class UINavigationItem;
@class UITable;
@class UITextField;
@class UIKeyboard;
@class ISMSConversationModel;
@class ISMSProgressViewController;
#ifdef __BUILD_FOR_2_0__
@class UIActionSheet;
#else
@class UIAlertSheet;
#endif

@interface ISMSConversationView : UIView{
	UINavigationBar		*topBar;
	UINavigationItem	*topBarTitle;
	UITable				*table;
	UIView				*inputBar;
	UITextField			*input;
#ifdef __BUILD_FOR_2_0__
#else
	UIKeyboard			*keyboard;
#endif
	
	ISMSConversationModel	*modelData;
	
	NSMutableArray		*cells;
	ISMSProgressViewController		*progressViewController;
	BOOL				reloadingData;
	
#ifdef __BUILD_FOR_2_0__
	UIActionSheet * clearConversationAlert;
#else
	UIAlertSheet		*clearConversationAlert;
#endif
}

-(void)_createSubviews;

-(NSString*)conversationPhoneNumber;
-(void)setConversationPhoneNumber:(NSString*)aNumber;
-(void)setConversationName:(NSString*)aName phoneNumber:(NSString*)aNumber;
-(void)setConversationModel:(ISMSConversationModel*)aData;

-(void)sendMessage;
-(void)reloadData;
-(void)clearAllData;
@end

#endif /*ISMSCONVERSATIONVIEW_H_*/
