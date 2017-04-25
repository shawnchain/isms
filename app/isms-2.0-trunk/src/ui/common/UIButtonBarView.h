//==============================================================================
//	Created on 2007-11-18
//==============================================================================
//	$Id: UIButtonBarView.h 251 2008-09-11 13:16:22Z shawn $
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

#ifndef UIBUTTONBARVIEW_H_
#define UIBUTTONBARVIEW_H_

//#import <Foundation/Foundation.h>
//#import <LayerKit/LayerKit.h>
//#import <UIKit/UIKit.h>
//#import <GraphicsServices/GraphicsServices.h>
#import <UIKit/UIView.h>

#ifdef __BUILD_FOR_2_0__
@class UIToolbar;
#else
@class UIButtonBar;
#endif
@class NSArray;

/**
 * The view that with cool ButtonBar at the bottom
 * 
 * Some code is from http://www.iphonedevdoc.com/forum/showthread.php?t=147
 * 
 * @Author Shawn
 * 
 */
@interface UIButtonBarView : UIView {
#ifdef __BUILD_FOR_2_0__
	UIToolbar * _buttonBar;
#else
	UIButtonBar		*_buttonBar;
#endif
}


- (id)initWithFrame:(struct CGRect)frame;

-(void)setButtonEnabled:(int)buttonId enabled:(BOOL)flag;
-(BOOL)isButtonEnabled:(int)buttonId;

- (void)buttonBarItemTapped:(id)sender;
- (NSArray *)buttonBarItems;
- (void)reloadButtonBar;

#ifdef __BUILD_FOR_2_0__
- (UIToolbar *)createButtonBar;
- (UIToolbar *)createButtonBarSetDelegate:(id)aDelegate setBarStyle:(int)aBarStyle setButtonBarTrackingMode:(int)aTrackingMode showSelectionForButton:(int)aBtnId;
-(UIToolbar*)_buttonBar;
#else
- (UIButtonBar *)createButtonBar;
- (UIButtonBar *)createButtonBarSetDelegate:(id)aDelegate setBarStyle:(int)aBarStyle setButtonBarTrackingMode:(int)aTrackingMode showSelectionForButton:(int)aBtnId;
-(UIButtonBar*)_buttonBar;
#endif

/*
- (void)mouseDown:(struct __GSEvent *)event;
- (UITransitionView *)createTransitionView;
- (UITransitionView *)createBarTransitionView;
-(void)testAnimation;
*/

#define CB_1 0x00
#define CB_2 0x01
#define CB_3 0x02
#define CB_4 0x03
#define CB_5 0x04

extern NSString *kUIButtonBarButtonAction;
extern NSString *kUIButtonBarButtonInfo;
extern NSString *kUIButtonBarButtonInfoOffset;
extern NSString *kUIButtonBarButtonSelectedInfo;
extern NSString *kUIButtonBarButtonStyle;
extern NSString *kUIButtonBarButtonTag;
extern NSString *kUIButtonBarButtonTarget;
extern NSString *kUIButtonBarButtonTitle;
extern NSString *kUIButtonBarButtonTitleVerticalHeight;
extern NSString *kUIButtonBarButtonTitleWidth;
extern NSString *kUIButtonBarButtonType;

@end
#endif /*UIBUTTONBARVIEW_H_*/
