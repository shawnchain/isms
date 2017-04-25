//==============================================================================
//	Created on 2007-11-18
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
//  along with Foobar.  If not, see <http://www.gnu.org/licenses/>.
//==============================================================================
/*
 * Copyright WeIPhone Dev Team 
 * http://www.weiphon.com
* 
 *
 *
 *   
 *   Rev History: 
 *								 
 *    first version by laoren
 *	  guohongtao@gmail.com
 */
#import "Prefix.h"
#import <UIKit/UIView.h>

@class UITextView;
@class UIScroller;
@class UIWebView;

@interface UIAboutView : UIView {
	UITextView	*aboutField;
}

- (id)initWithFrame:(struct CGRect)frame;
- (void)dealloc;

@end