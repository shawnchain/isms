/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

#import "NSObject.h"

@class NSMutableArray, NSString, SBStatusBar, SBStatusBarContentsView, UIWindow;

@interface SBStatusBarController : NSObject
{
    UIWindow *_slidingStatusBarWindow;	// 4 = 0x4
    int _slidingStatusBarAnimation;	// 8 = 0x8
    UIWindow *_animatingCallStatusBarWindow;	// 12 = 0xc
    UIWindow *_leftBottomCorner;	// 16 = 0x10
    UIWindow *_rightBottomCorner;	// 20 = 0x14
    SBStatusBar *_statusBarView;	// 24 = 0x18
    SBStatusBarContentsView *_statusBarContentsView;	// 28 = 0x1c
    SBStatusBar *_transitioningStatusBarView;	// 32 = 0x20
    SBStatusBar *_animatingCallStatusBar;	// 36 = 0x24
    SBStatusBarContentsView *_transitioningStatusBarContentsView;	// 40 = 0x28
    unsigned int _isLocked:1;	// 44 = 0x2c
    unsigned int _lockIsChanging:1;	// 44 = 0x2c
    unsigned int _dimmed:1;	// 44 = 0x2c
    unsigned int _showDimmerOverlay:1;	// 44 = 0x2c
    unsigned int _animating:1;	// 44 = 0x2c
    unsigned int _isInCall:1;	// 44 = 0x2c
    unsigned int _airplaneMode:1;	// 44 = 0x2c
    unsigned int _showsProgress:1;	// 44 = 0x2c
    unsigned int _cloakStatusBar:1;	// 45 = 0x2d
    unsigned int _showAirport:1;	// 45 = 0x2d
    unsigned int _animateDefaultStatusBarDown:1;	// 45 = 0x2d
    unsigned int _animateDefaultStatusBarUp:1;	// 45 = 0x2d
    NSMutableArray *_statusBarIndicatorNames;	// 48 = 0x30
    int _mode;	// 52 = 0x34
    int _orientation;	// 56 = 0x38
    int _animatingCallStatusBarOrientation;	// 60 = 0x3c
    NSString *_customText;	// 64 = 0x40
    int _airPortSignalStrength;	// 68 = 0x44
    int _queuedStatusBarMode;	// 72 = 0x48
    int _queuedStatusBarOrientation;	// 76 = 0x4c
    float _duration;	// 80 = 0x50
    BOOL _telephonyControllerCheckedIn;	// 84 = 0x54
    BOOL _bluetoothControllerCheckedIn;	// 85 = 0x55
}

+ (BOOL)isLikeAFullScreenStatusBar:(int)fp8;	// IMP=0x0002d874
+ (id)sharedStatusBarController;	// IMP=0x0002d38c
+ (id)statusBarImageNamed:(id)fp8 forMode:(int)fp12;	// IMP=0x0002e970
- (void)_SIMOrServiceStatusChanged;	// IMP=0x0002de5c
- (id)_SIMStatus;	// IMP=0x0002ddec
- (void)_SIMStatusChanged:(id)fp8;	// IMP=0x0002ded4
- (void)_finishStatusBarAnimation;	// IMP=0x0002e520
- (BOOL)_isServiceAvailable;	// IMP=0x0002dd50
- (void)_serviceStatusChanged:(id)fp8;	// IMP=0x0002def0
- (void)_setStatusBarSize:(BOOL)fp8;	// IMP=0x0002f7f4
- (void)_setTransitionalStatusBarSize:(BOOL)fp8;	// IMP=0x0002f6d8
- (void)addStatusBarItem:(id)fp8;	// IMP=0x0002d5a0
- (int)airPortStrength;	// IMP=0x0002e1e0
- (BOOL)airplaneModeIsEnabled;	// IMP=0x0002dfd8
- (void)animateDefaultStatusBarDown;	// IMP=0x0002dcc4
- (void)animateDefaultStatusBarUp:(int)fp8;	// IMP=0x0002dce4
- (float)animationDuration;	// IMP=0x0002e968
- (BOOL)bluetoothControllerCheckedIn;	// IMP=0x0002ecfc
- (void)checkInController:(int)fp8;	// IMP=0x0002ec94
- (BOOL)cloakStatusBar;	// IMP=0x0002e258
- (id)customText;	// IMP=0x0002e078
- (void)dealloc;	// IMP=0x0002d3dc
- (BOOL)dimmed;	// IMP=0x0002d7f0
- (void)endCallStatusBarAnimationFinished;	// IMP=0x0002db38
- (void)finishSwitching;	// IMP=0x0002e2cc
- (id)init;	// IMP=0x000304d8
- (BOOL)isAnimatingStatusBarDown;	// IMP=0x0002dcd4
- (BOOL)isAnimatingStatusBarUp;	// IMP=0x0002dd40
- (BOOL)isInCall;	// IMP=0x0002dcb4
- (BOOL)isLockChanging;	// IMP=0x0002d700
- (BOOL)isLocked;	// IMP=0x0002d6f4
- (void)lockCurrentStatusBarForAnimation;	// IMP=0x0002e698
- (void)loopCarrierNameIfNecessary;	// IMP=0x0002ed04
- (void)orderStatusBarFront;	// IMP=0x0002e44c
- (void)preheatStatusBarForMode:(int)fp8 orientation:(int)fp12;	// IMP=0x000309b4
- (void)releaseLockedStatusBarForAnimationForDisplay:(id)fp8;	// IMP=0x0002e740
- (void)removeStatusBarItem:(id)fp8;	// IMP=0x0002dfe8
- (void)resizeStatusBar:(float)fp8 grow:(BOOL)fp12;	// IMP=0x0002fc7c
- (void)restoreLevels;	// IMP=0x0002e3d4
- (void)setAirPortStrength:(int)fp8;	// IMP=0x0002e0e8
- (void)setAirplaneModeIsEnabled:(BOOL)fp8;	// IMP=0x0002df0c
- (void)setCloakStatusBar:(BOOL)fp8;	// IMP=0x0002e200
- (void)setCustomText:(id)fp8;	// IMP=0x0002e080
- (void)setDimmed:(BOOL)fp8;	// IMP=0x0002d710
- (void)setIsInCall:(BOOL)fp8;	// IMP=0x0002db98
- (void)setIsLocked:(BOOL)fp8;	// IMP=0x0002d68c
- (void)setShowDimmerOverlay:(BOOL)fp8;	// IMP=0x0002d810
- (void)setShowsAirPort:(BOOL)fp8;	// IMP=0x0002e14c
- (void)setStatusBarMode:(int)fp8 orientation:(int)fp12 duration:(float)fp16 fenceID:(int)fp20 animation:(int)fp24;	// IMP=0x0002ed24
- (void)setupWindowForSlidingStatusBar:(id)fp8 overStatusBar:(id)fp12;	// IMP=0x0002d96c
- (BOOL)showDimmerOverlay;	// IMP=0x0002d800
- (BOOL)showsAirPort;	// IMP=0x0002e1b8
- (BOOL)showsProgress;	// IMP=0x0002e294
- (void)signalFormatChanged;	// IMP=0x0002ec64
- (void)significantTimeChange;	// IMP=0x0002ec14
- (void)statusBarDidFinishAnimatingDown;	// IMP=0x0002e3c4
- (void)statusBarDidFinishAnimatingUp;	// IMP=0x0002e43c
- (id)statusBarIndicatorNames;	// IMP=0x0002e070
- (int)statusBarMode;	// IMP=0x0002e958
- (int)statusBarOrientation;	// IMP=0x0002e960
- (id)statusBarView;	// IMP=0x0002d590
- (id)statusBarWindow;	// IMP=0x0002d570
- (void)switchBackstopFrom:(int)fp8 to:(int)fp12 fromOrientation:(int)fp16 toOrientation:(int)fp20 duration:(float)fp24 fenceID:(int)fp28 animation:(int)fp32;	// IMP=0x000309e8
- (void)tearDownWindowForSlidingStatusBar:(id)fp8 overStatusBar:(id)fp12;	// IMP=0x0002d89c
- (BOOL)telephonyControllerCheckedIn;	// IMP=0x0002ecf4
- (id)transitioningStatusBarView;	// IMP=0x0002d598
- (void)updateClockFormat;	// IMP=0x0002ec44
- (void)updateProgressVisibility;	// IMP=0x0002e264

@end
