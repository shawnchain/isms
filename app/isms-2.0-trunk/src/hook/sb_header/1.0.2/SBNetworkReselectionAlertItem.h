/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

#import "SBPhoneAlertItem.h"

@interface SBNetworkReselectionAlertItem : SBPhoneAlertItem
{
}

+ (id)currentInstance;	// IMP=0x00065f4c
+ (BOOL)hasCurrentInstance;	// IMP=0x00065f9c
- (void)_showPrefs;	// IMP=0x00065fb4
- (void)alertSheet:(id)fp8 buttonClicked:(int)fp12;	// IMP=0x0006619c
- (void)configure:(BOOL)fp8 requirePasscodeForActions:(BOOL)fp12;	// IMP=0x000660a4
- (id)init;	// IMP=0x00065e98
- (id)lockLabel;	// IMP=0x00066014
- (void)performUnlockAction;	// IMP=0x00066070
- (void)willDeactivate:(BOOL)fp8;	// IMP=0x000661d8

@end

