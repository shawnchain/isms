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

- (id)alertSheet;	// IMP=0x00067708
- (BOOL)allowMenuButtonDismissal;	// IMP=0x0006785c
- (double)autoDismissInterval;	// IMP=0x000678f0
- (id)awayItem;	// IMP=0x00067a54
- (void)cleanPreviousConfiguration;	// IMP=0x00067894
- (void)configure:(BOOL)fp8 requirePasscodeForActions:(BOOL)fp12;	// IMP=0x000678d8
- (void)dealloc;	// IMP=0x000677f0
- (void)didActivate;	// IMP=0x000679f8
- (void)didDeactivateForReason:(int)fp8;	// IMP=0x00067a50
- (BOOL)disallowsUnlockAction;	// IMP=0x00067904
- (void)dismiss;	// IMP=0x00067a00
- (BOOL)dismissOnLock;	// IMP=0x00067884
- (id)lockLabel;	// IMP=0x000678dc
- (float)lockLabelFontSize;	// IMP=0x000678e4
- (void)performUnlockAction;	// IMP=0x000679c8
- (void)screenDidUndim;	// IMP=0x00067a44
- (void)screenWillUndim;	// IMP=0x00067a48
- (void)setDisallowsUnlockAction:(BOOL)fp8;	// IMP=0x000678fc
- (void)setOrderOverSBAlert:(BOOL)fp8;	// IMP=0x000679cc
- (BOOL)shouldShowInEmergencyCall;	// IMP=0x0006786c
- (BOOL)shouldShowInLockScreen;	// IMP=0x00067864
- (BOOL)undimsScreen;	// IMP=0x00067874
- (BOOL)unlocksScreen;	// IMP=0x0006787c
- (void)willActivate;	// IMP=0x000679f4
- (void)willDeactivateForReason:(int)fp8;	// IMP=0x00067a4c
- (void)willRelockForButtonPress:(BOOL)fp8;	// IMP=0x000679fc
- (BOOL)willShowInAwayItems;	// IMP=0x0006788c

@end

