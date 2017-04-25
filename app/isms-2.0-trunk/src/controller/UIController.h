//==============================================================================
//	Created on 2007-11-18
//==============================================================================
//	$Id: UIController.h 251 2008-09-11 13:16:22Z shawn $
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

#ifndef UITRANSITIONSTATE_H_
#define UITRANSITIONSTATE_H_

#import <Foundation/NSObject.h>
#import "TransitionAware.h"

@class UIView;
@class UITransitionView;

/**
 * Helper class that holds the view transition state
 * 
 * @Author Shawn
 * 
 */
@interface UIController : NSObject{
	NSString			*name;
	UITransitionView	*transitionView;
	UIView				*defaultView;
	// UIView				*currentView; - to avoid warning
	id 			currentView;
	NSMutableArray		*viewArray,*styleArray; //,*transitionViewArray;
	UIView				*dummyView;
	UIView				*maskView;
}

+(id)initDefaultControllerWithTransitionView:(UITransitionView*) tview withDefaultView:(UIView*) dview;
+(void)registerController:(UIController*) aController forName:(NSString*)name;

+(UIController*)controllerForName:(NSString*)name;

+(UIController*)defaultController;
+(UIController*)rootController;

+(void)release;

-(id)initWithDefaultView:(UIView*)aView;

-(id)initWithTransitionView:(UITransitionView*)tview withDefaultView:(UIView*) dView;

-(void)showView:(UIView*)aView withStyle:(int)aStyle withParam:(NSMutableDictionary*) param;
-(void)showView:(UIView*)aView withStyle:(int)aStyle;
-(void)showView:(UIView*)aView;

-(void)showDefaultViewWithStyle:(int)aStyle;

-(void)switchToView:(UIView*)toView from:(UIView*)fromView withStyle:(int) aStyle withParam:(NSMutableDictionary*)param;
-(void)switchToView:(UIView*)toView from:(UIView*)fromView withStyle:(int) aStyle;
//-(void)switchToView:(UIView*)toView from:(UIView*)fromView withParam:(NSMutableDictionary*)param;
//-(void)switchToView:(UIView*)toView from:(UIView*)fromView;
-(void)switchToView:(UIView*)toView withParam:(NSMutableDictionary*)param;
-(void)switchToView:(UIView*)toView;

-(void)switchBackFrom:(UIView*)fromView withParam:(NSMutableDictionary*) param;
-(void)switchBackFrom:(UIView*)fromView;
-(void)switchBackWithParam:(NSMutableDictionary*) param;
-(void)switchBack;

-(void)refreshCurrentView;

-(void)clearAllState;

-(int)getOppositeStyle:(int)inValue;

-(UIView*)currentView;

-(UITransitionView*)transitionView;
-(UIView*)defaultView;
-(UIView*)maskView;

-(NSString*)name;
-(void)setName:(NSString*)value;

//-(void)pushState:(UIView*)fromView transition:(int)style;
//-(void)popState:(UIView**)fromView transition:(int*)style;
-(void) _afterTransitionFrom:(id) fromView to:(id) toView withParam:(NSMutableDictionary*) param;
-(BOOL) _beforeTransitionFrom:(id) fromView to:(id) toView withParam:(NSMutableDictionary*) param;

@end
#endif /*UITRANSITIONSTATE_H_*/
