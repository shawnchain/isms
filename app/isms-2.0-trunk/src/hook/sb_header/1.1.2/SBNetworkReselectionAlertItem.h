/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

#import "SBPhoneAlertItem.h"

@interface SBNetworkReselectionAlertItem : SBPhoneAlertItem
{
}

+ (id)currentInstance;	// IMP=0x0006c72c
+ (BOOL)hasCurrentInstance;	// IMP=0x0006c77c
- (void)_showPrefs;	// IMP=0x0006c794
- (void)alertSheet:(id)fp8 buttonClicked:(int)fp12;	// IMP=0x0006c97c
- (void)configure:(BOOL)fp8 requirePasscodeForActions:(BOOL)fp12;	// IMP=0x0006c884
- (id)init;	// IMP=0x0006c678
- (id)lockLabel;	// IMP=0x0006c7f4
- (void)performUnlockAction;	// IMP=0x0006c850
- (void)willDeactivate:(BOOL)fp8;	// IMP=0x0006c9b8

@end

