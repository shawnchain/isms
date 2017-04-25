//==============================================================================
//	Created on 2007-12-19
//==============================================================================
//	$Id: AnimationHelper.h 75 2007-12-19 16:36:53Z shawn $
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
#ifndef ANIMATIONHELPER_H_
#define ANIMATIONHELPER_H_

#import "Prefix.h"
#import <UIKit/UIView.h>

/***************************************************************
 * Class Comments
 * 
 * @Author Shawn
 ***************************************************************/

@interface AnimationHelper : NSObject
+(void)showView:(UIView*)cView onView:(UIView*)pView animatedFrom:(CGRect)fromRect to:(CGRect)toRect withDelegate:(id)aDelegate;
+(void)showView:(UIView*)cView onView:(UIView*)pView animatedFrom:(CGRect)fromRect to:(CGRect)toRect;
+(void)hideView:(UIView*)cView animatedFrom:(CGRect)fromRect to:(CGRect)toRect withDelegate:(id)aDelegate;
+(void)hideView:(UIView*)cView animatedFrom:(CGRect)fromRect to:(CGRect)toRect;

+(void)animate:(UIView*)aView from:(CGRect) fromRect to:(CGRect)toRect withDelegate:(id)aDelegate;
+(void)animate:(UIView*)aView from:(CGRect) fromRect to:(CGRect)toRect;
@end
#endif /*ANIMATIONHELPER_H_*/
