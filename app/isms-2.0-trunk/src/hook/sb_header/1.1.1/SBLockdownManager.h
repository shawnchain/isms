/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

#import "NSObject.h"

@class SBDismissOnlyAlertItem;

@interface SBLockdownManager : NSObject
{
    int _state;	// 4 = 0x4
    BOOL _settingUpActivationState;	// 8 = 0x8
    BOOL _isBricked;	// 9 = 0x9
    BOOL _hasShownWaitingAlertThisSession;	// 10 = 0xa
    BOOL _hasShownMismatchedSIM;	// 11 = 0xb
    SBDismissOnlyAlertItem *_activatingAlertItem;	// 12 = 0xc
}

+ (id)sharedInstance;	// IMP=0x000701f8
- (void)_activationFailed;	// IMP=0x00070a20
- (BOOL)_hasEverRegistered;	// IMP=0x00070394
- (BOOL)_isRegisteredToNetwork;	// IMP=0x000704f8
- (void)_postAlertsIfNeeded;	// IMP=0x0007060c
- (void)_resetActivationState;	// IMP=0x000709a8
- (void)_serviceAvailabilityChanged:(id)fp8;	// IMP=0x00070b94
- (void)_setCurrentAlertItem:(id)fp8;	// IMP=0x00070540
- (void)_setHasEverRegistered:(BOOL)fp8;	// IMP=0x00070484
- (void)_setupActivationState;	// IMP=0x00070bb0
- (BOOL)brickedDevice;	// IMP=0x00070dac
- (void)dealloc;	// IMP=0x00070e10
- (id)init;	// IMP=0x0007025c
- (int)lockdownState;	// IMP=0x00070ddc

@end
