/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

#import "SBAlert.h"

@interface SBCallAlert : SBAlert
{
    BOOL _causedSuspension;	// 48 = 0x30
}

+ (void)registerForAlerts;	// IMP=0x0001c418
- (void)_handleCallEvent:(struct __CTCall *)fp8;	// IMP=0x0001c8b0
- (void)_handleCallerIDEvent:(struct __CTCall *)fp8;	// IMP=0x0001c914
- (id)alertDisplayViewWithSize:(struct CGSize)fp8;	// IMP=0x0001cbfc
- (BOOL)allowsInCallStatusBar;	// IMP=0x0001ce38
- (double)animateInDuration;	// IMP=0x0001cd14
- (BOOL)animatesDismissal;	// IMP=0x0001cd28
- (void)dealloc;	// IMP=0x0001c864
- (BOOL)displaysAboveLock;	// IMP=0x0001cd0c
- (id)initWithCall:(struct __CTCall *)fp8;	// IMP=0x0001c440
- (BOOL)useUIAlertSheetWhenUnlocked;	// IMP=0x0001cd20

@end
