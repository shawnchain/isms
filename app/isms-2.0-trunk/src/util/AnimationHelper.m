//==============================================================================
//	Created on 2007-12-19
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
//  along with iSMS.  If not, see <http://www.gnu.org/licenses/>.
//==============================================================================
#import "AnimationHelper.h"
#import <UIKit/UIKit.h>
#import <UIKit/UIFrameAnimation.h>
#import <UIKit/UIAnimator.h>

#ifdef __BUILD_FOR_2_0__
#import <UIKit/UIView-Geometry.h>
#import <UIKit/UIView-Hierarchy.h>
#endif

@interface FrameChangeAnimationCallBack : NSObject
{
	CGRect frame;
}
-(id)initWithFrame:(CGRect)rect;
@end

@implementation FrameChangeAnimationCallBack : NSObject
-(id)initWithFrame:(CGRect)rect{
	[super init];
	frame = rect;
	return self;
}
- (void)animator:(UIAnimator*)animator stopAnimation:(UIAnimation*)animation {
	UIView* aView = [animation target];
	if(aView){
		[aView setFrame:frame];
	}
}
@end

@implementation AnimationHelper

+(void)animate:(UIView*)aView from:(CGRect) fromRect to:(CGRect)toRect withDelegate:(id)aDelegate{
	NSMutableArray *animations = [[NSMutableArray alloc] init];

	CGRect startFrame = fromRect;
	CGRect endFrame = toRect;

	UIFrameAnimation *keyboardAnimation = [[UIFrameAnimation alloc] initWithTarget:aView];
	[keyboardAnimation setStartFrame:startFrame];
	[keyboardAnimation setEndFrame:endFrame];
	[keyboardAnimation setSignificantRectFields:2];

	if (aDelegate) {
		[keyboardAnimation setDelegate:aDelegate];
	}

	[animations addObject:keyboardAnimation];
	[keyboardAnimation release];

	// Start the animation
	[[UIAnimator sharedAnimator] addAnimations:animations withDuration:0.25 start:YES];
	[animations release];
}

+(void)animate:(UIView*)aView from:(CGRect) fromRect to:(CGRect)toRect{
	id delegate = [[FrameChangeAnimationCallBack alloc]initWithFrame:toRect];
	[self animate:aView from:fromRect to:toRect withDelegate:delegate];
	//[delegate autorelease];
}

+(void)showView:(UIView*)cView onView:(UIView*)pView animatedFrom:(CGRect)fromRect to:(CGRect)toRect withDelegate:(id)aDelegate {
	CGRect startFrame = fromRect;
	CGRect stopFrame = toRect;
	[cView setFrame:startFrame];
	[pView addSubview:cView];
	[self animate:cView from:startFrame to:stopFrame withDelegate:aDelegate];
}

+(void)showView:(UIView*)cView onView:(UIView*)pView animatedFrom:(CGRect)fromRect to:(CGRect)toRect {
	[self showView:cView onView:pView animatedFrom:fromRect to:toRect withDelegate:nil];
}

+(void)hideView:(UIView*)cView animatedFrom:(CGRect)fromRect to:(CGRect)toRect withDelegate:(id)aDelegate {
	[self animate:cView from:fromRect to:toRect withDelegate:aDelegate];
}

+(void)hideView:(UIView*)cView animatedFrom:(CGRect)fromRect to:(CGRect)toRect {
	id delegate = [[[AnimationHelper alloc] init] autorelease];
	[self hideView:cView animatedFrom:fromRect to:toRect withDelegate:delegate];
}

- (void)animator:(UIAnimator*)animator stopAnimation:(UIAnimation*)animation {
	UIView* aView = [animation target];
	[aView removeFromSuperview];
}

@end
