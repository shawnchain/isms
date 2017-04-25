//
//  MessageTextViewGestures.m
//  MobileChatApp
//
//  Created by Shaun Harrison on 9/15/07.
//  Copyright 2007 twenty08. All rights reserved.
//

#import "QXGestureMaskView.h"
//#import "ExposeView.h"
//#import "Transitions.h"
//#import "BuddyList.h"

struct CGRect GSEventGetLocationInWindow(struct __GSEvent *ev);

@implementation QXGestureMaskView
- (id) initWithFrame:(struct CGRect)fp8 andScroller: (id) scroller{
	id parent = [super initWithFrame: fp8];
	_scroller = scroller;
	//_app = app;
	//_taps = 0;
	//_view = view;
	return parent;
}

- (void) doubleTap {
//	if([[[BuddyList instance] conversations] count] > 1) {
//		struct CGRect rect = [UIHardware fullScreenApplicationContentRect];
//		rect.origin.x = 0;
//		rect.origin.y = 0;
//		
//		if([_app orientation] == 90 || [_app orientation] == -90) {
//			//CoverFlow* cf = [[CoverFlow alloc] initWithFrame: [[[Transitions sharedInstance] activeView] bounds] andApp: _app andUser: [_view user]];
//			//[_app slideUp: cf];
//			// I'll get this to work sooner or later..
//		} else {
//			ExposeView* e = [[ExposeView alloc] initWithFrame: rect andApp: _app andUser: [_view user]];
//			//[e setAlpha: 0.0f];
//			[e setBounds: [[[Transitions sharedInstance] activeView] bounds]];
//			[_app slideUp: e];
//		}
//		
//		/*UIAlphaAnimation* alpha = [[UIAlphaAnimation alloc] initWithTarget: e];
//		[alpha setStartAlpha: 0.0f];
//		[alpha setEndAlpha: 1.0f];
//		[[[UIAnimator alloc] init] addAnimation:alpha withDuration:0.5f start:YES];
//		[_view addSubview: e];*/
//	}
}


- (BOOL)ignoresMouseEvents {
	//NSLog(@"MessageTextView ignore mouse events NO");
	return NO;
}

- (int)canHandleGestures {
	return YES;
}

- (void)gestureEnded:(struct __GSEvent *)event {
	[_scroller gestureEnded: event];
	isGesture = NO;
}

- (void)gestureStarted:(struct __GSEvent *)event {
	[_scroller gestureStarted: event];
	isGesture = YES; 
}

- (void)mouseDown:(struct __GSEvent *)event {
//	CGRect rect = GSEventGetLocationInWindow(event);
//	start = rect.origin;
	[_scroller mouseDown: event];
}

- (void)mouseDragged:(struct __GSEvent*)event {
	
	[_scroller mouseDragged: event];
	
//	CGRect rect = GSEventGetLocationInWindow(event);
//    CGPoint vector;
//    vector.x = rect.origin.x - start.x;
//    vector.y = rect.origin.y - start.y;
//	
//	/*
//		All credit for the math below goes to 
//		the guys over at MobileTerminal.. 
//	*/
//
//    float theta, r, absx, absy;
//    absx = (vector.x>0)?vector.x:-vector.x;
//    absy = (vector.y>0)?vector.y:-vector.y;
//    r = (absx>absy)?absx:absy;
//	theta = atan2(-vector.y, vector.x);
//
//	int zone = (int)((theta / (2 * 3.1415f * 0.125f)) + 0.5f + 4.0f);
//	
//	if([_app orientation] == 90) {
//		if (r > 15.0f && (zone == 2)) {
//			[[Transitions sharedInstance] convoFlick: 0];
//		} else if (r > 30.0f && (zone == 6)) {
//			[[Transitions sharedInstance] convoFlick: 1];
//		} else {
//			[_scroller mouseDragged: event];
//		}
//	} else if([_app orientation] == -90) {
//		if (r > 15.0f && (zone == 6)) {
//			[[Transitions sharedInstance] convoFlick: 0];
//		} else if (r > 30.0f && (zone == 0)) {
//			[[Transitions sharedInstance] convoFlick: 2];
//		} else {
//			[_scroller mouseDragged: event];
//		}
//	} else {
//		if (r > 15.0f && (zone == 4)) {
//			[[Transitions sharedInstance] convoFlick: 0];
//		} else if (r > 30.0f && (zone == 0)) {
//			[[Transitions sharedInstance] convoFlick: 1];
//		} else {
//			[_scroller mouseDragged: event];
//		}
//	}
}

- (void)mouseUp:(struct __GSEvent*)event {
	[_scroller mouseUp: event];
//	_taps++;
//	if(_taps == 2) {
//		_taps = 0;
//		[self doubleTap];
//	} else {
//		[NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(resetTaps:) userInfo:nil repeats:NO];
//		[_scroller mouseUp: event];
//	}
}

- (void) resetTaps: (NSTimer*) timer {
	//_taps = 0;
}

@end
