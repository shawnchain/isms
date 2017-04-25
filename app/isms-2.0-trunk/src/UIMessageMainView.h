//==============================================================================
//	Created on 2007-12-5
//==============================================================================
//	$Id: UIMessageMainView.h 269 2008-09-21 15:40:22Z shawn $
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
#ifndef UIMESSAGEMAINVIEW_H_
#define UIMESSAGEMAINVIEW_H_

#import <UIKit/UIKit.h>
//@class UINavigationBar;
@class UITableEx;
//@class NSMutableArray;

/***************************************************************
 * Main view for the Message related feature
 * 
 * @Author Shawn
 ***************************************************************/
@interface UIMessageMainView : UIView
{
	UINavigationBar	*topBar;
	UITableEx		*table;
	
	//TODO reuse the message list view for both inbox/sent/draft messages
	//UIView			*messageListView;
	UIView			*sentMessageListView;
	UIView			*inboxMessageListView;
	UIView			*draftMessageListView;
		
	//UIView		*draftMessageListView;
	//UIView		*protectedMessageListView;
	//UIView		*searchMessageView;
	BOOL			dataIsStale;
	NSMutableArray	*tableCells;
	
//	UINavigationController	*smsNavigationController;
	UINavigationController	*composeNavigationController;
}

//@property (nonatomic, retain) UINavigationController *smsNavigationController;

+(UIMessageMainView*) sharedInstance;
-(id)initWithFrame:(struct CGRect)rect;

@end

@interface ISMSMessageFolderViewController : UIViewController
{
	
}
@end


#endif /*UIMESSAGEMAINVIEW_H_*/
