/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

#import "SBDisplay.h"

@class NSMutableDictionary, SBAlertDisplay, SBAlertWindow;

@interface SBAlert : SBDisplay
{
    SBAlertDisplay *_display;	// 36 = 0x24
    NSMutableDictionary *_dictionary;	// 40 = 0x28
    SBAlertWindow *_deferredAlertWindow;	// 44 = 0x2c
}

+ (id)alertWindow;	// IMP=0x0001bd5c
+ (void)registerForAlerts;	// IMP=0x0001bcec
+ (void)test;	// IMP=0x0001bd6c
- (BOOL)activate;	// IMP=0x0001bef4
- (id)alertDisplayViewWithSize:(struct CGSize)fp8;	// IMP=0x0001bdc0
- (struct CGRect)alertWindowRect;	// IMP=0x0001be88
- (BOOL)allowsInCallStatusBar;	// IMP=0x0001c3e4
- (BOOL)allowsStackingOfAlert:(id)fp8;	// IMP=0x0001be54
- (double)animateInDuration;	// IMP=0x0001be74
- (BOOL)animatesDismissal;	// IMP=0x0001c3dc
- (float)autoDimTime;	// IMP=0x0001c3ec
- (BOOL)deactivate;	// IMP=0x0001c2a4
- (void)dealloc;	// IMP=0x0001bcf0
- (void)didAnimateLockKeypadIn;	// IMP=0x0001c408
- (void)didAnimateLockKeypadOut;	// IMP=0x0001c40c
- (void)didFinishAnimatingIn;	// IMP=0x0001c410
- (void)didFinishAnimatingOut;	// IMP=0x0001c414
- (id)display;	// IMP=0x0001bd70
- (BOOL)displaysAboveLock;	// IMP=0x0001be5c
- (float)finalAlpha;	// IMP=0x0001be6c
- (id)objectForKey:(id)fp8;	// IMP=0x0001be34
- (void)removeFromView;	// IMP=0x0001c1c0
- (void)setDisplay:(id)fp8;	// IMP=0x0001bd78
- (void)setObject:(id)fp8 forKey:(id)fp12;	// IMP=0x0001bdc8
- (int)statusBarMode;	// IMP=0x0001c3f8
- (int)statusBarOrientation;	// IMP=0x0001c400
- (void)tearDownAlertWindow:(id)fp8;	// IMP=0x0001c0f4
- (BOOL)undimsDisplay;	// IMP=0x0001be64

@end

