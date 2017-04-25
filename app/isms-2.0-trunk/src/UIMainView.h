//==============================================================================
//	Created on 2007-11-18
//==============================================================================
//	$Id: UIMainView.h 182 2008-03-13 10:16:18Z shawn $
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

#ifndef UIMAINVIEW_H_
#define UIMAINVIEW_H_

#import "UIButtonBarView.h"

@class UIView;



/**
 * The Main view of iSMS
 * It contains a transitionView as it's main part and a button bar at the bottom
 * 
 * @Author Shawn
 * 
 */
@interface UIMainView : UIButtonBarView {
	//UITransitionView	*_transitionView;
	//UIView				*msgMainView;
	UIView				*msgSearchView;
	
	UINavigationController *messageFolderNavCtrl;
	//UINavigationController *messageSearchNavCtrl;
	//UIView  *convListView;
	//UIView				*currentView; // Weak reference to the current view
	//NSMutableDictionary	*subviewMap; // Key is the class and value is the instance
}

+ (UIMainView *) sharedInstance;

- (id)initWithFrame:(struct CGRect)frame;
- (void)buttonBarItemTapped:(id)sender;
- (NSArray *)buttonBarItems;

//- (UITransitionView*)getTransitionView;
-(void) transition:(int)style toView:(UIView*) view;
//
//-(void) _switchToViewByClass:(Class) view;
//-(void) _switchToView:(UIView*) view;

@end
#endif /*UIMAINVIEW_H_*/
