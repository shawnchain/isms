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

+ (id)sharedInstance;	// IMP=0x00073b20
- (void)_activationFailed;	// IMP=0x0007437c
- (BOOL)_hasEverRegistered;	// IMP=0x00073cbc
- (BOOL)_isRegisteredToNetwork;	// IMP=0x00073e20
- (void)_postAlertsIfNeeded;	// IMP=0x00073f88
- (void)_resetActivationState;	// IMP=0x00074304
- (void)_serviceAvailabilityChanged:(id)fp8;	// IMP=0x00074504
- (void)_setCurrentAlertItem:(id)fp8;	// IMP=0x00073e68
- (void)_setHasEverRegistered:(BOOL)fp8;	// IMP=0x00073dac
- (void)_setupActivationState;	// IMP=0x00074520
- (BOOL)_shouldShowTelephonyAlerts;	// IMP=0x00073f34
- (BOOL)brickedDevice;	// IMP=0x0007471c
- (void)dealloc;	// IMP=0x00074780
- (BOOL)hasOptionalPackage;	// IMP=0x000747d4
- (id)init;	// IMP=0x00073b84
- (int)lockdownState;	// IMP=0x0007474c

@end
