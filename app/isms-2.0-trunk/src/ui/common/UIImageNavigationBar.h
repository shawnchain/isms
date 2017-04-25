//==============================================================================
//	Created on 2007-12-5
//==============================================================================
//	$Id: UIImageNavigationBar.h 43 2007-12-05 13:36:08Z shawn $
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
#ifndef UIIMAGENAVIGATIONBAR_H_
#define UIIMAGENAVIGATIONBAR_H_
#import "Prefix.h"
#import <UIKit/UIKit.h>
#import <UIKit/UINavigationBar.h>

/***************************************************************
 * Class that will use image as the button
 * 
 * Use special button title to indicate the image resources.
 * 
 * For example:
 * [aBar showButtonsWithLeftTitle:@"Edit" rightTitle:img:button_compose leftBack:NO];
 * 
 * title of "img:button_compose" indicates to create a button with background image
 * the file is "button_compose.png" for state 0 and "button_compose_on.png" for state 1.
 * 
 * 
 * @Author Shawn
 ***************************************************************/
@interface UIImageNavigationBar : UINavigationBar //(ImageButton)

-(id)createButtonWithContents:(id) aid  width:(float) awidth  barStyle:(int) abarStyle  buttonStyle:(int) abuttonStyle  isRight:(BOOL) aisRight;

@end
#endif /*UIIMAGENAVIGATIONBAR_H_*/
