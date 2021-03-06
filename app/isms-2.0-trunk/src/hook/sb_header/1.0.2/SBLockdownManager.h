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
    BOOL _hasShownWaitingAlertThisSession;	// 9 = 0x9
    BOOL _hasShownMismatchedSIM;	// 10 = 0xa
    SBDismissOnlyAlertItem *_activatingAlertItem;	// 12 = 0xc
}

+ (id)sharedInstance;	// IMP=0x0006aae0
- (void)_activationChanged;	// IMP=0x0006b258
- (BOOL)_activationChecksEnabled;	// IMP=0x0006ac48
- (void)_activationFailed;	// IMP=0x0006b2d0
- (BOOL)_hasEverRegistered;	// IMP=0x0006ac50
- (BOOL)_isRegisteredToNetwork;	// IMP=0x0006adb4
- (void)_postAlertsIfNeeded;	// IMP=0x0006aec8
- (void)_serviceAvailabilityChanged:(id)fp8;	// IMP=0x0006b424
- (void)_setCurrentAlertItem:(id)fp8;	// IMP=0x0006adfc
- (void)_setHasEverRegistered:(BOOL)fp8;	// IMP=0x0006ad40
- (void)_setupActivationState;	// IMP=0x0006b440
- (BOOL)brickedDevice;	// IMP=0x0006b600
- (void)dealloc;	// IMP=0x0006b65c
- (id)init;	// IMP=0x0006ab44
- (int)lockdownState;	// IMP=0x0006b628

@end

