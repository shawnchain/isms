//==============================================================================
//	Created on 2007-12-8
//==============================================================================
//	$Id: iSMSApp.h 254 2008-09-11 16:59:32Z shawn $
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
#ifndef ISMS_H_
#define ISMS_H_

#import <CoreFoundation/CoreFoundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIApplication.h>

#define APP_RESUMED @"APP_RESUMED"

@class UIWindow;
@class UIView;
@class UIController;
@class UITransitionView;
@class NSMutableDictionary;
@class UITabBarController;

/***************************************************************
 * Class Comments
 * 
 * @Author Shawn
 ***************************************************************/
@interface iSMSApp : UIApplication{
	UIWindow 			*window;
	UITransitionView	*transitionView;
	
	NSMutableDictionary	*viewCache;
	
	BOOL willTerminate;
	BOOL messageChanged;
	int lastUnreadMsgCount;	
	UITabBarController *tabBarController;
}

+ (iSMSApp *) getInstance;

-(void)switchToViewForName:(NSString*)viewName from:(UIView*)fromView withStyle:(int) aStyle withParam:(NSMutableDictionary*)param;
-(void)switchToViewForName:(NSString*)viewName from:(UIView*)fromView withStyle:(int) aStyle;

-(void)registerViewForClassName:(NSString*)className withFrame:(CGRect) aFrame isSingleton:(BOOL) flag;
-(void)registerViewForClassName:(NSString*)className withFrame:(CGRect) aFrame;

-(void)registerView:(Class) viewClass withFrame:(CGRect) aFrame forName:(NSString*) name isSingleton:(BOOL)flag;
-(void)registerView:(Class) viewClass withFrame:(CGRect) aFrame forName:(NSString*) name;

-(void)registerViewInstance:(UIView*) aView forName:(NSString*) name;

-(UIView*)getViewForName:(NSString*)name;

-(void)applicationDidFinishLaunching:(UIApplication *)application;

-(void)_updateBadgeAndStatusBar:(BOOL)forceUpdate;
-(void)_showConversationWithPhoneNumber:(NSString*)aNumber;
-(void)_showUnreadMessages;

//- (void) acceleratedInX: (float)x Y:(float)y Z:(float)z;
- (void) updateAcceleratedInX: (float)x Y:(float)y Z:(float)z;
@end

#endif /*ISMS_H_*/
