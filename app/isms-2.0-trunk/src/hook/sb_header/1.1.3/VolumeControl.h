/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

#import "NSObject.h"

@class NSMutableSet, NSString, UIWindow, VolumeControlView;

@interface VolumeControl : NSObject
{
    UIWindow *_volumeWindow;	// 4 = 0x4
    VolumeControlView *_volumeView;	// 8 = 0x8
    BOOL _windowVisible;	// 12 = 0xc
    BOOL _debounce;	// 13 = 0xd
    int _mode;	// 16 = 0x10
    double _lastButtonEventTime;	// 20 = 0x14
    NSMutableSet *_alwaysHiddenCategories;	// 28 = 0x1c
    NSString *_lastDisplayedCategory;	// 32 = 0x20
    NSString *_lastEventCategory;	// 36 = 0x24
}

+ (id)sharedVolumeControl;	// IMP=0x000384c0
- (BOOL)_HUDIsDisplayableForCategory:(id)fp8;	// IMP=0x00038c68
- (BOOL)_allowVolumeChangeForCategory:(id)fp8;	// IMP=0x00038eec
- (float)_calcButtonRepeatDelay;	// IMP=0x00039094
- (void)_changeVolumeBy:(float)fp8;	// IMP=0x00038f7c
- (void)_createUI;	// IMP=0x00038890
- (void)_orderWindowFront:(id)fp8 forCategory:(id)fp12;	// IMP=0x00038d50
- (void)_orderWindowOut:(id)fp8;	// IMP=0x00038b04
- (void)_registerForAVSystemControllerNotifications;	// IMP=0x00039734
- (void)_serverConnectionDied:(id)fp8;	// IMP=0x000398d0
- (void)_systemVolumeChanged:(id)fp8;	// IMP=0x00039a20
- (void)_tearDown;	// IMP=0x00038aa8
- (void)_unregisterForAVSystemControllerNotifications;	// IMP=0x0003983c
- (int)_volumeModeForCategory:(id)fp8;	// IMP=0x00039904
- (float)_windowFadeDelay;	// IMP=0x00038d2c
- (void)addAlwaysHiddenCategory:(id)fp8;	// IMP=0x00038be4
- (void)animationDidStop:(id)fp8 finished:(id)fp12;	// IMP=0x000396a4
- (void)cancelVolumeEvent;	// IMP=0x000395ec
- (void)dealloc;	// IMP=0x00038568
- (void)decreaseVolume;	// IMP=0x000391fc
- (void)handleVolumeEvent:(struct __GSEvent *)fp8;	// IMP=0x00039488
- (void)hideHUD;	// IMP=0x0003932c
- (void)increaseVolume;	// IMP=0x00039150
- (id)init;	// IMP=0x00038510
- (id)lastDisplayedCategory;	// IMP=0x00039478
- (void)removeAlwaysHiddenCategory:(id)fp8;	// IMP=0x00038c48
- (void)reorientHUDIfNeeded:(BOOL)fp8;	// IMP=0x000385d4
- (void)setHUDMode:(int)fp8;	// IMP=0x00039480
- (void)showHUD;	// IMP=0x0003939c

@end

