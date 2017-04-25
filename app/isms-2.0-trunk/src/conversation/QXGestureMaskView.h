//
//  MessageTextViewGestures.h
//  MobileChatApp
//
//  Created by Shaun Harrison on 9/15/07.
//  Copyright 2007 twenty08. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIView.h>
#import <UIKit/UITextView.h>
#import <UIKit/UIAnimator.h>
#import <UIKit/UIAnimation.h>
#import <UIKit/UIAlphaAnimation.h>
#import <UIKit/UIView-Rendering.h>
#import <UIKit/UIView-Geometry.h>

//@class CoverFlow;

@class ISMSConversationView;
@interface QXGestureMaskView : UIView {
	BOOL isGesture;
	id _scroller;
	//struct CGPoint start;
	//id _app;
	//id _view;
	//int _taps;
}

- (id) initWithFrame:(struct CGRect)fp8 andScroller: (id) scroller;
- (void) doubleTap;
- (BOOL)ignoresMouseEvents;
- (int)canHandleGestures;
- (void)gestureEnded:(struct __GSEvent *)event;
- (void)gestureStarted:(struct __GSEvent *)event;
- (void)mouseDown:(struct __GSEvent *)event;
- (void)mouseDragged:(struct __GSEvent*)event;
- (void)mouseUp:(struct __GSEvent*)event;

@end
