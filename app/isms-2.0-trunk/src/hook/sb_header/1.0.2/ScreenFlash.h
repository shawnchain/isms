/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

#import "NSObject.h"

@class UIView, UIWindow;

@interface ScreenFlash : NSObject
{
    UIWindow *_flashWindow;	// 4 = 0x4
    UIView *_flashView;	// 8 = 0x8
    BOOL _windowVisible;	// 12 = 0xc
}

+ (id)sharedScreenFlash;	// IMP=0x0006ddfc
- (void)_createUI;	// IMP=0x0006de4c
- (void)_orderWindowFront:(id)fp8;	// IMP=0x0006e104
- (void)_orderWindowOut:(id)fp8;	// IMP=0x0006e02c
- (void)_tearDown;	// IMP=0x0006dfe4
- (void)animationDidStop:(id)fp8 finished:(id)fp12;	// IMP=0x0006e2d0
- (void)flash;	// IMP=0x0006e240
- (void)stopFlash;	// IMP=0x0006e1e4

@end
