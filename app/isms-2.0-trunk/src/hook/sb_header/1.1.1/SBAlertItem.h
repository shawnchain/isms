/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

#import "NSObject.h"

@class UIAlertSheet;

@interface SBAlertItem : NSObject
{
    UIAlertSheet *_alertSheet;	// 4 = 0x4
    BOOL _disallowUnlockAction;	// 8 = 0x8
    BOOL _orderOverSBAlert;	// 9 = 0x9
}

- (id)alertSheet;	// IMP=0x000641a0
- (BOOL)allowMenuButtonDismissal;	// IMP=0x000642f4
- (double)autoDismissInterval;	// IMP=0x00064380
- (id)awayItem;	// IMP=0x00064494
- (void)cleanPreviousConfiguration;	// IMP=0x00064324
- (void)configure:(BOOL)fp8 requirePasscodeForActions:(BOOL)fp12;	// IMP=0x00064368
- (void)dealloc;	// IMP=0x00064288
- (void)didActivate;	// IMP=0x00064488
- (void)didDeactivate:(BOOL)fp8;	// IMP=0x00064490
- (BOOL)disallowsUnlockAction;	// IMP=0x00064394
- (BOOL)dismissOnLock;	// IMP=0x00064314
- (id)lockLabel;	// IMP=0x0006436c
- (float)lockLabelFontSize;	// IMP=0x00064374
- (void)performUnlockAction;	// IMP=0x00064458
- (void)setDisallowsUnlockAction:(BOOL)fp8;	// IMP=0x0006438c
- (void)setOrderOverSBAlert:(BOOL)fp8;	// IMP=0x0006445c
- (BOOL)shouldShowInEmergencyCall;	// IMP=0x00064304
- (BOOL)shouldShowInLockScreen;	// IMP=0x000642fc
- (BOOL)undimsScreen;	// IMP=0x0006430c
- (void)willActivate;	// IMP=0x00064484
- (void)willDeactivate:(BOOL)fp8;	// IMP=0x0006448c
- (BOOL)willShowInAwayItems;	// IMP=0x0006431c

@end

